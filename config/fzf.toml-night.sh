# ===========================================
# FZF 配置 - Tokyo Night
# ===========================================

# Ctrl+T - 文件搜索
export FZF_CTRL_T_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS='
--ansi
--height=60%
--layout=reverse
--border=rounded
--preview-window=right:60%:wrap
--multi
--prompt=Files> 
--marker=✓
--pointer=▶
--color=fg:#cbccc6,bg:#1f2430,hl:#ffcc66,fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66,info:#73d0ff,prompt:#707a8c,pointer:#cbccc6,marker:#e0e1dc,spinner:#73d0ff,header:#d4bfff,border:#4a5064,gutter:#191e2a
--preview=bat --color=always --style=numbers --line-range :80 {}
--bind=tab:toggle+down
--bind=btab:toggle+up
--bind=ctrl-a:select-all
--bind=ctrl-d:deselect-all
'

# Ctrl+R - 历史搜索
export FZF_CTRL_R_OPTS='
--ansi
--height=50%
--layout=reverse
--border=rounded
--color=fg:#cbccc6,bg:#1f2430,hl:#ffcc66,fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66,info:#73d0ff,prompt:#707a8c
'

# Alt+C - 目录跳转
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS='
--ansi
--height=60%
--layout=reverse
--border=rounded
--preview-window=right:40%:wrap
--prompt=Dirs> 
--color=fg:#cbccc6,bg:#1f2430,hl:#ffcc66,fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66,info:#73d0ff,prompt:#707a8c,border:#4a5064,gutter:#191e2a
--preview=eza --tree --level=2 --color=always {}
'
