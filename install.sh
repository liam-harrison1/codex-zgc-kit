#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main"
SHA256="ed3bc2ed8ceb1e670653a7dfa289fc8591b38e7714e81afaae49b49fb967b93a"

mkdir -p "$HOME/codex-files"
cd "$HOME/codex-files"

echo "[1/3] Downloading Codex files kit..."
curl -fL --retry 3 --connect-timeout 10 --max-time 180 \
  "$BASE_URL/codex-files-kit.tar.gz" \
  -o codex-files-kit.tar.gz

echo "[2/3] Verifying package..."
printf '%s  %s\n' "$SHA256" "codex-files-kit.tar.gz" | sha256sum -c -

echo "[3/3] Installing..."
rm -rf codex-files-kit
tar -xzf codex-files-kit.tar.gz
bash codex-files-kit/install.sh

mkdir -p "$HOME/.local/bin"
curl -fL --retry 3 --connect-timeout 10 --max-time 60 \
  "$BASE_URL/claude-use-ccvibe.sh" \
  -o "$HOME/.local/bin/claude-use-ccvibe"
chmod +x "$HOME/.local/bin/claude-use-ccvibe"

echo
echo "Done. Try:"
echo "  codex-use-capi"
echo "  codex-test"
echo "  claude-use-ccvibe"
