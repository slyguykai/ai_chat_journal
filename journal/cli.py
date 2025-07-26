import argparse
from rich import print
from journal import storage, ai, utils, export

def main():
    parser = argparse.ArgumentParser(prog="journal")
    sub = parser.add_subparsers(dest="command")

    write_cmd = sub.add_parser("write", help="Add a new journal entry")
    write_cmd.add_argument("text", nargs="+", help="Journal text")

    sub.add_parser("list", help="Show previous entries")
    sub.add_parser("analyze", help="Run AI analysis on new entries")
    sub.add_parser("stats", help="Show mood statistics")
    export_cmd = sub.add_parser("export", help="Export entries to Markdown")
    export_cmd.add_argument("file", help="Output .md path")

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
        pending = [e for e in entries if e.get("summary") is None]
        if not pending:
            print("No unanalyzed entries.")
            return

        for entry in pending:
            print(f"Analyzing entry {entry['id']} …", end=" ", flush=True)
            summary, mood = ai.analyse(entry["text"])
            storage.update_entry(entry["id"], summary, mood)
            print("done.")
    elif args.command == "stats":
        data = storage.list_entries()
        moods = [e["mood"] for e in data if e.get("mood") is not None]
        if not moods:
            print("No mood data yet. Run 'analyze' first.")
            return

        avg = sum(moods) / len(moods)
        best = max(moods)
        worst = min(moods)
        print(f"Entries: {len(data)}  Avg mood: {avg:.2f}  "
              f"Best: {best}  Worst: {worst}")

        # Trend sparkline
        print("Trend:", utils.sparkline(moods)) 
    elif args.command == "export":
        # Export all entries to a Markdown file
        path = export.export_markdown(args.file)
        print(f"[green]Markdown exported to {path}[/green]")
    else:
        parser.print_help()
