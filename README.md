# Dotfiles (Arch Linux)

zsh、Neovim (LazyVim)、starship 和一组现代 CLI 工具的个人配置，已适配 Arch Linux。

## 目录结构

```
.dotfiles/
├── .zshrc              # Zsh 配置
├── .zshenv             # 环境变量
├── .aliases            # 命令别名
├── .zshdirs            # 目录栈快捷操作
├── install.sh          # Arch Linux 安装脚本
├── bin/
│   └── ipinfo          # IP 信息查询工具
├── config/
│   ├── starship.toml
│   ├── lazygit.yml
│   └── fzf.toml-night.sh
└── nvim/
    └── nvim/           # Neovim + LazyVim 配置
```

## 安装

```bash
git clone https://github.com/zrz616/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 为当前用户安装（会安装官方仓库依赖、链接配置、同步 LazyVim、切换 zsh）
./install.sh

# 或指定用户（需要 root）
sudo ./install.sh --user hbird

# 只链接配置，不装包 / 不装插件
./install.sh --no-packages --no-nvim
```

脚本只使用 Arch 官方仓库（`core` / `extra`），不使用 AUR。

## 依赖（pacman）

```
zsh git curl wget
eza bat ripgrep fd fzf btop ncdu tree
zoxide github-cli trash-cli
neovim starship git-delta lazygit bat-extras go-yq
zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
wl-clipboard ttf-nerd-fonts-symbols
base-devel
```

Neovim 的 LSP 由 Mason 管理；`base-devel`、Node.js/npm 用于 treesitter 与部分语言服务器。

## 配置链接

| 源 | 目标 |
|---|---|
| `.zshrc` / `.zshenv` / `.aliases` / `.zshdirs` | `~/` |
| `config/starship.toml` | `~/.config/starship.toml` |
| `config/lazygit.yml` | `~/.config/lazygit/config.yml` |
| `nvim/nvim` | `~/.config/nvim` |

## 常用命令

```bash
ll / lt / la        # eza
fd <pattern>        # fd（Arch 没有 fdfind）
rg <pattern>        # ripgrep
z <dir>             # zoxide
lg                  # lazygit
n / vim             # nvim
bat <file>          # 语法高亮
delta               # git diff 分页器
ipinfo [IP|域名]    # IP 查询
```

## 说明

- `rm` 被别名到 `trash`（`trash-cli`），删除进入回收站。
- `update` = `sudo pacman -Syu`，`cleanup` = `sudo pacman -Sc`。
- `ip` 被别名到 `ipinfo`；需要原生 `ip` 时使用 `command ip`。
- 图标依赖 `ttf-nerd-fonts-symbols`；终端字体不支持时会显示占位符，可去掉 eza 的 `--icons`。
- IPinfo token（可选）：

```bash
mkdir -p ~/.ipinfo
echo "your_api_token" > ~/.ipinfo/token
```
