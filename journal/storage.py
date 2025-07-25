from pathlib import Path
import json
from datetime import datetime
from dateutil import tz

FILE_PATH = Path.home() / ".ai_chat_journal.json"

def _load():
    if FILE_PATH.exists():
        with FILE_PATH.open("r", encoding="utf-8") as f:
            return json.load(f)
    return []

def _save(data):
    with FILE_PATH.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

def add_entry(text: str) -> None:
    entry = {
        "timestamp": datetime.now(tz.tzlocal()).isoformat(),
        "text": text,
    }
    data = _load()
    data.append(entry)
    _save(data)

def list_entries():
    return _load()