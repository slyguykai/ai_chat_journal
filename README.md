A CLI‑first journaling app that now stores entries in a local **SQLite** database, can record **voice notes** (OpenAI Whisper), generates AI summaries + mood scores, shows stats in a **Streamlit** dashboard, and exports/imports Markdown or PDF files.

## How it works
* `storage.py`  – reads/writes the `~/.ai_chat_journal.db` SQLite file  
* `ai.py`       – calls OpenAI (GPT + Whisper) for summaries, mood, transcription  
* `cli.py`      – command‑line interface (`write`, `voice`, `list`, `analyze`, `stats`, `export`, `import`)  
* `export.py`   – Markdown + PDF exporter  
* `import_md.py` – Markdown importer (round‑trip support)  
* `voice.py`    – records microphone audio and transcribes with Whisper  
* `dashboard.py` – Streamlit front‑end with charts & filters  
* `utils.py`    – helper for Unicode sparklines

## Roadmap
* Encryption (SQLCipher)  
* Tagging & advanced search filters  
* Unit tests + GitHub Actions CI  
* Mobile wrapper (BeeWare or React Native)  
* Daily reminder notifications

## Features

| Command / UI      | What it does                                            |
|-------------------|---------------------------------------------------------|
| `write`           | Add a new text journal entry                            |
| `voice`           | Record audio, transcribe with Whisper, save entry       |
| `list`            | Display all entries, summaries, and mood                |
| `analyze`         | Generate AI summary & mood for entries missing them     |
| `stats`           | Show entry count, average mood, best/worst, sparkline   |
| `export`          | Export to Markdown; `--pdf` also creates PDF            |
| `import`          | Import entries from a Markdown file                     |
| **Streamlit UI**  | `streamlit run dashboard.py` – interactive dashboard    |

## Setup

```bash
git clone https://github.com/<YOUR-USERNAME>/ai_chat_journal.git
cd ai_chat_journal
python3 -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt
# or:
pip install openai python-dateutil rich python-dotenv tenacity \
             sqlite-utils streamlit pandas altair \
             sounddevice soundfile markdown2 weasyprint
```

## Usage examples

```bash
# Text entry
python main.py write "Met Sam for lunch; feeling great!"

# Voice entry (15‑second recording)
python main.py voice --duration 15

# Summaries & mood
python main.py analyze

# Dashboard
streamlit run dashboard.py

# Export files
python main.py export my_journal --pdf

# Import back
python main.py import my_journal.md
```
