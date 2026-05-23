#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main}"
SHA256="c04dfaeb1ef0c28df4d4533105757f59e289e89df26d611b33617ef34f848f11"
MODE="all"
PASS=""

for arg in "$@"; do
  case "$arg" in
    --ccvibe-only)
      MODE="ccvibe"
      ;;
    *)
      PASS="$arg"
      ;;
  esac
done

if [ -z "$PASS" ]; then
  printf "Password: "
  stty -echo
  read -r PASS
  stty echo
  printf "\n"
fi

if [ "$MODE" = "all" ]; then
  mkdir -p "$HOME/.codex" "$HOME/.claude"
else
  mkdir -p "$HOME/.claude"
fi
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "[1/3] Downloading encrypted secrets..."
curl -fL --retry 3 --connect-timeout 10 --max-time 120 \
  "$BASE_URL/codex-secrets.tar.gz.enc" \
  -o "$tmp/codex-secrets.tar.gz.enc"

echo "[2/3] Verifying encrypted package..."
printf '%s  %s\n' "$SHA256" "$tmp/codex-secrets.tar.gz.enc" | sha256sum -c -

echo "[3/3] Decrypting and installing local secrets..."
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -in "$tmp/codex-secrets.tar.gz.enc" \
  -out "$tmp/codex-secrets.tar.gz" \
  -pass "pass:$PASS"

tar -xzf "$tmp/codex-secrets.tar.gz" -C "$tmp"
if [ "$MODE" = "all" ]; then
  install -m 600 "$tmp/codex-secrets/auth.json" "$HOME/.codex/auth.json"
  install -m 600 "$tmp/codex-secrets/sub2api-key" "$HOME/.codex/sub2api-key"
  install -m 600 "$tmp/codex-secrets/devpn-sub-url" "$HOME/.codex/devpn-sub-url"
fi
install -m 600 "$tmp/codex-secrets/ccvibe-key" "$HOME/.claude/ccvibe-key"

if [ "$MODE" = "all" ]; then
  echo "OK: installed ~/.codex/auth.json, ~/.codex/sub2api-key, ~/.codex/devpn-sub-url, and ~/.claude/ccvibe-key"
else
  echo "OK: installed ~/.claude/ccvibe-key only; Codex was not modified"
fi
