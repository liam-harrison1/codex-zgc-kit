#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main}"
WORK="$HOME/zgc-offline-clients"
BIN="$HOME/.local/bin"
DOWNLOADS="$HOME/Downloads"
MIHOMO_PACKAGE="mihomo-linux-amd64-compatible-v1.19.25.gz"
MIHOMO_SHA256="8d14bf2edbf2911db004abaed12754d63041eaf87e565af6f1e589883cd93ec8"
FLCLASH_PACKAGE="FlClash-0.8.92-linux-amd64.AppImage"
FLCLASH_SHA256="8f3743fe8980449329f31f8d4fbfa08b8b8be0180796ca68935dfaa9458e2f7d"

mkdir -p "$WORK" "$BIN" "$DOWNLOADS"
export PATH="$BIN:$PATH"

if ! grep -qs 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
fi

fetch() {
  name="$1"
  sha="$2"
  out="$WORK/$name"
  if [ ! -f "$out" ]; then
    echo "Downloading $name..."
    curl -fL --retry 3 --connect-timeout 10 --max-time 600 \
      "$BASE_URL/offline-clients/$name" \
      -o "$out"
  fi
  printf '%s  %s\n' "$sha" "$out" | sha256sum -c -
}

fetch "$MIHOMO_PACKAGE" "$MIHOMO_SHA256"
fetch "$FLCLASH_PACKAGE" "$FLCLASH_SHA256"

echo "Installing mihomo..."
gzip -dc "$WORK/$MIHOMO_PACKAGE" > "$BIN/mihomo"
chmod +x "$BIN/mihomo"

echo "Installing FlClash AppImage..."
install -m 755 "$WORK/$FLCLASH_PACKAGE" "$DOWNLOADS/$FLCLASH_PACKAGE"

curl -fL --retry 3 --connect-timeout 10 --max-time 60 \
  "$BASE_URL/devpn-fetch-config.sh" \
  -o "$BIN/devpn-fetch-config"
chmod +x "$BIN/devpn-fetch-config"

cat > "$BIN/devpn-run-mihomo" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
devpn-fetch-config "$HOME/Downloads/devpn-config.yaml"
echo "Starting mihomo. Leave this terminal open while using the proxy."
echo "Proxy port should be available at 127.0.0.1:8099 if the config uses mixed-port 8099."
exec mihomo -f "$HOME/Downloads/devpn-config.yaml"
EOF
chmod +x "$BIN/devpn-run-mihomo"

cat > "$BIN/devpn-shell" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export http_proxy="http://127.0.0.1:8099"
export https_proxy="http://127.0.0.1:8099"
export all_proxy="socks5://127.0.0.1:8099"
echo "Proxy env enabled in this shell:"
echo "  http_proxy=$http_proxy"
echo "  https_proxy=$https_proxy"
echo "  all_proxy=$all_proxy"
exec "${SHELL:-/bin/bash}"
EOF
chmod +x "$BIN/devpn-shell"

echo
echo "OK: VPN tools installed without touching Codex."
echo "Installed commands:"
echo "  mihomo"
echo "  devpn-fetch-config"
echo "  devpn-run-mihomo"
echo "  devpn-shell"
echo
echo "FlClash AppImage:"
echo "  $DOWNLOADS/$FLCLASH_PACKAGE"
