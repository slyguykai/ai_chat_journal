"""
journal.storage
---------------
All persistence logic for AI Chat Journal.

Switched from plain JSON to SQLite (see journal.db).
"""
from datetime import datetime
from dateutil import tz

from journal.db import get_db, TABLE

# Single shared connection and table handle
db = get_db()
table = db[TABLE]


def add_entry(text: str) -> None:
    """Insert a new journal entry into the SQLite table."""
    entry = {
        "timestamp": datetime.now(tz.tzlocal()).isoformat(),
        "text": text,
        "summary": None,
        "mood": None,
    }
    table.insert(entry)  # SQLite assigns an auto‑increment id


def list_entries():
    """Return all entries as a list of dicts ordered by primary key."""
    return list(table.rows)


def update_entry(entry_id: int | str, summary: str, mood: int) -> None:
    """Update a single row identified by its primary‑key id."""
    table.update(int(entry_id), {"summary": summary, "mood": mood})

def update_text(entry_id: int | str, new_text: str) -> None:
    """Update only the text field for a given entry id."""
    table.update(int(entry_id), {"text": new_text})