"""
journal.db – central place for the SQLite connection.
"""
from pathlib import Path
import sqlite_utils

DB_PATH = Path.home() / ".ai_chat_journal.db"
TABLE = "entries"

def get_db() -> sqlite_utils.Database:
    db = sqlite_utils.Database(DB_PATH)
    if TABLE not in db.table_names():
        db[TABLE].create(
            {
                "id": int,
                "timestamp": str,
                "text": str,
                "summary": str,
                "mood": int,
            },
            pk="id",
            not_null={"timestamp", "text"},
        )
    return db