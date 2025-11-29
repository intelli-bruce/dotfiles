-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 오늘자 Journal 파일 열기 (커맨드 래핑)
map("n", "<leader>jj", "<cmd>Journal<cr>", { desc = "Open today's Journal" })

-- Markdown 파일을 Marked 2에서 미리보기
map("n", "<leader>mp", function()
  vim.fn.system('open -a "Marked 2" ' .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Preview in Marked 2" })

-- 타임스탬프 기반 새 Journal 노트 생성 및 열기
map("n", "<leader>jn", function()
  local base_dir = "/Volumes/WorkSSD/Projects/bruce/Journal"
  local filename = os.date("%Y-%m-%d_%H-%M-%S") .. ".md"
  local human_ts = os.date("%Y-%m-%d %H:%M:%S")
  local path = base_dir .. "/" .. filename

  vim.fn.mkdir(base_dir, "p")

  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({ "# " .. human_ts, "" }, path)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end, { desc = "New Journal note (timestamp)" })
