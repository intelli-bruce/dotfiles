-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 통합 Journal 열기 및 새 엔트리 추가
map("n", ";;", "<cmd>Journal<cr>", { desc = "Open Journal (add new entry)" })

-- 최하단에 타임스탬프 추가 (Journal 내에서 사용)
map("n", ";t", function()
  local datetime = os.date("%Y-%m-%d %H:%M:%S")
  vim.cmd("normal! G")
  local lines = { "", "---", "", "## " .. datetime, "", "" }
  vim.api.nvim_put(lines, "l", true, true)
  vim.cmd("normal! G")
  vim.cmd("startinsert!")
end, { desc = "Add timestamp at bottom" })

-- 줄 번호 토글
map("n", "<leader>tn", function()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle line numbers" })

-- Diagnostics 토글
map("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- 새 책 노트 생성
map("n", "<leader>bn", "<cmd>BookNote<cr>", { desc = "Create new book note" })

-- Visual 모드에서 하이라이트 (==텍스트==)
map("v", "<leader>h", 'c==<C-r>"==<Esc>', { desc = "Highlight selection" })

-- Markdown 파일을 Marked 2에서 미리보기
map("n", "<leader>mp", function()
  vim.fn.system('open -a "Marked 2" ' .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Preview in Marked 2" })
