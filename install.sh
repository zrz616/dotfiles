#!/usr/bin/env bash
# ===========================================
# Dotfiles installer for Arch Linux
# ===========================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${TARGET_USER:-$(id -un)}"
INSTALL_PACKAGES=1
INSTALL_NVIM=1
SET_SHELL=1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { printf '%b[INFO]%b %s\n' "$GREEN" "$NC" "$*"; }
warn()  { printf '%b[WARN]%b %s\n' "$YELLOW" "$NC" "$*"; }
error() { printf '%b[ERROR]%b %s\n' "$RED" "$NC" "$*" >&2; }

usage() {
  cat <<EOF
Usage: $0 [options]

  --user USER       Apply dotfiles to USER (default: current user)
  --no-packages     Skip pacman package installation
  --no-nvim         Skip LazyVim plugin sync
  --no-chsh         Do not change the login shell
  -h, --help        Show this help
EOF
}

while (($#)); do
  case "$1" in
    --user) TARGET_USER="${2:?missing user}"; shift 2 ;;
    --no-packages) INSTALL_PACKAGES=0; shift ;;
    --no-nvim) INSTALL_NVIM=0; shift ;;
    --no-chsh) SET_SHELL=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) error "unknown option: $1"; usage; exit 1 ;;
  esac
done

if ! command -v pacman >/dev/null 2>&1; then
  error "This installer targets Arch Linux (pacman not found)."
  exit 1
fi

if ! getent passwd "$TARGET_USER" >/dev/null 2>&1; then
  error "user not found: $TARGET_USER"
  exit 1
fi

HOME_DIR="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
TARGET_GROUP="$(id -gn "$TARGET_USER")"

# 清理 macOS 归档带来的 AppleDouble 文件（lazy.nvim 会把 ._*.lua 当成插件 spec）
find "$DOTFILES_DIR" \( -name '._*' -o -name '.DS_Store' \) -delete 2>/dev/null || true

run_as_user() {
  if [[ $EUID -eq 0 && "$TARGET_USER" != "root" ]]; then
    runuser -u "$TARGET_USER" -- env HOME="$HOME_DIR" "$@"
  else
    env HOME="$HOME_DIR" "$@"
  fi
}

# 软件包（全部来自 Arch 官方仓库）
PACMAN_PKGS=(
  zsh git curl wget
  eza bat ripgrep fd fzf btop ncdu tree
  zoxide github-cli trash-cli
  neovim starship git-delta lazygit bat-extras go-yq
  zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
  wl-clipboard ttf-nerd-fonts-symbols
  base-devel
)

if [[ $INSTALL_PACKAGES -eq 1 ]]; then
  if [[ $EUID -ne 0 ]]; then
    warn "非 root，跳过软件包安装（可稍后用 sudo 重新运行）"
  else
    info "安装 Arch 官方仓库依赖..."
    pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
  fi
fi

# 确保 ~/.dotfiles 指向本仓库（.zshenv 和 fzf 配置依赖该路径）
if [[ "$DOTFILES_DIR" != "$HOME_DIR/.dotfiles" ]]; then
  if [[ -e "$HOME_DIR/.dotfiles" && ! -L "$HOME_DIR/.dotfiles" ]]; then
    mv "$HOME_DIR/.dotfiles" "$HOME_DIR/.dotfiles.backup.$(date +%s)"
  fi
  ln -sfn "$DOTFILES_DIR" "$HOME_DIR/.dotfiles"
  chown -h "$TARGET_USER:$TARGET_GROUP" "$HOME_DIR/.dotfiles"
fi

backup_path() {
  local dest="$1"
  local ts
  ts="$(date +%s)"
  if [[ -L "$dest" ]]; then
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    warn "备份已存在文件: $dest"
    mv "$dest" "$dest.backup.$ts"
  fi
}

link_file() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME_DIR/$2"
  local dir
  dir="$(dirname "$dest")"

  mkdir -p "$dir"
  if [[ -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
    info "已链接: $2"
    return
  fi

  backup_path "$dest"
  ln -sfn "$src" "$dest"
  chown -h "$TARGET_USER:$TARGET_GROUP" "$dest"
  info "链接: $2"
}

info "为 $TARGET_USER 配置 dotfiles..."
link_file ".zshrc" ".zshrc"
link_file ".zshenv" ".zshenv"
link_file ".aliases" ".aliases"
link_file ".zshdirs" ".zshdirs"
link_file "config/starship.toml" ".config/starship.toml"
link_file "config/lazygit.yml" ".config/lazygit/config.yml"
link_file "nvim/nvim" ".config/nvim"

# 确保 ipinfo 可执行
if [[ -f "$DOTFILES_DIR/bin/ipinfo" ]]; then
  chmod +x "$DOTFILES_DIR/bin/ipinfo"
fi

# git + delta
info "配置 git / delta..."
run_as_user git config --global core.pager delta
run_as_user git config --global interactive.diffFilter "delta --color-only"
run_as_user git config --global delta.navigate true
run_as_user git config --global delta.side-by-side true
run_as_user git config --global delta.line-numbers true
run_as_user git config --global delta.plus-color "#007d35"
run_as_user git config --global delta.minus-color "#d32f2f"
run_as_user git config --global merge.conflictStyle zdiff3

# Neovim 插件
if [[ $INSTALL_NVIM -eq 1 ]] && command -v nvim >/dev/null 2>&1; then
  info "同步 LazyVim 插件..."
  if run_as_user timeout 600 nvim --headless "+Lazy! sync" +qa; then
    info "Neovim 插件同步完成"
  else
    warn "Neovim 插件同步失败/超时，可稍后手动运行: nvim --headless '+Lazy! sync' +qa"
  fi
fi

# 默认 shell
if [[ $SET_SHELL -eq 1 ]]; then
  current_shell="$(getent passwd "$TARGET_USER" | cut -d: -f7)"
  if [[ "$current_shell" != "/usr/bin/zsh" ]]; then
    if [[ $EUID -eq 0 ]]; then
      info "设置 $TARGET_USER 的默认 shell 为 zsh..."
      chsh -s /usr/bin/zsh "$TARGET_USER"
    else
      warn "需要 root 才能为其他用户 chsh；当前用户可运行: chsh -s /usr/bin/zsh"
    fi
  fi
fi

echo
info "完成。重新登录或执行 'exec zsh' 生效。"
cat <<EOF

提示:
  - 软件包全部来自 Arch 官方仓库（extra/core），未使用 AUR。
  - Neovim 配置路径: $HOME_DIR/.config/nvim
  - 首次进入 nvim 会自动安装/更新插件；LSP 由 Mason 按需安装。
  - eza 图标依赖 Nerd Font Symbols（已安装 ttf-nerd-fonts-symbols）。
  - 可选: 配置 IPinfo token: mkdir -p ~/.ipinfo && echo TOKEN > ~/.ipinfo/token
EOF
