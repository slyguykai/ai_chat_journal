import argparse
from rich import print
from journal import storage, ai

def main():
    parser = argparse.ArgumentParser(prog="journal")
    sub = parser.add_subparsers(dest="command")

    write_cmd = sub.add_parser("write", help="Add a new journal entry")
    write_cmd.add_argument("text", nargs="+", help="Journal text")

    sub.add_parser("list", help="Show previous entries")
    sub.add_parser("analyze", help="Run AI analysis on new entries")

    args = parser.parse_args()

    if args.command == "write":
        storage.add_entry(" ".join(args.text))
        print("[green]Entry saved.[/green]")
    elif args.command == "list":
        for i, e in enumerate(storage.list_entries(), 1):
            line = f"{i}. {e['timestamp']}\n   {e['text']}"
            if e.get("summary"):
                line += f"\n   → {e['summary']} (mood {e['mood']}/10)"
            print(line + "\n")
    elif args.command == "analyze":
        entries = storage.list_entries()
        pending = [(idx, e) for idx, e in enumerate(entries) if e.get("summary") is None]
        if not pending:
            print("No unanalyzed entries.")
            return

        for idx, entry in pending:
            print(f"Analyzing entry {idx+1} …", end=" ", flush=True)
            summary, mood = ai.analyse(entry["text"])
            storage.update_entry(idx, summary, mood)
            print("done.")
    else:
        parser.print_help()