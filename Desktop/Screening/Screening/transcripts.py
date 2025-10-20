import requests
import os
import csv
from dotenv import load_dotenv
load_dotenv()


# Your Vapi API Authorization token
AUTH_TOKEN = os.getenv("VAPI_API_KEY")
# Directory to save individual transcripts
output_folder = "vapi_transcripts"
os.makedirs(output_folder, exist_ok=True)

# CSV file to store summary of all transcripts
csv_file = os.path.join(output_folder, "transcripts_summary.csv")

headers = {"Authorization": f"Bearer {AUTH_TOKEN}"}

print("📞 Fetching all calls from Vapi...")

# ✅ Step 1: Get all calls
response = requests.get("https://api.vapi.ai/call", headers=headers)

if response.status_code != 200:
    print(f"❌ Error fetching calls: {response.status_code} - {response.text}")
    exit()

calls = response.json()
print(f"✅ Total calls fetched: {len(calls)}")

# ✅ Step 2: Create CSV for transcript summary
with open(csv_file, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["Call ID", "Transcript Path"])

    for call in calls:
        call_id = call.get("id")
        transcript = call.get("transcript", "")

        # Save each transcript as a text file
        transcript_path = os.path.join(output_folder, f"{call_id}.txt")
        with open(transcript_path, "w", encoding="utf-8") as tf:
            tf.write(transcript if transcript else "No transcript found.")

        writer.writerow([call_id, transcript_path])

print(f"📁 All transcripts saved in: {output_folder}")
print(f"🗂️ Summary CSV: {csv_file}")



