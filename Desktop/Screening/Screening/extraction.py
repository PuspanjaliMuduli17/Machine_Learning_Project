from fireworks.client import Fireworks
import os
import json

# Initialize the Fireworks client
fw = Fireworks(api_key=os.getenv("FIREWORKS_API_KEY"))

# Load your transcript (assuming it's a text file inside vapi_transcript folder)
with open("vapi_transcript/sample_transcript.txt", "r") as f:
    transcript = f.read()

# Prompt
EXTRACTION_PROMPT = f"""
You are an assistant that reads interview transcripts between an interviewer and a candidate.
Extract the following structured information clearly:

- Candidate Name
- Current Company
- Current Role
- Years of Experience
- Current CTC (LPA)
- Expected CTC (LPA)
- Notice Period (days)
- Work Preference (Remote/Onsite/Hybrid)
- Primary Technical Skills
- Summary of the candidate (2-3 lines)

Return output as a valid JSON.
Transcript:
{transcript}
"""

# Send to Fireworks
response = fw.chat.completions.create(
    model="accounts/fireworks/models/llama-v3p1-70b-instruct",
    messages=[{"role": "user", "content": EXTRACTION_PROMPT}],
    temperature=0.2,
)

# Extract and format output
result = response.choices[0].message.content
print("\n--- Extracted Details ---\n")
try:
    data = json.loads(result)
    for key, value in data.items():
        print(f"{key}: {value}")
except:
    print(result)
