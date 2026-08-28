-- 自定义选项配置

-- 设置 leader 键为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 启用更多功能
vim.opt.clipboard = "unnamedplus" -- 系统剪贴板
vim.opt.swapfile = false -- 不创建 swap 文件
vim.opt.backup = false -- 不创建备份
vim.opt.writebackup = false
vim.opt.undofile = true -- 持久化撤销
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- 行号和相对行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 高亮当前行
vim.opt.cursorline = true

-- 缩进
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- 搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 滚动
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- 拆分窗口
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 主题
vim.opt.termguicolors = true

-- 禁用某些内置插件
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- NeoTree 配置
vim.g.neo_tree_remove_legacy_commands = 1
