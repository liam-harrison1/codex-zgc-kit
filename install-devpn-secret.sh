#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main}"
SHA256="c04dfaeb1ef0c28df4d4533105757f59e289e89df26d611b33617ef34f848f11"
PASS="${1:-}"

if [ -z "$PASS" ]; then
  printf "Password: "
  stty -echo
  read -r PASS
  stty echo
  printf "\n"
fi

mkdir -p "$HOME/.config/devpn"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "[1/3] Downloading encrypted secrets..."
curl -fL --retry 3 --connect-timeout 10 --max-time 120 \
  "$BASE_URL/codex-secrets.tar.gz.enc" \
  -o "$tmp/codex-secrets.tar.gz.enc"

echo "[2/3] Verifying encrypted package..."
printf '%s  %s\n' "$SHA256" "$tmp/codex-secrets.tar.gz.enc" | sha256sum -c -

echo "[3/3] Decrypting and installing DevVPN subscription only..."
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -in "$tmp/codex-secrets.tar.gz.enc" \
  -out "$tmp/codex-secrets.tar.gz" \
  -pass "pass:$PASS"

tar -xzf "$tmp/codex-secrets.tar.gz" -C "$tmp"
install -m 600 "$tmp/codex-secrets/devpn-sub-url" "$HOME/.config/devpn/sub-url"

echo "OK: installed ~/.config/devpn/sub-url only; Codex was not modified"
