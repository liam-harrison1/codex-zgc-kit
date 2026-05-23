#!/usr/bin/env bash
set -euo pipefail

KEY_FILE="$HOME/.claude/ccvibe-key"
LEGACY_KEY_FILE="$HOME/.codex/ccvibe-key"
SETTINGS_DIR="$HOME/.claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

if [ ! -s "$KEY_FILE" ]; then
  if [ -s "$LEGACY_KEY_FILE" ]; then
    KEY_FILE="$LEGACY_KEY_FILE"
  else
    echo "ERROR: $KEY_FILE not found."
    echo "Run install-ccvibe-secret.sh first to restore the encrypted ccvibe key."
    exit 1
  fi
fi

mkdir -p "$SETTINGS_DIR"
if [ -f "$SETTINGS_FILE" ]; then
  cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak.$(date +%Y%m%d-%H%M%S)"
fi

KEY="$(tr -d '\r\n' < "$KEY_FILE")"
python3 - "$SETTINGS_FILE" "$KEY" <<'PY'
import json
import sys
from pathlib import Path

settings_file = Path(sys.argv[1])
key = sys.argv[2]
data = {}
if settings_file.exists():
    try:
        data = json.loads(settings_file.read_text())
    except Exception:
        data = {}

env = data.setdefault("env", {})
env["ANTHROPIC_BASE_URL"] = "https://cc-vibe.com"
env["ANTHROPIC_AUTH_TOKEN"] = key
env["CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC"] = "1"
env["CLAUDE_CODE_ATTRIBUTION_HEADER"] = "0"

settings_file.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
PY

chmod 600 "$SETTINGS_FILE"
echo "OK: Claude Code configured for ccvibe in ~/.claude/settings.json"
echo "Next: restart terminal, then run: claude"
