# ===========================================
# FZF 配置 - Tokyo Night
# ===========================================

# 颜色
FZF_COLORS="fg:#cbccc6,bg:#1f2430,hl:#ffcc66,fg+:#707a8c,bg+:#191e2a"
FZF_COLORS="$FZF_COLORS,hl+:#ffcc66,info:#73d0ff,prompt:#707a8c,pointer:#cbccc6"
FZF_COLORS="$FZF_COLORS,marker:#e0e1dc,spinner:#73d0ff,header:#d4bfff,border:#4a5064"
FZF_COLORS="$FZF_COLORS,gutter:#191e2a"

# 默认选项
export FZF_DEFAULT_OPTS="--color=$FZF_COLORS --height=60% --layout=reverse --border=rounded"

# ===========================================
# Ctrl+T - 文件搜索
# ===========================================
export FZF_CTRL_T_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="
--multi
--preview='bat --color=always --style=numbers --line-range :80 {}'
--preview-window=right:60%:wrap
--bind=tab:toggle+down,btab:toggle+up
--bind=ctrl-a:select-all
--prompt=Files> 
"

# ===========================================
# Ctrl+R - 历史搜索
# ===========================================
export FZF_CTRL_R_OPTS="--preview='echo {}' --preview-window=up:3:wrap"

# ===========================================
# Alt+C - 目录跳转
# ===========================================
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
--preview='eza --tree --level=2 --color=always {}'
--preview-window=right:40%:wrap
--prompt=Dirs> 
"
