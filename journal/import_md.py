"""
journal.import_md
-----------------
Parse a Markdown file (as exported by export_markdown) and insert
entries into the SQLite DB if they don't already exist.
"""
import re
from pathlib import Path
from journal.db import get_db, TABLE

HEADING_RE = re.compile(r"^## (.+)$")  # captures timestamp
SUMMARY_RE = re.compile(r"^> \*\*AI Summary \(mood (\d+)/10\)\*\*$")

def import_markdown(md_path: str | Path) -> int:
    db = get_db()
    table = db[TABLE]

    md_text = Path(md_path).expanduser().read_text(encoding="utf-8").splitlines()
    added = 0

    i = 0
    while i < len(md_text):
        m = HEADING_RE.match(md_text[i])
        if not m:
            i += 1
            continue

        timestamp = m.group(1).strip()
        i += 2  # skip blank line after heading

        text_lines = []
        while i < len(md_text) and not md_text[i].startswith("##"):
            if md_text[i].startswith(">"):  # summary block starts
                break
            text_lines.append(md_text[i])
            i += 1

        text = "\n".join(line.rstrip() for line in text_lines).strip()

        summary = None
        mood = None
        if i < len(md_text) and SUMMARY_RE.match(md_text[i]):
            mood = int(SUMMARY_RE.match(md_text[i]).group(1))
            i += 1
            # next line is the actual summary text prefixed with '>'
            if i < len(md_text) and md_text[i].startswith("> "):
                summary = md_text[i][2:].strip()
                i += 1
            # skip until blank line
            while i < len(md_text) and md_text[i]:
                i += 1
        # move past any additional blank lines
        while i < len(md_text) and not md_text[i]:
            i += 1

        # Skip if timestamp already exists
        if table.exists(timestamp=timestamp):
            continue

        table.insert(
            {
                "timestamp": timestamp,
                "text": text,
                "summary": summary,
                "mood": mood,
            },
            pk="id",
        )
        added += 1

    return added
