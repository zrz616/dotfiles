# ===========================================
# FZF 配置 - Tokyo Night
# ===========================================

# 颜色
FZF_COLORS="fg:#cbccc6,bg:#1f2430,hl:#ffcc66,fg+:#707a8c,bg+:#191e2a"
FZF_COLORS="$FZF_COLORS,hl+:#ffcc66,info:#73d0ff,prompt:#707a8c,pointer:#cbccc6"
FZF_COLORS="$FZF_COLORS,marker:#e0e1dc,spinner:#73d0ff,header:#d4bfff,border:#4a5064"
FZF_COLORS="$FZF_COLORS,gutter:#191e2a"

# 基本选项
FZF_OPTS="--color=$FZF_COLORS"
FZF_OPTS="$FZF_OPTS --height=60% --layout=reverse --border=rounded"
FZF_OPTS="$FZF_OPTS --preview-window=right:60%:wrap"
FZF_OPTS="$FZF_OPTS --multi"
FZF_OPTS="$FZF_OPTS --prompt=~/ "
FZF_OPTS="$FZF_OPTS --pointer=▶"
FZF_OPTS="$FZF_OPTS --marker=✓"

# 快捷键绑定
FZF_OPTS="$FZF_OPTS --bind=ctrl-a:select-all,ctrl-d:deselect-all"
FZF_OPTS="$FZF_OPTS --bind=ctrl-t:toggle-all"
FZF_OPTS="$FZF_OPTS --bind=alt-up:preview-up,alt-down:preview-down"
FZF_OPTS="$FZF_OPTS --bind=alt-a:select-all"
FZF_OPTS="$FZF_OPTS --bind=alt-d:deselect-all"
FZF_OPTS="$FZF_OPTS --bind=?:toggle-preview"
FZF_OPTS="$FZF_OPTS --bind=tab:toggle+down,btab:toggle+up"

# 用 nvim 打开选中文件
FZF_OPTS="$FZF_OPTS --bind=ctrl-e:execute(echo {+} | xargs -o nvim)"
FZF_OPTS="$FZF_OPTS --bind=ctrl-v:execute(echo {+} | xargs -o nvim)"

# 回车用 nvim 打开
FZF_OPTS="$FZF_OPTS --bind=enter:execute(echo {+} | xargs -o nvim)"

export FZF_DEFAULT_OPTS="$FZF_OPTS"

# 文件搜索
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# 目录跳转
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'

# 预览命令 - bat 显示文件内容
export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers --line-range :100 {}'"

# 目录预览 - eza 树形显示
export FZF_ALT_C_OPTS="--preview='eza --tree --level=2 --color=always {}'"
