#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main}"
WORK="$HOME/zgc-offline-clients"
BIN="$HOME/.local/bin"
DOWNLOADS="$HOME/Downloads"

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

fetch "openai-codex-0.130.0-linux-x64.tgz" "91e12a56c49c702c86c5c42811cfa3d515b6d6bc196d70ba9cea25227302aa8f"
fetch "claude-code-linux-x64-2.1.150.tgz" "980c2d6157a8325c6a93dd838c92987cb80dc7f1815c4b03fccf5da136101fa6"
fetch "mihomo-linux-amd64-compatible-v1.19.25.gz" "8d14bf2edbf2911db004abaed12754d63041eaf87e565af6f1e589883cd93ec8"
fetch "FlClash-0.8.92-linux-amd64.AppImage" "8f3743fe8980449329f31f8d4fbfa08b8b8be0180796ca68935dfaa9458e2f7d"

echo "Installing Codex CLI..."
rm -rf "$WORK/openai-codex"
mkdir -p "$WORK/openai-codex"
tar -xzf "$WORK/openai-codex-0.130.0-linux-x64.tgz" -C "$WORK/openai-codex"
chmod +x "$WORK/openai-codex/package/vendor/x86_64-unknown-linux-musl/codex/codex"
ln -sf "$WORK/openai-codex/package/vendor/x86_64-unknown-linux-musl/codex/codex" "$BIN/codex"

echo "Installing Claude Code..."
rm -rf "$WORK/claude-code"
mkdir -p "$WORK/claude-code"
tar -xzf "$WORK/claude-code-linux-x64-2.1.150.tgz" -C "$WORK/claude-code"
install -m 755 "$WORK/claude-code/package/claude" "$BIN/claude"

echo "Installing mihomo..."
gzip -dc "$WORK/mihomo-linux-amd64-compatible-v1.19.25.gz" > "$BIN/mihomo"
chmod +x "$BIN/mihomo"

echo "Installing FlClash AppImage..."
install -m 755 "$WORK/FlClash-0.8.92-linux-amd64.AppImage" "$DOWNLOADS/FlClash-0.8.92-linux-amd64.AppImage"

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

echo
echo "OK: offline clients installed."
echo "Installed commands:"
echo "  codex"
echo "  claude"
echo "  mihomo"
echo "  devpn-run-mihomo"
echo
echo "FlClash AppImage:"
echo "  $DOWNLOADS/FlClash-0.8.92-linux-amd64.AppImage"
echo
echo "No sudo or system node/npm is required for these installed binaries."
