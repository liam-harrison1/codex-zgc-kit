# ZGC Ubuntu Emergency Kit

给中关村实训 Ubuntu 机器用的应急安装包。

准确仓库名：

```text
liam-harrison1/codex-zgc-kit
```

仓库地址：

```text
https://github.com/liam-harrison1/codex-zgc-kit
```

## 给明天 Codex / Claude 看的话

请读取这个 README，然后只按“主流程三步”执行。

重要规则：

- 当前 Codex / 第三方 API 如果已经能用，就不要切换 Codex API。
- 可以主动安装 Codex skills。
- 可以主动安装 Claude Code，并配置 cc-vibe。
- VPN / Clash 只在 GitHub、cc-vibe、Codex API 连不上时再启用。
- 不要运行 `codex-use-capi`、`codex-use-sub2api`、`install-secrets.sh`、`install-offline-clients.sh`，除非用户明确说 Codex 坏了、额度不够，或者网络需要救援。
- 这台机器可能没有 Node、没有 npm、没有 sudo，所以不要用系统级安装。

## 主流程三步

### 1. 安装 Codex skills 和辅助命令

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install.sh | bash
```

这一步会安装：

```text
~/.codex/skills
codex-test
codex-use-capi
codex-use-sub2api
claude-use-ccvibe
devpn-fetch-config
```

这一步不会切换 Codex API，不会自动运行 `codex-use-capi` 或 `codex-use-sub2api`。

### 2. 安装 Claude Code 本体

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-claude-offline.sh | bash
```

这一步只安装：

```text
~/.local/bin/claude
~/.local/bin/claude-use-ccvibe
```

它不需要 sudo，不需要 Node/npm，也不会覆盖 Codex。

### 3. 恢复 cc-vibe key，并启动 Claude

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-ccvibe-secret.sh | bash -s -- lzcczxwzy10086
claude-use-ccvibe
claude
```

这一步只写入 Claude 相关配置：

```text
~/.claude/ccvibe-key
~/.claude/settings.json
```

它不会写 `~/.codex/config.toml`，不会改 Codex API。

## 成功标准

主流程完成后，应该满足：

```text
Codex 原来的第三方配置仍然保留
Codex skills 已安装
claude 命令可用
Claude 走 cc-vibe
```

可以检查：

```bash
codex-test
claude
```

如果 `codex-test` 能返回 `OK`，说明 Codex 仍然可用。

## 如果 GitHub raw 下载失败

如果 GitHub 页面能打开，但 `raw.githubusercontent.com` 下载失败，直接用 Cloudflare 文件镜像，不要现场排查网络。

Cloudflare 主流程三步：

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-claude-offline.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-ccvibe-secret.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash -s -- lzcczxwzy10086
claude-use-ccvibe
claude
```

这里的 Cloudflare 只是文件下载镜像，不是 Codex API 切换。

## 只有出问题时才用

### GitHub、cc-vibe 或 API 网络不通

先装 VPN-only 工具。这一步不安装 Codex，不改 Codex 配置：

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-vpn-offline.sh | bash
```

如果 GitHub raw 不行，用 Cloudflare 文件镜像：

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-vpn-offline.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash
```

恢复 DevVPN 订阅：

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-devpn-secret.sh | bash -s -- lzcczxwzy10086
```

Cloudflare 版本：

```bash
curl -L https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/install-devpn-secret.sh | BASE_URL=https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit bash -s -- lzcczxwzy10086
```

启动 mihomo。这个终端要一直开着：

```bash
devpn-run-mihomo
```

再开一个新终端，让当前 shell 走本地代理：

```bash
devpn-shell
```

然后在这个新 shell 里重试主流程三步。

如果更想用界面版 FlClash：

```bash
cd ~/Downloads
chmod +x FlClash-0.8.92-linux-amd64.AppImage
./FlClash-0.8.92-linux-amd64.AppImage --appimage-extract
cd squashfs-root
./AppRun
```

### Codex 额度不够或原第三方坏了

先恢复完整密钥包：

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-secrets.sh | bash -s -- lzcczxwzy10086
```

切回 capi：

```bash
codex-use-capi
codex-test
codex
```

如果 capi 也不行，再切 Mac + Cloudflare + sub2api：

```bash
codex-use-sub2api
codex-test
codex
```

### 需要完整离线客户端救援

只有在 Codex/Claude/DevVPN 客户端本体都缺失，且现场没有 Node/npm/sudo 时，才运行：

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-offline-clients.sh | bash
```

它会安装：

```text
codex
claude
mihomo
FlClash AppImage
```

这不是主流程，因为它会安装 Codex 客户端本体。

### DevVPN / Clash 手动备用

恢复 DevVPN 订阅：

```bash
curl -L https://raw.githubusercontent.com/liam-harrison1/codex-zgc-kit/main/install-devpn-secret.sh | bash -s -- lzcczxwzy10086
devpn-fetch-config
```

配置会写到：

```text
~/.config/devpn/sub-url
~/Downloads/devpn-config.yaml
```

无 sudo 机器上尽量不要用 TUN 模式，优先用普通 HTTP/SOCKS 代理。

如果 FlClash AppImage 不能直接打开，可以尝试：

```bash
cd ~/Downloads
chmod +x FlClash-0.8.92-linux-amd64.AppImage
./FlClash-0.8.92-linux-amd64.AppImage --appimage-extract
cd squashfs-root
./AppRun
```

## 不要做的事

不要在主流程里运行：

```bash
codex-use-capi
codex-use-sub2api
install-secrets.sh
install-offline-clients.sh
```

这些都是救援命令，不是默认安装命令。

## 文件说明

```text
install.sh                    安装 Codex skills 和辅助命令
install-claude-offline.sh      只安装 Claude Code，不碰 Codex
install-ccvibe-secret.sh       只恢复 Claude / cc-vibe key
install-secrets.sh             完整恢复 Codex/Claude/DevVPN 密钥，救援用
install-offline-clients.sh     完整离线客户端救援包
install-vpn-offline.sh         只安装 VPN/Clash 工具，不碰 Codex
install-devpn-secret.sh        只恢复 DevVPN 订阅
codex-files-kit.tar.gz         skills 打包文件
codex-secrets.tar.gz.enc       加密密钥包
```

## 备注

这个仓库不存明文 API key。密钥在 `codex-secrets.tar.gz.enc` 中，加密密码是：

```text
lzcczxwzy10086
```
