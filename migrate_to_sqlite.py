from pathlib import Path
import json
from journal.db import get_db, TABLE
from journal.storage import FILE_PATH  # old JSON path

db = get_db()
table = db[TABLE]

if not FILE_PATH.exists():
    print("No JSON file to migrate – nothing to do.")
    exit()

with FILE_PATH.open("r", encoding="utf-8") as f:
    data = json.load(f)

for idx, entry in enumerate(data, 1):
    # fill in missing keys (if any)
    entry.setdefault("summary", None)
    entry.setdefault("mood", None)
    entry["id"] = idx
    table.insert(entry, pk="id", replace=True)

# backup old JSON
backup = FILE_PATH.with_suffix(".json.bak")
FILE_PATH.rename(backup)
print(f"Migrated {len(data)} entries → SQLite. Original JSON backed up to {backup}.")