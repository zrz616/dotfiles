#!/usr/bin/env bash
# ===========================================
# Dotfiles 安装脚本
# ===========================================

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查命令
check_command() {
  if ! command -v "$1" &> /dev/null; then
    warn "$1 未安装"
    return 1
  fi
  return 0
}

# 创建符号链接
link_file() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$1"
  local dir=$(dirname "$dest")
  
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
  
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    warn "备份已存在: $dest"
    mv "$dest" "$dest.backup.$(date +%s)"
  fi
  
  ln -sf "$src" "$dest"
  info "链接: $1"
}

# 安装 apt 包
install_apt() {
  info "安装系统包..."
  sudo apt update
  sudo apt install -y \
    zsh \
    git \
    curl \
    wget \
    eza \
    bat \
    ripgrep \
    fd-find \
    fzf \
    htop \
    ncdu \
    tree \
    autojump \
    zoxide
}

# 安装 Neovim
install_neovim() {
  info "安装 Neovim..."
  if ! check_command nvim; then
    curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz
    sudo tar -xzf nvim-linux-x86_64.tar.gz -C /opt/
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-x86_64.tar.gz
  fi
}

# 安装 Starship
install_starship() {
  info "安装 Starship..."
  if ! check_command starship; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
}

# 安装 zsh 插件
install_zsh_plugins() {
  info "安装 zsh 插件..."
  local plugins_dir="$HOME/.zsh/plugins"
  mkdir -p "$plugins_dir"
  
  if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
  fi
  
  if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
  fi
}

# 安装 Neovim 插件
install_nvim_plugins() {
  info "安装 Neovim 插件..."
  if check_command nvim; then
    nvim --headless +"Lazy sync" +q 2>/dev/null || true
  fi
}

# 设置 zsh 为默认 shell
set_default_shell() {
  info "设置 zsh 为默认 shell..."
  if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)"
    info "已设置为 zsh，下次登录生效"
  fi
}

# 主函数
main() {
  echo "=========================================="
  echo "  Dotfiles 安装脚本"
  echo "=========================================="
  echo ""
  
  # 检查 git
  if ! check_command git; then
    error "需要安装 git"
    exit 1
  fi
  
  # 创建目录
  mkdir -p "$DOTFILES_DIR"
  
  # 检查 dotfiles 是否存在
  if [ ! -f "$DOTFILES_DIR/.zshrc" ]; then
    error "未找到 dotfiles，请先克隆仓库:"
    echo "  git clone <your-repo> ~/.dotfiles"
    exit 1
  fi
  
  # 安装依赖
  if check_command apt; then
    read -p "是否安装系统依赖? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      install_apt
    fi
  fi
  
  read -p "是否安装 Neovim? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_neovim
  fi
  
  read -p "是否安装 Starship? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_starship
  fi
  
  read -p "是否安装 zsh 插件? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_zsh_plugins
  fi
  
  # 创建符号链接
  info "创建符号链接..."
  link_file ".zshrc"
  link_file ".zshenv"
  link_file ".aliases"
  link_file ".config/starship.toml"
  link_file ".config/nvim"
  
  # 安装 Neovim 插件
  read -p "是否安装 Neovim 插件? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_nvim_plugins
  fi
  
  # 设置默认 shell
  read -p "是否设置 zsh 为默认 shell? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    set_default_shell
  fi
  
  echo ""
  echo "=========================================="
  info "安装完成!"
  echo "=========================================="
  echo ""
  echo "请运行以下命令切换到 zsh:"
  echo "  exec zsh"
  echo ""
}

main "$@"
