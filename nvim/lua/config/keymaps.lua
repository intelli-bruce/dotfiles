-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 오늘자 Journal 파일 열기 (커맨드 래핑)
map("n", "<leader>jj", "<cmd>Journal<cr>", { desc = "Open today's Journal" })
