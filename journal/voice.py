"""
journal.voice
-------------
Record microphone audio and return the Whisper transcript.
"""

from pathlib import Path
from tempfile import NamedTemporaryFile
from datetime import datetime

import sounddevice as sd
import soundfile as sf
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()           # so OPENAI_API_KEY is in env
client = OpenAI()       # Whisper and chat share the same client

SAMPLE_RATE = 16_000    # Whisper works well at 16 kHz mono


def record_audio(duration: int, out_path: Path) -> None:
    """Capture microphone audio for `duration` seconds to WAV @16 kHz mono."""
    print(f"Recording {duration} s… Speak now.")
    audio = sd.rec(int(duration * SAMPLE_RATE), samplerate=SAMPLE_RATE, channels=1)
    sd.wait()           # block until recording finishes
    sf.write(out_path, audio, SAMPLE_RATE, subtype="PCM_16")
    print(f"Wrote {out_path}")


def transcribe(path: Path) -> str:
    """Send the WAV file to Whisper and return the transcript."""
    print("Sending to Whisper…")
    with open(path, "rb") as f:
        resp = client.audio.transcriptions.create(
            model="whisper-1",
            file=f,
            response_format="text"
        )
    return resp.strip()


def record_and_transcribe(duration: int) -> str:
    """High-level helper used by CLI."""
    with NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        wav_path = Path(tmp.name)
    record_audio(duration, wav_path)
    text = transcribe(wav_path)
    wav_path.unlink(missing_ok=True)  # delete temp file
    return text
