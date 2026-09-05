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
    zoxide \
    gh \
    trash-cli \
    btop \
    unzip

# 安装 yq (prettybat 依赖)
install_yq() {
  info "安装 yq..."
  if ! command -v yq &> /dev/null || [[ $(yq --version | grep -oP 'v\K[0-9]+') -lt 4 ]]; then
    sudo wget -q https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64 -O /usr/local/bin/yq
    sudo chmod +x /usr/local/bin/yq
  fi
}
}

# 配置 fzf 路径
setup_fzf() {
  info "配置 fzf..."
  if [ -d /usr/share/doc/fzf/examples ] && [ ! -d /usr/share/fzf ]; then
    sudo mkdir -p /usr/share/fzf
    sudo cp /usr/share/doc/fzf/examples/*.zsh /usr/share/fzf/
    sudo cp /usr/share/doc/fzf/examples/*.bash /usr/share/fzf/
    sudo cp /usr/share/doc/fzf/examples/*.fish /usr/share/fzf/
    info "fzf 配置已复制到 /usr/share/fzf/"
  fi
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

# 安装 delta (git diff 增强)
install_delta() {
  info "安装 delta..."
  if ! check_command delta; then
    curl -LO https://github.com/dandavison/delta/releases/download/0.18.1/git-delta_0.18.1_amd64.deb
    sudo dpkg -i git-delta_0.18.1_amd64.deb
    rm git-delta_0.18.1_amd64.deb
    
    # 配置 git 使用 delta
    git config --global core.pager delta
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global delta.plus-color "#007d35"
    git config --global delta.minus-color "#d32f2f"
  fi
}

# 安装 bat-extras
install_bat_extras() {
  info "安装 bat-extras..."
  if ! check_command batwatch; then
    VERSION="2024.08.24"
    curl -sL "https://github.com/eth-p/bat-extras/releases/download/v${VERSION}/bat-extras-${VERSION}.zip" -o /tmp/bat-extras.zip
    cd /tmp && unzip -o bat-extras.zip
    sudo mv /tmp/bin/* /usr/local/bin/
    rm -rf /tmp/bat-extras.zip /tmp/bin /tmp/doc /tmp/man
  fi
}

# 安装 lazygit
install_lazygit() {
  info "安装 lazygit..."
  if ! check_command lazygit; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -o '"tag_name": "v[^"]*' | cut -d'"' -f4)
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
    sudo tar -xzf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
    rm /tmp/lazygit.tar.gz
  fi
}

# 配置 lazygit
config_lazygit() {
  info "配置 lazygit..."
  mkdir -p ~/.config/lazygit
  link_file "config/lazygit.yml" ".config/lazygit/config.yml"
}

# 安装 zoxide
install_zoxide() {
  info "安装 zoxide..."
  if ! check_command zoxide; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi
}

# 安装 cargo 工具
install_cargo_tools() {
  info "安装 cargo 工具..."
  if ! check_command cargo; then
    warn "cargo 未安装，跳过 cargo 工具安装"
    return
  fi
  
  # 安装 serie (changelog 生成工具)
  if ! check_command serie; then
    cargo install --locked serie
  fi
}

# 安装 GitHub CLI
install_gh() {
  info "安装 GitHub CLI..."
  if ! check_command gh; then
    sudo apt install -y gh
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
      setup_fzf
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
  
  read -p "是否安装 GitHub CLI? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_gh
  fi

  read -p "是否安装 cargo 工具? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_cargo_tools
  fi

  read -p "是否安装 delta (git diff)? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_delta
  fi
  
  read -p "是否安装 bat-extras? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_bat_extras
    install_yq
  fi

  read -p "是否安装 lazygit? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_lazygit
  fi
  
  read -p "是否安装 zoxide? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_zoxide
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
  link_file "config/starship.toml"
  link_file "config/lazygit.yml"
  link_file "nvim"
  
  # 配置 lazygit
  if [ -f "$HOME/.config/lazygit/config.yml" ]; then
    config_lazygit
  fi
  
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
  echo "常用命令:"
  echo "  ll      - 详细列表"
  echo "  n       - Neovim"
  echo "  lg      - LazyGit"
  echo "  top     - btop"
  echo ""
}

main "$@"
