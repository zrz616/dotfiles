# ===========================================
# FZF 配置 - Tokyo Night
# ===========================================

# 颜色
export FZF_DEFAULT_OPTS='
  --color=fg:#cbccc6,bg:#1f2430,hl:#ffcc66,fg+:#707a8c,bg+:#191e2a
  --color=hl+:#ffcc66,info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
  --color=marker:#e0e1dc,spinner:#73d0ff,header:#d4bfff,border:#4a5064
  --color=gutter:#191e2a
  --height=60%
  --layout=reverse
  --border=rounded
  --preview-window=right:60%:wrap
  --multi
  --bind=ctrl-a:select-all,ctrl-d:deselect-all
  --bind=ctrl-t:toggle-all
  --bind=alt-up:preview-up,alt-down:preview-down
'

# 文件搜索
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# 目录跳转
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'

# 预览命令 - 使用 bat
export FZF_CTRL_T_OPTS="
  --preview='bat --color=always --style=numbers --line-range :100 {}'
  --bind='alt-enter:execute(nvim {})'
"

# 目录预览
export FZF_ALT_C_OPTS="
  --preview='eza --tree --level=2 --color=always {}'
"

# 文件搜索预览
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --preview='bat --color=always --style=numbers --line-range :80 {}'
"

# Git 命令
_fzf_git_files() {
  git -C . ls-files --others --cached | \
    fzf --multi --preview="git diff --color {} | head -50"
}

# FZF 快捷键绑定 (在 zshrc 中设置)
