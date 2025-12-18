-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 스크롤 애니메이션 비활성화 (snacks.nvim)
vim.g.snacks_animate = false

-- 커서 라인 강조 활성화
vim.opt.cursorline = true

-- 줄 번호 비활성화 (leader+tn으로 토글)
vim.opt.number = false
vim.opt.relativenumber = false

-- Diagnostics 기본 비활성화
vim.diagnostic.enable(false)
