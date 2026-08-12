#!/bin/bash
set -euo pipefail

# Usage: run.sh /path/to/your/vault/Notes/Things3\ Export.md
# Edit the default below to your own vault path, or always pass it as $1.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_NOTE="${1:-/path/to/your/vault/Notes/Things3 Export.md}"
RAW_TSV="$(mktemp)"

osascript "$SCRIPT_DIR/things_export.applescript" > "$RAW_TSV"
python3 "$SCRIPT_DIR/build_things_note.py" "$RAW_TSV" "$OUT_NOTE"
rm -f "$RAW_TSV"
