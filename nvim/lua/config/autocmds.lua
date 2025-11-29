-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LSP 문서 하이라이팅 활성화 (IntelliJ 스타일 식별자 강조)
-- 커서가 올라간 변수/파라미터와 같은 이름의 모든 참조를 하이라이트
local function lsp_highlight_document(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
    
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- LSP가 버퍼에 연결될 때 자동으로 문서 하이라이팅 활성화
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    
    -- 문서 하이라이팅 활성화
    lsp_highlight_document(client, bufnr)
  end,
})

-- 오늘자 Journal 파일을 열거나 템플릿을 복사해 생성하는 커맨드
local function open_today_journal()
  local dir = vim.fn.expand("~/Projects/bruce/Journal")
  local date = os.date("%Y-%m-%d")
  local file = dir .. "/" .. date .. ".md"

  vim.fn.mkdir(dir, "p")

  if vim.fn.filereadable(file) == 0 then
    local tpl_path = vim.fn.expand("~/Projects/bruce/Templates/journal.md")
    local lines = {}

    if vim.fn.filereadable(tpl_path) == 1 then
      lines = vim.fn.readfile(tpl_path)
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("{{date}}", date)
      end
    else
      lines = {
        "# " .. date .. " Journal",
        "",
        "## Highlights",
        "- ",
        "",
        "## Tasks",
        "- [ ] ",
        "",
        "## Notes",
        "- ",
      }
    end

    vim.fn.writefile(lines, file)
  end

  vim.cmd("edit " .. file)
end

vim.api.nvim_create_user_command("Journal", open_today_journal, { desc = "Open today's journal file" })

-- Markdown 일반 텍스트 색상 뉴트럴 톤으로 고정 (테마/플러그인 후킹 대비)
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("markdown_markup_neutral", { clear = true }),
  callback = function()
    local neutral = { fg = vim.g.terminal_color_foreground or "#F8F8F2" }
    vim.api.nvim_set_hl(0, "@markup", neutral)
    vim.api.nvim_set_hl(0, "@markup.strong", vim.tbl_extend("force", neutral, { bold = true }))
    vim.api.nvim_set_hl(0, "@markup.emphasis", vim.tbl_extend("force", neutral, { italic = true }))
    vim.api.nvim_set_hl(0, "@markup.list", { fg = "#8BE9FD" })
    vim.api.nvim_set_hl(0, "@markup.link", { fg = "#8BE9FD", underline = true })
    vim.api.nvim_set_hl(0, "@markup.link.url", { fg = "#8BE9FD", italic = true })
    vim.api.nvim_set_hl(0, "@markup.raw", { fg = "#F1FA8C" })
  end,
})
