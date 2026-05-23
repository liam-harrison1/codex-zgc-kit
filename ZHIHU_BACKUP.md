# ZGC Emergency Backup

If GitHub works, use the main repo:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install.sh | bash
```

If there is no Node.js, no npm command, and no sudo:

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-offline-clients.sh | bash
```

If GitHub does not work but this Mac is still awake, use the Cloudflare file mirror:

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
```

Cloudflare offline clients:

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
