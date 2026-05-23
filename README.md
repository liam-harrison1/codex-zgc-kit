# Codex ZGC Kit

Ubuntu one-line installer for the training machine.

## Tomorrow Plan

Use Claude Code / Cloud through ccvibe first. Keep Codex on its original route unless it needs repair.

1. Download the files kit:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install.sh | bash
```

2. Restore only the Claude / ccvibe key if this is a fresh Ubuntu machine:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-secrets.sh | bash -s -- --ccvibe-only lzcczxwzy10086
```

3. Configure Claude Code / Cloud through ccvibe:

```bash
claude-use-ccvibe
claude
```

4. Leave Codex alone if it already works. Only repair Codex if needed:

```bash
codex-test
codex
```

## Install

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install.sh | bash
```

If local keys are missing, restore the encrypted secret bundle:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-secrets.sh | bash -s -- lzcczxwzy10086
```

To restore only the Claude / ccvibe key and leave Codex untouched:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-secrets.sh | bash -s -- --ccvibe-only lzcczxwzy10086
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

## Notes

This repository intentionally does not contain plaintext API keys, activation codes, `auth.json`, `sub2api-key`, or `ccvibe-key`.

If `codex-use-capi` says `~/.codex/auth.json` is missing, either restore the encrypted secret bundle above, or create it locally on the Ubuntu machine:

```bash
mkdir -p ~/.codex
cat > ~/.codex/auth.json <<'EOF'
{"OPENAI_API_KEY":"PASTE_ACTIVATION_CODE_HERE"}
EOF
chmod 600 ~/.codex/auth.json
```

If `codex-use-sub2api` says `~/.codex/sub2api-key` is missing, restore the encrypted secret bundle above.

If `claude-use-ccvibe` says `~/.codex/ccvibe-key` is missing, restore only the Claude / ccvibe key with `--ccvibe-only`.
