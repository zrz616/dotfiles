-- 自定义快捷键

local map = vim.keymap.set

-- 空格键作为 leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============ 基础操作 ============
map("n", "<leader>w", "<cmd>w<cr>", { desc = "保存" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "退出" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "强制退出所有" })

-- ============ Text Editing ============

-- 环绕编辑 (mini.surround)
-- 默认使用 s 键 (leap 优先)
-- sa 添加, sd 删除, sc 修改, sf 在前添加, sF 在后添加

-- 注释 (mini.comment)
-- gcc/gbc - 行注释, gcb/gc - 块注释

-- 移动增强 (使用 flash.nvim)

-- 交换文本 (vim-exchange)
map("n", "cx", "<Plug>(exchange)", { desc = "交换文本" })
map("n", "cxx", "<Plug>(exchange-line)", { desc = "交换行" })
map("n", "X", "<Plug>(exchange-operator)", { desc = "交换 (operator)" })

-- 搜索高亮
map("n", "n", function()
  require("hlslens").n()
end, { desc = "下一个搜索结果" })
map("n", "N", function()
  require("hlslens").N()
end, { desc = "上一个搜索结果" })

-- ============ 格式化 ============
map("n", "<leader>ff", function()
  require("conform").format({ async = true })
end, { desc = "格式化" })

-- ============ Telescope ============
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "搜索文件" })
map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "全局搜索" })
map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "搜索缓冲区" })
map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "搜索帮助" })

-- ============ LSP ============
map("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "跳转到定义" })
map("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "跳转到声明" })
map("n", "gi", function()
  vim.lsp.buf.implementation()
end, { desc = "跳转到实现" })
map("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "查看引用" })
map("n", "<leader>rn", function()
  vim.lsp.buf.rename()
end, { desc = "重命名" })
map("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "代码操作" })
map("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "查看文档" })

-- ============ 窗口导航 ============
map("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "向左窗口" })
map("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "向下窗口" })
map("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "向上窗口" })
map("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "向右窗口" })

-- ============ 标签页 ============
map("n", "<leader>t", "<cmd>tabnew<cr>", { desc = "新标签页" })
map("n", "<leader>x", "<cmd>tabclose<cr>", { desc = "关闭标签页" })
map("n", "<leader>1", "1gt", { desc = "标签页 1" })
map("n", "<leader>2", "2gt", { desc = "标签页 2" })
map("n", "<leader>3", "3gt", { desc = "标签页 3" })

-- ============ Git ============
map("n", "<leader>gg", function()
  require("lazygit").toggle()
end, { desc = "LazyGit" })

-- ============ 终端 ============
map("n", "<leader>te", "<cmd>terminal<cr>", { desc = "终端" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "退出终端模式" })

-- ============ 文本对象 (mini.ai) ============
-- 在 visual 模式下使用 a"/i" 等
map("o", "a\"", "<cmd>normal! T\"Et\"<cr>", { desc = "参数 (双引号)" })
map("o", "i\"", "<cmd>normal! t\"Et\"<cr>", { desc = "内部参数 (双引号)" })
map("v", "a\"", "<cmd>normal! T\"Et\"<cr>", { desc = "参数 (双引号)" })
map("v", "i\"", "<cmd>normal! t\"Et\"<cr>", { desc = "内部参数 (双引号)" })
