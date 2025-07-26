"""
Streamlit dashboard for AI Chat Journal
Run with:
    streamlit run dashboard.py
"""
from __future__ import annotations

from datetime import datetime
from pathlib import Path

import pandas as pd
import altair as alt
import streamlit as st

from journal.db import get_db, TABLE
from journal import storage, ai, export

# ---------- Helpers ---------------------------------------------------------

@st.cache_resource(show_spinner=False)
def _get_table():
    """Return sqlite-utils Table handle (cached)."""
    db = get_db()
    return db[TABLE]


def fetch_df() -> pd.DataFrame:
    """Load all entries into a DataFrame sorted by timestamp."""
    rows = list(_get_table().rows)
    if not rows:
        return pd.DataFrame(
            columns=["id", "timestamp", "text", "summary", "mood"]
        )
    df = pd.DataFrame(rows)
    df["timestamp"] = pd.to_datetime(df["timestamp"], errors="coerce")
    return df.sort_values("timestamp")


def analyze_missing(df: pd.DataFrame):
    """Run AI on rows with no summary/mood."""
    missing = df[df["summary"].isna()]
    if missing.empty:
        st.toast("Nothing to analyze ✨", icon="✅")
        return
    progress = st.progress(0, text="Analyzing entries…")
    for idx, row in enumerate(missing.itertuples(index=False), start=1):
        summary, mood = ai.analyse(row.text)
        storage.update_entry(row.id, summary, mood)
        progress.progress(idx / len(missing))
    progress.empty()
    st.toast("Analysis complete!", icon="🤖")
    st.experimental_rerun()

# ---------- Layout ---------------------------------------------------------

st.set_page_config(page_title="AI Chat Journal", layout="wide")
st.title("📓 AI Chat Journal Dashboard")

# Sidebar — filters & actions
st.sidebar.header("Filters & Actions")

df_all = fetch_df()

# Date range widget
if not df_all.empty:
    date_min = df_all["timestamp"].min().date()
    date_max = df_all["timestamp"].max().date()
else:
    date_min = date_max = datetime.today().date()

start_date, end_date = st.sidebar.date_input(
    "Date range", (date_min, date_max),
    min_value=date_min, max_value=date_max
)

search_term = st.sidebar.text_input("Text search")
show_missing = st.sidebar.checkbox("Show only unanalyzed")

if st.sidebar.button("Analyze missing entries"):
    analyze_missing(df_all)

# Export buttons
if st.sidebar.button("Export Markdown & PDF"):
    md = export.export_markdown("journal_export.md")
    pdf = export.export_pdf("journal_export.pdf", md)
    st.sidebar.download_button("Download Markdown", md.read_bytes(), "journal.md")
    st.sidebar.download_button("Download PDF", pdf.read_bytes(), "journal.pdf")

# Add-entry expander
with st.sidebar.expander("➕ Add new entry"):
    new_text = st.text_area("Your entry", height=120)
    if st.button("Save entry"):
        if new_text.strip():
            storage.add_entry(new_text.strip())
            st.success("Entry saved!")
            st.experimental_rerun()
        else:
            st.warning("Cannot save an empty entry.")

# ---------- Data filtering ----------

mask = (df_all["timestamp"].dt.date.between(start_date, end_date))
if search_term:
    mask &= df_all["text"].str.contains(search_term, case=False, na=False)
if show_missing:
    mask &= df_all["summary"].isna()

df = df_all[mask]

# ---------- Main: mood chart + entries ----------

left, right = st.columns([1.8, 2.2])

with left:
    st.subheader("Mood over time")
    if df["mood"].dropna().empty:
        st.info("No mood data in this range.")
    else:
        chart = (
            alt.Chart(df.dropna(subset=["mood"]))
            .mark_line(point=True)
            .encode(
                x="timestamp:T",
                y=alt.Y("mood:Q", scale=alt.Scale(domain=[0, 10])),
            )
        )
        st.altair_chart(chart, use_container_width=True)

with right:
    st.subheader("Entries")
    if df.empty:
        st.info("No entries match the filters.")
    else:
        for row in df.itertuples(index=False):
            label = f"{row.timestamp.strftime('%Y-%m-%d %H:%M')} — mood {row.mood if pd.notna(row.mood) else 'N/A'}"
            with st.expander(label):
                st.write(row.text)
                if pd.notna(row.summary):
                    st.markdown(f"> {row.summary}")