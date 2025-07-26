"""
journal.export
--------------
Export all journal entries to a Markdown file.

Usage from other modules:
    from journal import export
    export.export_markdown("my_journal.md")
"""

from pathlib import Path
import tempfile
import markdown2
from weasyprint import HTML
from journal.db import get_db, TABLE

def export_markdown(path: str | Path) -> Path:
    """Write a Markdown file containing all entries; return Path object."""
    db = get_db()
    rows = list(db[TABLE].rows)

    md_lines = [
        "# AI Chat Journal Export",
        "",
        f"_Total entries: {len(rows)}_",
        "",
    ]

    for entry in rows:
        md_lines.extend(
            [
                f"## {entry['timestamp']}",
                "",
                entry["text"],
                "",
            ]
        )

        if entry.get("summary"):
            md_lines.extend(
                [
                    f"> **AI Summary (mood {entry['mood']}/10)**",
                    f"> {entry['summary']}",
                    "",
                ]
            )

    out_path = Path(path).expanduser()
    out_path.write_text("\n".join(md_lines), encoding="utf-8")
    return out_path


# PDF export helper
def export_pdf(pdf_path: str | Path, md_path: str | Path | None = None) -> Path:
    """
    Convert Markdown to PDF. If md_path is None, generate Markdown first.
    Requires wkhtmltopdf to be installed and on PATH.
    """
    md_path = Path(md_path) if md_path else None

    # If no Markdown file supplied, create a temporary one
    if md_path is None:
        tmp = tempfile.NamedTemporaryFile(suffix=".md", delete=False)
        md_path = Path(tmp.name)
        export_markdown(md_path)

    # Convert Markdown -> HTML -> PDF using WeasyPrint
    html = markdown2.markdown(md_path.read_text(encoding="utf-8"))
    pdf_output = Path(pdf_path).expanduser().with_suffix(".pdf")
    HTML(string=html).write_pdf(str(pdf_output))
    return pdf_output
