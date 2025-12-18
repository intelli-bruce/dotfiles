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

-- 통합 Journal 파일 열기 및 새 엔트리 추가
local function open_journal()
  local file = vim.fn.expand("~/Projects/bruce/journal.md")
  local datetime = os.date("%Y-%m-%d %H:%M:%S")

  -- 파일이 없으면 헤더와 함께 생성
  if vim.fn.filereadable(file) == 0 then
    vim.fn.writefile({ "# Journal", "" }, file)
  end

  -- 파일 열기
  vim.cmd("edit " .. file)

  -- 파일 끝으로 이동 후 새 엔트리 추가
  vim.cmd("normal! G")
  local lines = { "", "---", "", "## " .. datetime, "", "" }
  vim.api.nvim_put(lines, "l", true, true)

  -- 마지막 줄에서 insert 모드로 전환
  vim.cmd("normal! G")
  vim.cmd("startinsert!")
end

vim.api.nvim_create_user_command("Journal", open_journal, { desc = "Open journal and add new entry" })

-- 새 책 노트 생성 (카카오 책 검색 API 연동 + Telescope)
local function create_book_note()
  local kakao_api_key = "c70ca47eab4937b289c25f7a2619e377"

  vim.ui.input({ prompt = "책 검색: " }, function(query)
    if not query or query == "" then
      return
    end

    -- 카카오 API로 책 검색 (10개 결과)
    local encoded_query = vim.fn.system("printf %s " .. vim.fn.shellescape(query) .. " | jq -sRr @uri"):gsub("\n", "")
    local curl_cmd = string.format(
      'curl -s -H "Authorization: KakaoAK %s" "https://dapi.kakao.com/v3/search/book?query=%s&size=10"',
      kakao_api_key,
      encoded_query
    )
    local result = vim.fn.system(curl_cmd)
    local ok, data = pcall(vim.fn.json_decode, result)

    if not ok or not data or not data.documents or #data.documents == 0 then
      vim.notify("검색 결과가 없습니다: " .. query, vim.log.levels.WARN)
      return
    end

    -- Telescope로 결과 선택
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local books = {}
    for _, book in ipairs(data.documents) do
      table.insert(books, {
        title = book.title or "",
        author = table.concat(book.authors or {}, ", "),
        publisher = book.publisher or "",
        cover = book.thumbnail or "",
        isbn = book.isbn or "",
        display = string.format("%s | %s | %s", book.title or "", table.concat(book.authors or {}, ", "), book.publisher or ""),
      })
    end

    pickers
      .new({}, {
        prompt_title = "책 선택",
        finder = finders.new_table({
          results = books,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.display,
              ordinal = entry.display,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            if not selection then
              return
            end

            local book = selection.value
            local notes_dir = vim.fn.expand("~/Projects/bruce/Learning/Books/notes/")
            local safe_title = book.title:gsub("[/\\:*?\"<>|]", "-")
            local file_path = notes_dir .. safe_title .. ".md"
            local datetime = os.date("%Y-%m-%d")

            local template = {
              "---",
              'title: "' .. book.title .. '"',
              "author:",
              '  - "' .. book.author .. '"',
              "publisher: " .. book.publisher,
              "isbn: " .. book.isbn,
              'status: "To Read"',
              'platform: ""',
              "cover: " .. book.cover,
              "created: " .. datetime,
              "updated: " .. datetime,
              "---",
              "",
              "## Highlights",
              "- ",
              "",
              "## Summary",
              "- ",
              "",
              "## Actions / Questions",
              "- ",
            }

            vim.fn.writefile(template, file_path)
            vim.cmd("edit " .. vim.fn.fnameescape(file_path))
            vim.notify("책 노트 생성: " .. book.title, vim.log.levels.INFO)
          end)
          return true
        end,
      })
      :find()
  end)
end

vim.api.nvim_create_user_command("BookNote", create_book_note, { desc = "Create new book note" })

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

-- Markdown 등에서 맞춤법 검사 비활성화 (LazyVim 기본 설정 제거)
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
