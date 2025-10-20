import requests
import os
import sys
from dotenv import load_dotenv

load_dotenv()

# Configuration - Edit these details for each candidate
CANDIDATE_INFO = {
    "phoneNumber": "+91XXXXXXXXXX",  # Replace with actual candidate phone number
    "candidateName": "Puja",
    "companyName": "MAS",
    "role": "Data Science"
}

# This will be replaced with CSV file data later

SERVER_URL = os.getenv("SERVER_URL", "http://localhost:3000")

def initiate_call():
    try:
        print("\n🚀 Starting interview call process...\n")
        print("Candidate Details:")
        print(f"  Name: {CANDIDATE_INFO['candidateName']}")
        print(f"  Phone: {CANDIDATE_INFO['phoneNumber']}")
        print(f"  Role: {CANDIDATE_INFO['role']}")
        print(f"  Company: {CANDIDATE_INFO['companyName']}\n")

        response = requests.post(
            f"{SERVER_URL}/call",
            json=CANDIDATE_INFO,
            headers={"Content-Type": "application/json"}
        )
        response.raise_for_status()
        
        data = response.json()

        if data.get("success"):
            print("✅ SUCCESS!")
            print(f"   Call ID: {data.get('callId')}")
            print(f"   Message: {data.get('message')}\n")
            print("📞 The candidate should receive a call shortly...\n")
        else:
            print("⚠️  Call initiated but success flag not confirmed")
            print(f"   Response: {data}\n")

    except requests.exceptions.HTTPError as e:
        print("\n❌ ERROR initiating call:")
        print(f"   Status: {e.response.status_code}")
        try:
            error_data = e.response.json()
            print(f"   Message: {error_data.get('error', e.response.text)}")
        except:
            print(f"   Message: {e.response.text}")
        print()
        sys.exit(1)
        
    except requests.exceptions.ConnectionError:
        print("\n❌ ERROR initiating call:")
        print("   No response from server. Is it running?")
        print(f"   Make sure server is running at {SERVER_URL}")
        print()
        sys.exit(1)
        
    except requests.exceptions.RequestException as e:
        print("\n❌ ERROR initiating call:")
        print(f"   {str(e)}")
        print()
        sys.exit(1)
        
    except Exception as e:
        print("\n❌ ERROR initiating call:")
        print(f"   {str(e)}")
        print()
        sys.exit(1)

if __name__ == "__main__":
    initiate_call()