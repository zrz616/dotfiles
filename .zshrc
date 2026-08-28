# === ZSH 配置 ===
# 由系统配置脚本生成

# 加载环境变量
[ -f ~/.zshenv ] && source ~/.zshenv

# 加载别名
[ -f ~/.aliases ] && source ~/.aliases

# === 历史记录配置 ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY           # 共享历史记录
setopt HIST_IGNORE_ALL_DUPS    # 忽略重复命令
setopt HIST_IGNORE_SPACE       # 忽略以空格开头的命令
setopt HIST_REDUCE_BLANKS      # 压缩连续空格

# === 自动补全 ===
autoload -Uz compinit
compinit -C  # 使用缓存加速
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # 大小写不敏感
zstyle ':completion:*' list-colors "${LS_COLORS}"  # 彩色自动补全

# === 补全大小写不敏感 ===
zstyle ':completion:*' completers _all_matches _match _approximate
zstyle ':completion:*' use-cache on

# === 插件 ===
ZSH_PLUGINS="$HOME/.zsh/plugins"
# 加载 autosuggestions (命令建议)
[ -f $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"  # 高亮样式

# 加载 syntax highlighting (语法高亮)
[ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# === 键绑定 ===
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward  # Ctrl+R 搜索历史
bindkey '^[[Z' undo  # Shift+Tab 撤销

# === 自动跳转 ===
# zoxide 集成 (已在 zshenv 中通过 eval 初始化)

# === fzf 集成 ===
# Ctrl+T - 搜索文件
# Ctrl+R - 搜索历史
# Alt+C  - 跳转到目录

# === 路径配置 ===
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  /usr/local/bin
  $path
)

# === 提示符配置 ===
# starship 跨平台提示符
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  # 内置简洁提示符
  PS1='%F{green}%n@%m%f:%F{blue}%~%f\$ '
  RPROMPT='%(?.%F{green}✓.%F{red}✗)%f'
fi

# === 杂项配置 ===
# 自动 ls 在 cd 后
chpwd() { ls }

# 自动更新 PATH 中的重复项
typeset -U path

# 创建目录后自动进入
mkcd() { mkdir -p "$1" && cd "$1" }

# === 加载本地配置 (可选) ===
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
