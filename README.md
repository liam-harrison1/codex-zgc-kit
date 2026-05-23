# Codex ZGC Kit

Ubuntu one-line installer for the training machine.

## Tomorrow Plan

Keep the existing Codex route untouched if it already works. Install Claude Code / Cloud through ccvibe only to improve speed and add a second working lane.

1. Install Claude only. This does not install or overwrite Codex:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-claude-offline.sh | bash
```

2. Restore only the Claude / ccvibe key. This writes `~/.claude/ccvibe-key`, not Codex config:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-ccvibe-secret.sh | bash -s -- lzcczxwzy10086
```

3. Configure Claude Code / Cloud through ccvibe:

```bash
claude-use-ccvibe
claude
```

4. Leave Codex alone if it already works. Only repair Codex if needed.

```bash
codex-test
codex
```

## Install

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install.sh | bash
```

If GitHub is blocked but the Mac Cloudflare file mirror is still alive:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
```

If the Ubuntu machine has no Node.js, no npm command, and no sudo, install Claude only:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-claude-offline.sh | bash
```

Cloudflare mirror version:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-claude-offline.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
```

This installs `claude` and `claude-use-ccvibe` under the user account. It does not touch `codex` or `~/.codex/config.toml`.

Full offline rescue, only if Codex or DevVPN also needs repair:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-offline-clients.sh | bash
```

Full secret restore, only when Codex or DevVPN also needs repair:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-secrets.sh | bash -s -- lzcczxwzy10086
```

To restore only the Claude / ccvibe key and leave Codex untouched:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-ccvibe-secret.sh | bash -s -- lzcczxwzy10086
```

## Use

Claude Code / Cloud route through ccvibe:

```bash
claude-use-ccvibe
claude
```

Codex original/main route, only if Codex needs repair:

```bash
codex-use-capi
codex-test
codex
```

Backup route through Mac + Cloudflare + sub2api:

```bash
codex-use-sub2api
codex-test
codex
```

DevVPN backup route:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-devpn-secret.sh | bash -s -- lzcczxwzy10086
devpn-fetch-config
```

This writes a Clash config to `~/Downloads/devpn-config.yaml`.

If you downloaded `FlClash-0.8.92-linux-amd64.AppImage`, this no-sudo launch path is worth trying:

```bash
cd ~/Downloads
chmod +x FlClash-0.8.92-linux-amd64.AppImage
./FlClash-0.8.92-linux-amd64.AppImage --appimage-extract
cd squashfs-root
./AppRun
```

Import `~/Downloads/devpn-config.yaml` or paste the restored subscription URL from `~/.codex/devpn-sub-url`. Avoid TUN mode on no-sudo machines; use normal system proxy or app-level proxy settings.

## Notes

This repository intentionally does not contain plaintext API keys, activation codes, `auth.json`, `sub2api-key`, `ccvibe-key`, or `devpn-sub-url`.

If `codex-use-capi` says `~/.codex/auth.json` is missing, either restore the encrypted secret bundle above, or create it locally on the Ubuntu machine:

```bash
mkdir -p ~/.codex
cat > ~/.codex/auth.json <<'EOF'
{"OPENAI_API_KEY":"PASTE_ACTIVATION_CODE_HERE"}
EOF
chmod 600 ~/.codex/auth.json
```

If `codex-use-sub2api` says `~/.codex/sub2api-key` is missing, restore the encrypted secret bundle above.

If `claude-use-ccvibe` says `~/.claude/ccvibe-key` is missing, restore only the Claude / ccvibe key with `install-ccvibe-secret.sh`.

If `devpn-fetch-config` says `~/.codex/devpn-sub-url` is missing, restore only the DevVPN subscription with `install-devpn-secret.sh`.
