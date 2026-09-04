# === 环境变量 ===

# 设置默认编辑器
export EDITOR=${EDITOR:-nano}
export VISUAL=${EDITOR}

# 语言设置
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 更安全的删除行为
export SAFE_RM=true

# Go 配置 (如果安装了 Go)
if command -v go &> /dev/null; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
fi

# PATH 配置
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH

# bat 配置 - Dracula 主题
export BAT_THEME="Dracula"

# delta 配置 - Dracula
export DELTA_THEME="dracula"

# zoxide 配置
if command -v zoxide &> /dev/null; then
  export _ZO_DATA_DIR=$HOME/.local/share/zoxide
  eval "$(zoxide init zsh)"
fi

. "$HOME/.cargo/env"
export PATH="$HOME/.dotfiles/bin:$PATH"
