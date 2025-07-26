import argparse
from pathlib import Path
from rich import print
from journal import storage, ai, utils, export, import_md, voice

def main():
    parser = argparse.ArgumentParser(prog="journal")
    sub = parser.add_subparsers(dest="command")

    write_cmd = sub.add_parser("write", help="Add a new journal entry")
    write_cmd.add_argument("text", nargs="+", help="Journal text")

    sub.add_parser("list", help="Show previous entries")
    sub.add_parser("analyze", help="Run AI analysis on new entries")
    sub.add_parser("stats", help="Show mood statistics")
    export_cmd = sub.add_parser("export", help="Export entries to Markdown / PDF")
    export_cmd.add_argument("file", help="Base filename (without extension or with .md)")
    export_cmd.add_argument("--pdf", action="store_true", help="Also create PDF alongside Markdown")
    import_cmd = sub.add_parser("import", help="Import entries from Markdown")
    import_cmd.add_argument("file", help="Path to .md file exported earlier")

    voice_cmd = sub.add_parser("voice", help="Record audio and transcribe into a new entry")
    voice_cmd.add_argument("--duration", type=int, default=30,
                           help="Recording length in seconds (default 30)")

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
        # Determine Markdown path
        base = Path(args.file).expanduser()
        md_path = base.with_suffix(".md") if base.suffix.lower() != ".md" else base

        md_path = export.export_markdown(md_path)
        print(f"[green]Markdown exported to {md_path}[/green]")

        if args.pdf:
            try:
                pdf_path = export.export_pdf(md_path.with_suffix(".pdf"), md_path)
                print(f"[green]PDF exported to {pdf_path}[/green]")
            except Exception as exc:
                print(f"[red]PDF export failed: {exc}[/red]")
    elif args.command == "import":
        try:
            added = import_md.import_markdown(args.file)
            print(f"[green]{added} new entries imported[/green]")
        except Exception as exc:
            print(f"[red]Import failed: {exc}[/red]")
    elif args.command == "voice":
        text = voice.record_and_transcribe(args.duration)
        if not text.strip():
            print("[yellow]No speech detected; entry not saved.[/yellow]")
        else:
            storage.add_entry(text.strip())
            print("[green]Voice entry saved![/green]")
    else:
        parser.print_help()
