# ZGC Emergency Backup

Main plan: do not touch Codex if it already works. Install Claude only:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-claude-offline.sh | bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-ccvibe-secret.sh | bash -s -- lzcczxwzy10086
claude-use-ccvibe
claude
```

Cloudflare mirror for Claude only:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-claude-offline.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-ccvibe-secret.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash -s -- lzcczxwzy10086
claude-use-ccvibe
claude
```

General files kit, only if you need scripts/skills:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
```

Full offline clients, only if Codex or DevVPN needs repair:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-offline-clients.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
```

Claude / ccvibe only:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-ccvibe-secret.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash -s -- lzcczxwzy10086
claude-use-ccvibe
claude
```

Codex / capi repair:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-secrets.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash -s -- lzcczxwzy10086
codex-use-capi
codex-test
codex
```

DevVPN backup:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-devpn-secret.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash -s -- lzcczxwzy10086
devpn-fetch-config
```

Repo name to remember:

```text
liam-harrison1/codex-zgc-kit
```
