-- 기본 옵션
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- netrw 비활성화 (nvim-tree와 충돌 방지)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- lazy.nvim 플러그인 매니저 설정
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 플러그인 설치 목록
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-lualine/lualine.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "tpope/vim-fugitive" },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true
  },
})

-- 색상 테마 적용
vim.cmd.colorscheme "catppuccin-mocha"

-- nvim-tree 초기화
require("nvim-tree").setup({})

-- 상태바 초기화
require("lualine").setup({})

-- mason-lspconfig 설치 목록
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",        -- Lua
    "pyright",       -- Python
    "rust_analyzer", -- Rust
    "clangd",        -- C/C++
    "marksman",      -- Markdown
  },
})

-- 단축키 설정
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- 탐색기 토글
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true }) -- 파일 검색

-- ToggleTerm 설정
require("toggleterm").setup({
  size = 20,
  open_mapping = [[<C-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

-- 터미널 단축키
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true }) -- 플로팅 터미널
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { noremap = true, silent = true }) -- 가로 분할 터미널
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { noremap = true, silent = true }) -- 세로 분할 터미널
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true }) -- 터미널 모드 종료

-- 터미널 크기 조절 단축키
vim.keymap.set("n", "<leader>t+", ":lua require('toggleterm').resize(5)<CR>", { noremap = true, silent = true }) -- 터미널 크기 증가
vim.keymap.set("n", "<leader>t-", ":lua require('toggleterm').resize(-5)<CR>", { noremap = true, silent = true }) -- 터미널 크기 감소

-- Yazi 파일 탐색기 단축키
vim.keymap.set("n", "<leader>fe", ":ToggleTerm direction=float cmd=yazi<CR>", { desc = "Yazi 파일 탐색기 열기", noremap = true, silent = true })

