A command-line journaling tool that stores your daily entries in a local JSON
file and uses OpenAI to generate short summaries and 1-to-10 mood scores for
each entry. It also provides quick statistics and a unicode sparkline of your
mood trend.

## How it works
	•	storage.py – reads/writes ~/.ai_chat_journal.json.
	•	ai.py – sends each entry’s text to OpenAI (gpt-3.5-turbo by default) and returns {"summary": "...", "mood": 7}.
	•	cli.py – parses commands and orchestrates storage + AI logic.
	•	utils.py – tiny helper to render mood values as a sparkline.

## Roadmap
	•	SQLite backend
	•	Streamlit front-end with charts
	•	Voice-to-text (Whisper) entry option
	•	Mobile wrapper (e.g. BeeWare or React Native)
## Features

| Command        | What it does                                   |
| -------------- | ---------------------------------------------- |
| `write`        | Add a new journal entry.                       |
| `list`         | Display all entries, summaries, and mood.      |
| `analyze`      | Call OpenAI for any entry that lacks a summary |
| `stats`        | Show entry count, average mood, best/worst, trend sparkline |

## Setup

```bash
git clone https://github.com/<YOUR-USERNAME>/ai_chat_journal.git
cd ai_chat_journal
python3 -m venv .venv
source .venv/bin/activate     # Windows: .venv\Scripts\activate
pip install -r requirements.txt   # or: pip install openai python-dateutil rich python-dotenv tenacity

# Add an entry
python main.py write "Had coffee with Alex; feeling productive today."

# Generate summaries and mood scores
python main.py analyze

# View everything
python main.py list

# Quick statistics
python main.py stats

