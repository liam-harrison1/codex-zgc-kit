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
- 明天没有手机时，不要依赖 ChatGPT 网页登录、passkey、邮箱/短信二次验证；主线只走本机 Codex CLI 和这里的脚本。
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

## 明天现场操作顺序

如果不知道先做什么，按这个顺序走：

```text
1. 先确认当前 Ubuntu 环境
2. 打开 Codex CLI，确认 Codex 能回答
3. 读取这个 README，只执行主流程三步
4. 如果有开发机，先用 SSHDEV 连上开发机
5. 在开发机上确认代码目录、任务要求、运行命令
6. 让 Codex/Claude 先读题和列计划，再让它改代码或跑实验
```

现场第一组检查命令：

```bash
pwd
whoami
hostname
uname -a
date
echo "$SHELL"
echo "$PATH"
```

如果 Codex 已经能用，先让它读这个仓库：

```bash
codex
```

然后对 Codex 说：

```text
请打开 GitHub 上 liam-harrison1/codex-zgc-kit，读取 README。
只按主流程三步做。不要改 Codex API，除非我明确说 Codex 坏了或额度不够。
现场没有 sudo、可能没有 Node/npm、没有手机验证。
```

## SSHDEV 连接开发机

实训环境里如果要求用 `SSHDEV` 或 `sshdev` 连接开发机，先探测真实命令：

```bash
type sshdev || type SSHDEV
sshdev --help || SSHDEV --help
```

如果出现菜单或帮助信息，按老师给的开发机名称、队伍编号、任务编号选择。常见形式可能是：

```bash
sshdev
sshdev <开发机名称>
SSHDEV
SSHDEV <开发机名称>
```

连接成功后立刻确认自己已经在开发机里：

```bash
hostname
whoami
pwd
ls -la
```

如果 `sshdev` 提示 `command not found`，不要用 `apt install`，因为没有 sudo。直接问现场老师或助教：

```text
请问连接开发机的命令、开发机名称、账号路径分别是什么？
这台 Ubuntu 没有 sudo，所以需要使用实训环境已经提供的连接方式。
```

如果 SSHDEV 卡住或断开：

```bash
ping -c 3 github.com
ssh -V
env | grep -i proxy
```

如果开发机里不能访问 GitHub，但本机 Ubuntu 可以访问 GitHub，就先在本机完成 README 主流程；如果本机也不通，再看本文的 VPN-only 救援。

## 科研实训做题流程

拿到题目后，不要先乱改文件。先让 Codex/Claude 做这几件事：

```text
请先读题和当前目录，输出：
1. 任务目标
2. 输入、输出、评分方式
3. 需要运行的命令
4. 不能碰的文件
5. 最小可行计划
在我确认前不要大改代码。
```

进入项目后先看这些：

```bash
pwd
ls -la
find . -maxdepth 2 -type f | head -80
git status 2>/dev/null || true
README_FILES=$(find . -maxdepth 3 -iname "README*" -o -iname "*.md" | head -20)
echo "$README_FILES"
```

如果是 Python 项目：

```bash
python3 --version
python3 -m pip --version 2>/dev/null || true
find . -maxdepth 3 -type f \( -name "requirements.txt" -o -name "pyproject.toml" -o -name "environment.yml" \)
```

没有 sudo 时，优先用用户目录或虚拟环境：

```bash
python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install -r requirements.txt
```

如果没有网络或依赖装不上，先不要硬装。让 Codex 检查已有环境：

```bash
python3 - <<'PY'
import sys
mods = ["numpy", "pandas", "torch", "sklearn", "matplotlib"]
for m in mods:
    try:
        mod = __import__(m)
        print(m, getattr(mod, "__version__", "ok"))
    except Exception as e:
        print(m, "missing")
PY
```

做修改前先保存现场状态：

```bash
git status 2>/dev/null || true
cp -a important_file important_file.bak 2>/dev/null || true
```

每次让 AI 改完后都要跑验证命令。没有明确测试时，至少跑：

```bash
python3 -m compileall . 2>/dev/null || true
git diff 2>/dev/null || true
```

## Linux 常用命令速查

目录和文件：

```bash
pwd                         # 当前目录
ls -la                      # 看文件
cd 路径                     # 进入目录
cd ..                       # 返回上级
mkdir -p dir                # 创建目录
cp 源 目标                  # 复制文件
cp -a 源目录 目标目录       # 复制目录
mv 旧名 新名                # 移动或改名
rm -i 文件                  # 删除前询问
du -sh .                    # 当前目录大小
df -h                       # 磁盘空间
```

查看内容：

```bash
cat file                    # 直接输出
less file                   # 分页查看，按 q 退出
head -40 file               # 前 40 行
tail -40 file               # 后 40 行
tail -f log.txt             # 持续看日志
```

搜索：

```bash
rg "关键词" .               # 推荐，最快
grep -R "关键词" .          # 没有 rg 时用
find . -name "*.py"         # 找文件
find . -maxdepth 2 -type f  # 看浅层文件
```

编辑：

```bash
nano file                   # 简单编辑器，Ctrl+O 保存，Ctrl+X 退出
vim file                    # 如果会 vim 再用
```

进程和网络：

```bash
ps aux | head
ps aux | grep 关键词
kill PID
curl -I https://github.com
curl -L URL -o file
```

Git：

```bash
git status
git diff
git log --oneline -5
git clone URL
git pull
```

压缩包：

```bash
tar -tzf file.tar.gz        # 查看压缩包内容
tar -xzf file.tar.gz        # 解压
tar -czf out.tar.gz dir     # 打包
```

环境变量：

```bash
echo "$PATH"
export PATH="$HOME/.local/bin:$PATH"
env | sort | less
```

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
