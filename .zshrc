# === ZSH 配置 (Arch Linux) ===

# 加载环境变量
[ -f ~/.zshenv ] && source ~/.zshenv

# 补全必须先初始化：.zshdirs 里用到了 compdef
autoload -Uz compinit
compinit -C

# 加载别名与目录配置
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.zshdirs ] && source ~/.zshdirs

# === 历史记录配置 ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY           # 共享历史记录
setopt HIST_IGNORE_ALL_DUPS    # 忽略重复命令
setopt HIST_IGNORE_SPACE       # 忽略以空格开头的命令
setopt HIST_REDUCE_BLANKS      # 压缩连续空格

# === 自动补全 ===
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # 大小写不敏感
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completers _all_matches _match _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# === 插件（优先使用 Arch 软件包，回退到 ~/.zsh/plugins） ===
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

for _f in \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
  [[ -f "$_f" ]] && source "$_f" && break
done

for _f in \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh \
  "$HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"; do
  [[ -f "$_f" ]] && source "$_f" && break
done

# 语法高亮必须最后加载
for _f in \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
  [[ -f "$_f" ]] && source "$_f" && break
done
unset _f

# === 键绑定 ===
bindkey -v                                        # 使用 vi 模式

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^v' edit-command-line           # Ctrl+V 编辑当前命令

(( $+widgets[history-substring-search-up] )) && bindkey '^[[A' history-substring-search-up
(( $+widgets[history-substring-search-down] )) && bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward  # Ctrl+R 搜索历史
bindkey '^[[Z' undo                               # Shift+Tab 撤销

# === fzf 集成 ===
for _f in /usr/share/fzf/key-bindings.zsh "$HOME/.fzf/shell/key-bindings.zsh"; do
  [[ -f "$_f" ]] && source "$_f" && break
done
for _f in /usr/share/fzf/completion.zsh "$HOME/.fzf/shell/completion.zsh"; do
  [[ -f "$_f" ]] && source "$_f" && break
done
unset _f

# FZF 配置 - Tokyo Night
[[ -f "$HOME/.dotfiles/config/fzf.toml-night.sh" ]] && source "$HOME/.dotfiles/config/fzf.toml-night.sh"

# fzf 文件预览快捷键
alias fzp='fzf --preview "bat --color=always --style=numbers --line-range :80 {}"'

# Git 相关
alias fgb='fzf --height=40% --border --layout=reverse --prompt=" branches > " < <(git branch) | xargs git checkout'
alias fgco='fzf --height=40% --border --layout=reverse --prompt=" checkout > " < <(git branch) | xargs git checkout'
alias fglog='fzf --height=50% --border --layout=reverse --prompt=" log > " < <(git log --oneline --all --decorate --graph) | head -1'
alias fgst='fzf --height=40% --border --layout=reverse --prompt=" status > " --preview="git diff {1}"'

# 在文件历史中搜索
alias fglogfile='fzf --height=40% --border --layout=reverse --prompt=" file log > " < <(git log --oneline --name-only --all --format="%h %s" | grep .) | cut -d" " -f1 | xargs git show --stat'

# === 提示符配置 ===
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PS1='%F{green}%n@%m%f:%F{blue}%~%f\$ '
  RPROMPT='%(?.%F{green}✓.%F{red}✗)%f'
fi

# === 杂项配置 ===
# cd 后自动列表
chpwd() { ls }

# 创建目录后自动进入
mkcd() { mkdir -p "$1" && cd "$1" }

# === 加载本地配置 (可选) ===
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
