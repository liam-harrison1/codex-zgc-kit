#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main}"
WORK="$HOME/zgc-offline-clients"
BIN="$HOME/.local/bin"
CLAUDE_PACKAGE="claude-code-linux-x64-2.1.150.tgz"
CLAUDE_SHA256="980c2d6157a8325c6a93dd838c92987cb80dc7f1815c4b03fccf5da136101fa6"

mkdir -p "$WORK" "$BIN"
export PATH="$BIN:$PATH"

if ! grep -qs 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
fi

package_path="$WORK/$CLAUDE_PACKAGE"
if [ ! -f "$package_path" ]; then
  echo "Downloading $CLAUDE_PACKAGE..."
  curl -fL --retry 3 --connect-timeout 10 --max-time 600 \
    "$BASE_URL/offline-clients/$CLAUDE_PACKAGE" \
    -o "$package_path"
fi

printf '%s  %s\n' "$CLAUDE_SHA256" "$package_path" | sha256sum -c -

echo "Installing Claude Code only..."
rm -rf "$WORK/claude-code"
mkdir -p "$WORK/claude-code"
tar -xzf "$package_path" -C "$WORK/claude-code"
install -m 755 "$WORK/claude-code/package/claude" "$BIN/claude"

curl -fL --retry 3 --connect-timeout 10 --max-time 60 \
  "$BASE_URL/claude-use-ccvibe.sh" \
  -o "$BIN/claude-use-ccvibe"
chmod +x "$BIN/claude-use-ccvibe"

echo
echo "OK: Claude Code installed without touching Codex."
echo "Installed commands:"
echo "  claude"
echo "  claude-use-ccvibe"
echo
echo "Next:"
echo "  install-ccvibe-secret.sh, then claude-use-ccvibe"
