# === 环境变量 (Arch Linux) ===

# 避免被 .zshrc 重复加载
[[ -n ${_DOTFILES_ZSHENV_LOADED:-} ]] && return 0
# 不要 export：避免通过 runuser/sudo 泄漏到子用户环境
_DOTFILES_ZSHENV_LOADED=1

# 默认编辑器
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
elif command -v nano >/dev/null 2>&1; then
  export EDITOR=nano
else
  export EDITOR=vi
fi
export VISUAL="$EDITOR"

# 语言设置（Arch 已生成 en_US.UTF-8）
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 更安全的删除行为（配合 .aliases 的 rm=trash）
export SAFE_RM=true

# Go 配置（如果安装了 Go）
if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/go"
  path=("$GOPATH/bin" $path)
fi

# PATH（zsh 数组，自动去重）
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  /usr/local/bin
  $path
)
[[ -d "$HOME/.dotfiles/bin" ]] && path=("$HOME/.dotfiles/bin" $path)
export PATH

# bat 主题
export BAT_THEME="Dracula"

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  export _ZO_DATA_DIR="$HOME/.local/share/zoxide"
  eval "$(zoxide init zsh)"
fi

# Rust / cargo（存在才加载）
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
