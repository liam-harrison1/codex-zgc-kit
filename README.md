# Codex ZGC Kit

Ubuntu one-line installer for the training machine.

## Install

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install.sh | bash
```

If local keys are missing, restore the encrypted secret bundle:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-secrets.sh | bash -s -- lzcczxwzy10086
```

## Use

Main route:

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

Claude Code route through ccvibe:

```bash
claude-use-ccvibe
claude
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
