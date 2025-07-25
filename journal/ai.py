"""
journal.ai
-----------
Single responsibility: talk to the OpenAI API and return
(summary, mood_score) tuples. Keeps all external-service logic
in one place, so the rest of the app stays testable/offline.
"""
import json
from typing import Tuple

from dotenv import load_dotenv
from openai import OpenAI, RateLimitError, APIConnectionError
from tenacity import retry, wait_exponential, stop_after_attempt

# Load variables from .env (OPENAI_API_KEY) into the process environment
load_dotenv()

# Initialising once is more efficient than constructing per call
client = OpenAI()  # uses the OPENAI_API_KEY env var automatically

SYSTEM_PROMPT = (
    "You are an assistant that analyses a personal journal entry.\n"
    "Return JSON with keys 'summary' (2–3 sentences) and 'mood' "
    "(an integer 1–10 where 1 is very negative and 10 is very positive).\n"
    "Respond with JSON ONLY."
)

@retry(
    retry=lambda exc: isinstance(exc, (RateLimitError, APIConnectionError)),
    wait=wait_exponential(min=1, max=20),
    stop=stop_after_attempt(3),
)
def analyse(text: str) -> Tuple[str, int]:
    """
    Send `text` to OpenAI and return (summary, mood_score).
    Retries on transient network / rate-limit errors.
    """
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": text},
        ],
        temperature=0.5,
    )
    raw = response.choices[0].message.content.strip()

    # The model should reply with JSON. Parse defensively.
    try:
        data = json.loads(raw)
        summary = data["summary"]
        mood = int(data["mood"])
    except Exception:
        summary = raw  # fallback: treat the whole reply as summary
        mood = 5       # neutral baseline
    return summary, mood