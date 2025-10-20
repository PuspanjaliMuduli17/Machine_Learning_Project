from flask import Flask, request, jsonify
import os
import json
from datetime import datetime
from pathlib import Path
from dotenv import load_dotenv
import requests

load_dotenv()

app = Flask(__name__)

# Create transcripts directory if it doesn't exist
TRANSCRIPTS_DIR = "./transcripts"
Path(TRANSCRIPTS_DIR).mkdir(exist_ok=True)
print("📁 Transcripts directory ready")

# Vapi configuration
VAPI_API_KEY = os.getenv("VAPI_API_KEY")
VAPI_BASE_URL = "https://api.vapi.ai"
ASSISTANT_ID = os.getenv("MASIGHT_ASSISTANT_ID")
PHONE_NUMBER_ID = os.getenv("VAPI_PHONE_NUMBER_ID")

# Headers for Vapi API requests
def get_headers():
    return {
        "Authorization": f"Bearer {VAPI_API_KEY}",
        "Content-Type": "application/json"
    }

@app.route("/call", methods=["POST"])
def create_call():
    try:
        data = request.json
        phone_number = data.get("phoneNumber")
        candidate_name = data.get("candidateName")
        company_name = data.get("companyName")
        role = data.get("role")

        if not phone_number:
            return jsonify({"error": "phoneNumber is required"}), 400

        print(f"📞 Initiating call to {candidate_name or 'candidate'}...")
        print(f"   Phone: {phone_number}")
        print(f"   Company: {company_name or 'MASight'}")
        print(f"   Role: {role or 'Unknown'}")

        # Prepare call payload
        payload = {
            "assistantId": ASSISTANT_ID,
            "customer": {
                "number": phone_number
            },
            "assistantOverrides": {
                "variableValues": {
                    "candidateName": candidate_name or "Unknown",
                    "companyName": company_name or "MASight",
                    "role": role or "Unknown"
                }
            }
        }

        # Add phone number ID if available
        if PHONE_NUMBER_ID:
            payload["phoneNumberId"] = PHONE_NUMBER_ID

        # Make API call to Vapi
        response = requests.post(
            f"{VAPI_BASE_URL}/call",
            headers=get_headers(),
            json=payload
        )
        response.raise_for_status()
        
        call_data = response.json()
        call_id = call_data.get("id")

        print(f"✅ Call initiated successfully!")
        print(f"   Call ID: {call_id}")
        
        return jsonify({
            "success": True,
            "callId": call_id,
            "message": f"Call initiated to {candidate_name or phone_number}"
        })

    except requests.exceptions.RequestException as e:
        print(f"❌ Error starting call: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            print(f"Full error: {e.response.text}")
            return jsonify({"error": e.response.text}), 500
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        print(f"❌ Error starting call: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "ok", "message": "Server is running"})

@app.route("/webhook", methods=["POST"])
def webhook():
    try:
        event = request.json
        event_type = event.get("type", "unknown event")
        
        print(f"\n📨 Webhook received: {event_type}")

        # Handle transcript events
        if event_type == "transcript":
            transcript_text = event.get("transcript", "")
            print(f"💬 Transcript: {transcript_text}")

        # Handle call ended event - save full transcript
        if event_type in ["end-of-call-report", "call.ended"]:
            print("\n📝 Call ended - Saving transcript...")
            
            call_data = event.get("call", event)
            call_id = call_data.get("id") or event.get("callId", "unknown")
            timestamp = datetime.now().isoformat().replace(":", "-").replace(".", "-")
            
            # Save text transcript
            filename = f"transcript_{call_id}_{timestamp}.txt"
            filepath = os.path.join(TRANSCRIPTS_DIR, filename)
            transcript_content = format_transcript(event)
            
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(transcript_content)
            
            print(f"✅ Transcript saved: {filepath}")
            
            # Save JSON data
            json_filename = f"transcript_{call_id}_{timestamp}.json"
            json_filepath = os.path.join(TRANSCRIPTS_DIR, json_filename)
            
            with open(json_filepath, "w", encoding="utf-8") as f:
                json.dump(event, f, indent=2)
            
            print(f"✅ JSON data saved: {json_filepath}\n")

        return jsonify({"received": True}), 200

    except Exception as e:
        print(f"❌ Webhook error: {str(e)}")
        return jsonify({"error": str(e)}), 500

def format_transcript(event):
    """Format transcript for readable text file"""
    call_data = event.get("call", event)
    content = []

    content.append("=" * 60)
    content.append("INTERVIEW CALL TRANSCRIPT")
    content.append("=" * 60)
    content.append("")

    content.append(f"Call ID: {call_data.get('id', 'N/A')}")
    content.append(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    duration = call_data.get("duration")
    if not duration and call_data.get("endedAt") and call_data.get("startedAt"):
        duration = call_data["endedAt"] - call_data["startedAt"]
    content.append(f"Duration: {duration or 'N/A'} seconds")
    
    content.append(f"Status: {call_data.get('status', 'completed')}")
    
    phone = call_data.get("phoneNumber") or call_data.get("customer", {}).get("number")
    if phone:
        content.append(f"Phone Number: {phone}")
    
    content.append("")
    content.append("-" * 60)
    content.append("CONVERSATION TRANSCRIPT")
    content.append("-" * 60)
    content.append("")

    # Extract messages/transcript
    messages = call_data.get("messages")
    if messages and isinstance(messages, list):
        for msg in messages:
            role = msg.get("role", "System")
            if role == "assistant":
                role = "AI Assistant"
            elif role == "user":
                role = "Candidate"
            
            message_content = msg.get("content") or msg.get("message", "")
            content.append(f"[{role}]: {message_content}")
            content.append("")
    elif call_data.get("transcript"):
        content.append(call_data["transcript"])
        content.append("")
    elif call_data.get("recording"):
        content.append(f"Recording URL: {call_data['recording']}")
        content.append("")
    else:
        content.append("No transcript available in this event.")
        content.append("")

    content.append("-" * 60)
    content.append("CALL ANALYSIS")
    content.append("-" * 60)
    content.append("")

    analysis = call_data.get("analysis")
    if analysis:
        content.append(f"Summary: {analysis.get('summary', 'N/A')}")
        content.append(f"Sentiment: {analysis.get('sentiment', 'N/A')}")

    cost = call_data.get("cost")
    if cost:
        content.append(f"\nCall Cost: ${cost}")

    content.append("")
    content.append("=" * 60)
    content.append("END OF TRANSCRIPT")
    content.append("=" * 60)

    return "\n".join(content)

if __name__ == "__main__":
    PORT = int(os.getenv("PORT", 3000))
    
    print("\n" + "=" * 50)
    print("📞 MASight Screening Server Started")
    print("=" * 50)
    print(f"🌐 Server: http://localhost:{PORT}")
    print(f"✅ Health: http://localhost:{PORT}/health")
    print(f"📱 Call API: POST http://localhost:{PORT}/call")
    print(f"🔔 Webhook: POST http://localhost:{PORT}/webhook")
    print(f"📁 Transcripts: ./{TRANSCRIPTS_DIR}/")
    print("=" * 50 + "\n")
    
    app.run(host="0.0.0.0", port=PORT, debug=False)