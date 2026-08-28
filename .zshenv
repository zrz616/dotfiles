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

# fd 配置
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always --line-range {1..50} {}"'

# bat 配置
export BAT_THEME="OneHalfDark"

# zoxide 配置 - 简单方式
if command -v zoxide &> /dev/null; then
  export _ZO_DATA_DIR=$HOME/.local/share/zoxide
  eval "$(zoxide init zsh)"
fi

# fzf 配置
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
