# Dotfiles

我的系统配置文件。

## 目录结构

```
.dotfiles/
├── .zshrc              # Zsh 配置
├── .zshenv             # 环境变量
├── .aliases            # 命令别名
├── install.sh          # 安装脚本
├── config/
│   ├── starship.toml   # Starship 提示符
│   └── lazygit.yml     # LazyGit 配置
└── nvim/
    └── ...             # Neovim + LazyVim 配置
```

## 安装

### 自动安装 (推荐)

```bash
# 克隆仓库
git clone https://github.com/zrz616/dotfiles.git ~/.dotfiles

# 运行安装脚本
~/.dotfiles/install.sh
```

### 手动安装

```bash
# 创建符号链接
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.zshenv ~/.zshenv
ln -sf ~/.dotfiles/.aliases ~/.aliases
ln -sf ~/.dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/config/lazygit.yml ~/.config/lazygit/config.yml
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# 安装 Neovim 插件
nvim --headless +"Lazy sync" +q

# 设置 zsh 为默认 shell
chsh -s $(which zsh)
```

## 安装的工具有

| 工具 | 说明 |
|------|------|
| **zsh** | 现代化 shell |
| **starship** | 跨平台提示符 |
| **eza** | ls 替代，带图标和 git 状态 |
| **bat** | cat 替代，语法高亮 |
| **ripgrep** | grep 替代，更快 |
| **fd** | find 替代，更快 |
| **btop** | top 替代，现代 UI |
| **delta** | git diff 增强，语法高亮 |
| **bat-extras** | bat 增强工具集 |
| **lazygit** | Git 终端 UI |
| **fzf** | 模糊搜索 |
| **zoxide** | 智能目录跳转 |
| **Neovim** | 编辑器 (LazyVim) |
| **GitHub CLI** | gh 命令行工具 |

## 常用命令

### Shell
```bash
ll              # 详细列表 (eza -l)
lt              # 树形结构
la              # 显示隐藏文件
fd <pattern>    # 搜索文件
z <dir>         # 快速跳转 (zoxide)
```

### Git
```bash
lg              # LazyGit
git diff        # 使用 delta
gl              # git pull
gp              # git push
```

### Neovim
```bash
n               # 启动 Neovim
<leader>ff      # 搜索文件
<leader>fg      # 全局搜索
<leader>gg      # LazyGit
gcc             # 切换注释
```

### bat-extras
```bash
batdiff         # git diff with bat
batgrep "pat"   # 搜索并高亮
batwatch file   # 监控文件变化
```

## GitHub CLI 认证

```bash
gh auth login
```

## Neovim 快捷键

| 快捷键 | 功能 |
|--------|------|
| `gcc` | 切换行注释 |
| `gbc` | 切换块注释 |
| `sa` | 添加环绕 |
| `sd` | 删除环绕 |
| `sc` | 修改环绕 |
| `s/S` | 快速跳转 (flash.nvim) |
| `<leader>ff` | 搜索文件 |
| `<leader>fg` | 全局搜索 |
| `<leader>fb` | 搜索缓冲区 |
| `<leader>gg` | LazyGit |
| `gd` | 跳转到定义 |
| `K` | 查看文档 |
| `<leader>ca` | 代码操作 |
| `<leader>rn` | 重命名 |
| `<C-h/j/k/l>` | 窗口导航 |
| `<leader>te` | 终端 |
