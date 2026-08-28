# Dotfiles

我的系统配置文件。

## 目录结构

```
.dotfiles/
├── .zshrc          # Zsh 配置
├── .zshenv         # 环境变量
├── .aliases        # 命令别名
├── config/
│   └── starship.toml  # Starship 提示符
└── nvim/
    ├── init.lua
    ├── lua/
    │   ├── config/   # 配置模块
    │   └── plugins/  # 插件配置
    └── ...
```

## 安装

### 自动安装 (推荐)

```bash
# 克隆仓库
git clone https://github.com/username/dotfiles.git ~/.dotfiles

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
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# 安装 Neovim 插件
nvim --headless +"Lazy sync" +q

# 设置 zsh 为默认 shell
chsh -s $(which zsh)
```

## 快捷键

### Zsh
| 快捷键 | 功能 |
|--------|------|
| `ll` | 详细列表 (eza) |
| `lt` | 树形结构 |
| `fd xxx` | 搜索文件 |

### Neovim
| 快捷键 | 功能 |
|--------|------|
| `gcc` | 切换注释 |
| `sa` | 添加环绕 |
| `sd` | 删除环绕 |
| `sc` | 修改环绕 |
| `s/S` | 快速跳转 (flash.nvim) |
| `<leader>ff` | 搜索文件 |
| `<leader>fg` | 全局搜索 |
| `<leader>gg` | LazyGit |

## 已安装工具

- **zsh** - 现代化 shell
- **eza** - ls 替代
- **fd** - find 替代
- **btop** - top 替代
- **bat** - cat 替代
- **ripgrep** - grep 替代
- **fzf** - 模糊搜索
- **starship** - 提示符
- **zoxide** - 目录跳转
- **lazygit** - Git UI
- **Neovim** - 编辑器 (LazyVim)
