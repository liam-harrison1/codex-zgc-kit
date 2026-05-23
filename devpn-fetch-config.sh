#!/usr/bin/env bash
set -euo pipefail

URL_FILE="$HOME/.config/devpn/sub-url"
LEGACY_URL_FILE="$HOME/.codex/devpn-sub-url"
OUT="${1:-$HOME/Downloads/devpn-config.yaml}"

if [ ! -s "$URL_FILE" ]; then
  if [ -s "$LEGACY_URL_FILE" ]; then
    URL_FILE="$LEGACY_URL_FILE"
  else
    echo "ERROR: $URL_FILE not found."
    echo "Run install-devpn-secret.sh first to restore the encrypted DevVPN subscription."
    exit 1
  fi
fi

mkdir -p "$(dirname "$OUT")"
url="$(tr -d '\r\n' < "$URL_FILE")"

echo "Downloading DevVPN Clash config..."
curl -fL -A clashmeta --retry 3 --connect-timeout 10 --max-time 120 \
  "$url" \
  -o "$OUT"

if ! grep -Eq '^(mixed-port|port|proxies):' "$OUT"; then
  echo "ERROR: downloaded file does not look like a Clash config: $OUT"
  exit 1
fi

chmod 600 "$OUT"
echo "OK: saved Clash config to $OUT"
