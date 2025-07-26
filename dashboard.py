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

# ---------- Custom CSS & fonts ----------
st.markdown(
    """
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap');
    html, body, [class*="css"]  {
        font-family: 'Inter', sans-serif;
    }
    section[data-testid="stSidebar"] > div:first-child {
        width: 260px;   /* narrower sidebar */
    }
    .journal-card {
        background: #FFFFFF;
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        padding: 1rem 1.25rem;
        box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        margin-bottom: 0.8rem;
    }
    .journal-card h5 { margin: 0 0 0.3rem 0; font-size: 1.05rem; }
    .journal-card p  { margin: 0 0 0.4rem 0; line-height: 1.35; }
    </style>
    """,
    unsafe_allow_html=True,
)

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
    st.rerun()

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

if st.sidebar.button("✨ Analyze missing", type="primary"):
    analyze_missing(df_all)

# Export buttons
if st.sidebar.button("🗄️ Export MD + PDF", type="primary"):
    md = export.export_markdown("journal_export.md")
    pdf = export.export_pdf("journal_export.pdf", md)
    st.sidebar.download_button("Download Markdown", md.read_bytes(), "journal.md")
    st.sidebar.download_button("Download PDF", pdf.read_bytes(), "journal.pdf")

# Add-entry expander
with st.sidebar.expander("➕ Add new entry"):
    new_text = st.text_area("Your entry", height=120)
    if st.button("💾 Save entry", type="primary"):
        if new_text.strip():
            storage.add_entry(new_text.strip())
            st.success("Entry saved!")
            st.rerun()
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

left, right = st.columns([1, 2])

with left:
    st.subheader("Mood over time")
    if df["mood"].dropna().empty:
        st.info("No mood data in this range.")
    else:
        chart = (
            alt.Chart(df.dropna(subset=["mood"]))
            .mark_line(point=True, color="#14B8A6")   # teal accent
            .encode(
                x="timestamp:T",
                y=alt.Y("mood:Q", scale=alt.Scale(domain=[0, 10])),
            )
        )
        st.altair_chart(chart, use_container_width=True)

with right:
    st.subheader("Entries")
    if df.empty:
        st.markdown(
            """<div style="text-align:center;">
            <img src="https://raw.githubusercontent.com/streamlit/streamlit/develop/examples/data/happy-face.png"
                 width="140" alt="No data"/>
            <p style="font-size:1.1rem;">No entries match the filters.</p>
            </div>""",
            unsafe_allow_html=True,
        )
    else:
        for row in df.itertuples(index=False):
            editing = st.session_state.get("edit_id") == row.id

            if editing:
                new_txt = st.text_area(
                    "Edit entry",
                    value=st.session_state.get("edit_text", row.text),
                    height=120,
                    key=f"ta-{row.id}"
                )
                colA, colB = st.columns([1, 1])
                if colA.button("💾 Save", key=f"save-{row.id}", type="primary"):
                    storage.update_text(row.id, new_txt)
                    st.session_state.pop("edit_id", None)
                    st.session_state.pop("edit_text", None)
                    st.rerun()
                if colB.button("↩️ Cancel", key=f"cancel-{row.id}"):
                    st.session_state.pop("edit_id", None)
                    st.session_state.pop("edit_text", None)
                    st.rerun()
            else:
                st.markdown(
                    f"""
                    <div class="journal-card">
                        <h5>{row.timestamp:%Y-%m-%d %H:%M} — mood {row.mood if pd.notna(row.mood) else 'N/A'}</h5>
                        <p>{row.text}</p>
                        {f"<blockquote>{row.summary}</blockquote>" if pd.notna(row.summary) else ""}
                    </div>
                    """,
                    unsafe_allow_html=True,
                )
                if st.button("✏️ Edit", key=f"edit-{row.id}"):
                    st.session_state["edit_id"] = row.id
                    st.session_state["edit_text"] = row.text
                    st.rerun()