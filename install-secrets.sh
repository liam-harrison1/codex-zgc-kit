#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main"
SHA256="3e8fcfb65a9ccb2a69276f5f01b1e058da199ee9b7dc57a3786328a25d8b6293"
PASS="${1:-}"

if [ -z "$PASS" ]; then
  printf "Password: "
  stty -echo
  read -r PASS
  stty echo
  printf "\n"
fi

mkdir -p "$HOME/.codex"
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
install -m 600 "$tmp/codex-secrets/auth.json" "$HOME/.codex/auth.json"
install -m 600 "$tmp/codex-secrets/sub2api-key" "$HOME/.codex/sub2api-key"
if [ -f "$tmp/codex-secrets/ccvibe-key" ]; then
  install -m 600 "$tmp/codex-secrets/ccvibe-key" "$HOME/.codex/ccvibe-key"
fi

echo "OK: installed ~/.codex/auth.json, ~/.codex/sub2api-key, and ~/.codex/ccvibe-key"
