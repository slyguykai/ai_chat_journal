from pathlib import Path
import json
from datetime import datetime
from dateutil import tz

FILE_PATH = Path.home() / ".ai_chat_journal.json"

def _load():
    """
    Load the journal data from disk.
    Adds 'summary' and 'mood' keys to any entry that predates
    the AI integration so code elsewhere doesn't raise KeyError.
    """
    if FILE_PATH.exists():
        with FILE_PATH.open("r", encoding="utf-8") as f:
            data = json.load(f)

        # Back‑fill for legacy entries
        for entry in data:
            entry.setdefault("summary", None)
            entry.setdefault("mood", None)

        return data

    return []

def _save(data):
    with FILE_PATH.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

def add_entry(text: str) -> None:
    entry = {
        "timestamp": datetime.now(tz.tzlocal()).isoformat(),
        "text": text,
        "summary": None,  # AI‑generated 2–3 sentence recap
        "mood": None,     # AI‑generated score 1‑10
    }
    data = _load()
    data.append(entry)
    _save(data)

def list_entries():
    return _load()


def update_entry(index: int, summary: str, mood: int) -> None:
    """
    Update the entry at `index` with AI‑generated `summary` and `mood`,
    then save the modified list back to disk.
    """
    data = _load()
    data[index]["summary"] = summary
    data[index]["mood"] = mood
    _save(data)