import argparse
from rich import print
from journal import storage

def main():
    parser = argparse.ArgumentParser(prog="journal")
    sub = parser.add_subparsers(dest="command")

    write_cmd = sub.add_parser("write", help="Add a new journal entry")
    write_cmd.add_argument("text", nargs="+", help="Journal text")

    sub.add_parser("list", help="Show previous entries")

    args = parser.parse_args()

    if args.command == "write":
        storage.add_entry(" ".join(args.text))
        print("[green]Entry saved.[/green]")
    elif args.command == "list":
        for i, entry in enumerate(storage.list_entries(), start=1):
            print(f"[bold]{i}. {entry['timestamp']}[/bold]\n   {entry['text']}\n")
    else:
        parser.print_help()