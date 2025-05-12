-- 리더 키 설정 (반드시 다른 설정보다 먼저 로드되어야 함)
vim.g.mapleader = " " -- 스페이스바를 리더 키로 설정
vim.g.maplocalleader = " " -- 로컬 리더 키도 스페이스바로 설정

-- 기본 옵션
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes" -- 사인 컬럼 항상 표시 (LSP 진단용)
vim.opt.updatetime = 300 -- 더 빠른 업데이트 시간 (기본값은 4000ms)
vim.opt.cursorline = true -- 현재 라인 강조
vim.opt.wrap = false -- 라인 래핑 비활성화
vim.opt.swapfile = false -- 스왑 파일 비활성화
vim.opt.backup = false -- 백업 파일 비활성화
vim.opt.undofile = true -- 영속적인 실행 취소 기록
vim.opt.ignorecase = true -- 검색 시 대소문자 무시
vim.opt.smartcase = true -- 대문자가 포함된 경우 대소문자 구분
vim.opt.hlsearch = true -- 검색 결과 강조
vim.opt.incsearch = true -- 증분 검색

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
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "tpope/vim-fugitive" },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true
  },
  { "nvim-lua/plenary.nvim" },
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "j-hui/fidget.nvim", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "RRethy/vim-illuminate" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "github/copilot.vim" }, -- GitHub Copilot
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- MacOS/Linux에만 필요
    opts = {}, -- 기본 설정 사용
  },

  -- Flutter 개발용 플러그인
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- 선택 UI
    },
    lazy = false, -- 항상 로드 (ft 및 event 조건 없이)
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "native",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          }
        },
        widget_guides = {
          enabled = true,
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit", -- 로그를 새 탭에 표시
        },
        lsp = {
          color = {
            enabled = true,
            background = true,
          },
          on_attach = function(client, bufnr)
            -- LSP 명령어를 위한 키맵 설정
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
            -- 이 함수가 LSP가 연결될 때 호출됩니다
            print("Flutter LSP connected!")
          end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            analysisExcludedFolders = {
              vim.fn.expand("$HOME/.pub-cache"),
              vim.fn.expand("$HOME/fvm"),
            },
          }
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
        },
        closing_tags = {
          highlight = "ErrorMsg",
          prefix = "//",
          enabled = true,
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        fvm = true, -- Flutter 버전 관리자 지원 활성화
      })

      -- 플러그인 로드 후 직접 명령어 정의
      -- 오래된 버전과 새 버전 둘 다 지원하기 위해 pcall 사용
      local function safeRequire(module)
        local ok, result = pcall(require, module)
        if ok then
          return result
        else
          return nil
        end
      end

      -- Flutter 명령어 등록
      local commands_module = safeRequire("flutter-tools.commands")
      if commands_module then
        if commands_module.devices then
          vim.cmd("command! -nargs=0 FlutterDevices lua require('flutter-tools.commands').devices()")
        elseif commands_module.list_devices then
          vim.cmd("command! -nargs=0 FlutterDevices lua require('flutter-tools.commands').list_devices()")
        end

        if commands_module.run_command then
          vim.cmd("command! -nargs=0 FlutterRun lua require('flutter-tools.commands').run_command()")
        end
      else
        -- 명령어 모듈을 찾을 수 없는 경우 기본 명령어로 대체
        vim.cmd([[
          command! -nargs=0 FlutterRun terminal flutter run
          command! -nargs=0 FlutterDevices terminal flutter devices
          command! -nargs=0 FlutterEmulators terminal flutter emulators
        ]])
      end

      -- 로더 실행 시 Flutter 관련 플러그인 설치 확인 메시지 출력
      print("Flutter Tools 플러그인이 로드되었습니다.")
    end,
  },
  { "mfussenegger/nvim-dap" },
  { "nvim-neotest/nvim-nio" }, -- nvim-dap-ui의 종속성
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },
  { "stevearc/dressing.nvim" }, -- 향상된 UI 구성 요소
  { "rafamadriz/friendly-snippets" }, -- 추가 스니펫 컬렉션
})

-- 색상 테마 적용
vim.cmd.colorscheme "catppuccin-mocha"

-- nvim-tree 초기화
require("nvim-tree").setup({})

-- 상태바 초기화
require("lualine").setup({})

-- Telescope 확장 기능 설정
require("telescope").setup({})
require("telescope").load_extension("file_browser")

-- Telescope file browser 단축키 설정
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { desc = "파일 브라우저 열기", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fp", ":Telescope file_browser path=%:p:h<CR>", { desc = "현재 파일 위치에서 브라우저 열기", noremap = true, silent = true })

-- Mason 설정 (LSP, linter, formatter 설치 관리자)
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  log_level = vim.log.levels.DEBUG, -- 문제 해결을 위해 로깅 레벨 증가
})

-- Mason 과 LSP 설정 연결
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",        -- Lua
    "pyright",       -- Python
    "ts_ls",         -- Typescript (tsserver 대신)
    "rust_analyzer", -- Rust
    "clangd",        -- C/C++
    "marksman",      -- Markdown
  },
  automatic_installation = true,
})

-- LSP 설정
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP 서버 설정
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- vim global 인식
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.pyright.setup({
  capabilities = capabilities,
})

-- TypeScript/JavaScript 설정 (tsserver -> ts_ls로 서버 이름 변경)
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
})

lspconfig.clangd.setup({
  capabilities = capabilities,
})

lspconfig.marksman.setup({
  capabilities = capabilities,
})

-- Flutter/Dart LSP 설정은 flutter-tools.nvim이 자동으로 설정함
-- 직접 설정하지 않음 (dartls는 mason-lspconfig에서 유효한 이름이 아님)

-- nvim-cmp 설정 (자동 완성)
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- 스니펫 확장에 LuaSnip 사용
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 자동 선택 허용
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- LSP
    { name = "luasnip" },  -- 스니펫
    { name = "buffer" },   -- 버퍼 내용
    { name = "path" },     -- 파일 경로
  }),
  formatting = {
    format = function(entry, vim_item)
      -- 아이콘 추가 가능
      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      }
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- 명령행 모드 자동 완성 설정
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" }
  })
})

-- 검색 모드 자동 완성 설정
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

-- Trouble.nvim 설정 (진단 목록 표시)
require("trouble").setup({
  icons = true,
  signs = {
    error = "✘",
    warning = "▲",
    hint = "⚑",
    information = "»",
    other = "◦"
  },
  use_diagnostic_signs = false
})

-- LSP 단축키 설정
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
  print("Formatting code with LSP")
end, { desc = "Format code" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- nvim-dap 디버깅 설정
local dap = require("dap")
local dapui = require("dapui")

-- DAP UI 설정
dapui.setup({
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
  },
})

-- 가상 텍스트 설정 (변수 값 표시)
require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  all_frames = true,
  virt_text_pos = "eol",
  all_references = true,
  display_callback = function(variable, buf, stackframe, node, options)
    if options.virt_text_pos == "eol" then
      return " = " .. variable.value
    else
      return variable.name .. " = " .. variable.value
    end
  end,
})

-- Flutter/Dart 디버깅 설정
dap.adapters.dart = {
  type = "executable",
  command = "flutter",
  args = { "debug_adapter" }
}

dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Flutter 앱 실행",
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
    toolArgs = {"-d", "chrome"} -- 기본적으로 Chrome에서 실행 (변경 가능)
  }
}

-- 이벤트에 따른 자동 UI 표시/숨김
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- 디버깅 단축키
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "breakpoint 토글" })
vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "조건부 breakpoint 설정" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "디버깅 시작/계속" })
vim.keymap.set("n", "<leader>dn", function() require("dap").step_over() end, { desc = "다음 단계로" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "함수 내부로" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "함수 밖으로" })
vim.keymap.set("n", "<leader>dq", function() require("dap").terminate() end, { desc = "디버깅 종료" })
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "디버깅 UI 토글" })

-- Trouble.nvim 단축키
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle trouble" })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location list" })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix list" })

-- 추가 단축키 설정
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- 탐색기 토글
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true }) -- 파일 검색
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })

-- Comment.nvim 초기화
require("Comment").setup({
  mappings = {
    basic = true,  -- 기본 매핑 활성화
    extra = true,  -- 추가 매핑 활성화
  },
})

-- GitSigns 초기화
require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})

-- Illuminate 초기화
require("illuminate").configure({
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 100,
  filetypes_denylist = {
    "dirvish",
    "fugitive",
    "NvimTree",
  },
})

-- Indent Blankline 초기화
require("ibl").setup()

-- Autopairs 초기화
require("nvim-autopairs").setup()

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
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true }) -- 기존 ESC 매핑 비활성화
vim.keymap.set("t", "<C-]>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "터미널 모드 종료" }) -- 대체 키 매핑

-- 터미널 크기 조절 단축키
vim.keymap.set("n", "<leader>t+", ":lua require('toggleterm').resize(5)<CR>", { noremap = true, silent = true }) -- 터미널 크기 증가
vim.keymap.set("n", "<leader>t-", ":lua require('toggleterm').resize(-5)<CR>", { noremap = true, silent = true }) -- 터미널 크기 감소

-- Yazi 파일 탐색기 단축키
vim.keymap.set("n", "<leader>fe", ":ToggleTerm direction=float cmd=yazi<CR>", { desc = "Yazi 파일 탐색기 열기", noremap = true, silent = true })
-- Treesitter 설정
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "vim", "vimdoc", "query", -- Neovim 개발
    "python", "javascript", "typescript", "tsx", -- 웹/앱 개발
    "html", "css", "json", "yaml", "toml", -- 마크업/데이터
    "rust", "c", "cpp", -- 시스템 프로그래밍
    "markdown", "markdown_inline", -- 추가 언어
    "dart", -- Flutter/Dart 개발용
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<C-backspace>",
    },
  },
})

-- 창 이동 단축키
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "창 왼쪽으로 이동" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "창 아래로 이동" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "창 위로 이동" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "창 오른쪽으로 이동" })

-- 창 크기 조절 단축키
vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", { desc = "창 가로 크기 줄이기" })
vim.keymap.set("n", "<A-j>", ":resize +2<CR>", { desc = "창 세로 크기 늘리기" })
vim.keymap.set("n", "<A-k>", ":resize -2<CR>", { desc = "창 세로 크기 줄이기" })
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", { desc = "창 가로 크기 늘리기" })

-- 버퍼 관리 단축키
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "이전 버퍼" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "다음 버퍼" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "버퍼 닫기" })

-- LuaSnip 설정 - Flutter 스니펫 로드
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip").filetype_extend("dart", { "flutter" })

-- 명령어는 플러그인 설정에서 정의됨

-- Flutter 관련 명령어 단축키 설정
local opts = { noremap = true, silent = true }

-- 기본 명령어 (직접 터미널에서 실행)
vim.keymap.set("n", "<leader>rf", ":terminal flutter run<CR>", { desc = "Flutter 앱 실행", unpack(opts) })
vim.keymap.set("n", "<leader>rv", ":terminal flutter devices<CR>", { desc = "Flutter 기기 목록", unpack(opts) })
vim.keymap.set("n", "<leader>re", ":terminal flutter emulators<CR>", { desc = "Flutter 에뮬레이터 목록", unpack(opts) })
vim.keymap.set("n", "<leader>rp", ":terminal flutter pub get<CR>", { desc = "Flutter pub get", unpack(opts) })
-- Flutter 앱 실행 시 핫 리로드/핫 리스타트는 터미널에서 r/R 키를 입력하여 사용
-- 참고 안내 주석
-- 일반 Neovim에서는 앱이 실행 중인 터미널 창으로 전환한 후:
-- - 'r'을 입력하여 핫 리로드 (상태 유지)
-- - 'R'을 입력하여 핫 리스타트 (상태 초기화)

-- 플러그인 명령어도 시도 (사용 가능한 경우에만 작동)
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter 앱 실행", unpack(opts) })
vim.keymap.set("n", "<leader>fv", ":FlutterDevices<CR>", { desc = "Flutter 기기 목록", unpack(opts) })

-- 자동 Hot-Reload 설정
vim.cmd [[
  augroup flutter_autosave
    autocmd!
    autocmd BufWritePost *.dart silent! :FlutterReload
  augroup END
]]

-- 기타 유용한 단축키
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "저장", noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "종료", noremap = true, silent = true })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "검색 강조 제거", noremap = true, silent = true })
vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "주석 토글", noremap = true, silent = true })
-- LazyGit 특별 설정 (ToggleTerm 사용)
local lazygit_config = function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
    on_open = function(term)
      vim.cmd("startinsert!")
      -- LazyGit 버퍼에서 ESC 키 매핑 제거
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<Esc>", { noremap = true, silent = true })
    end,
  })

  function _lazygit_toggle()
    lazygit:toggle()
  end

  return lazygit
end

local lazygit = lazygit_config()
vim.keymap.set("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { desc = "LazyGit 열기", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fh", ":Git log -- %<CR>", { desc = "현재 파일 히스토리 보기", noremap = true })

-- 쉬운 인덴트
vim.keymap.set("v", "<", "<gv", { desc = "인덴트 줄이기 (선택 유지)" })
vim.keymap.set("v", ">", ">gv", { desc = "인덴트 늘리기 (선택 유지)" })

-- 블록 이동
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "선택 블록을 아래로 이동" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "선택 블록을 위로 이동" })

-- GitHub Copilot 설정
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-H>", 'copilot#Previous()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-L>", 'copilot#Next()', { silent = true, expr = true })
vim.g.copilot_filetypes = {
  ["*"] = true,
}

-- GitHub Copilot Chat 설정
local copilot_chat = require("CopilotChat")
copilot_chat.setup({
  -- 단축키 설정
  mappings = {
    -- 프롬프트 제출
    submit_prompt = {
      normal = "<leader>cc",
      insert = "<C-c>c",
    },
    -- 코드 리뷰
    review_code = {
      normal = "<leader>cr",
    },
    -- 코드 설명
    explain_code = {
      normal = "<leader>ce",
    },
    -- 에러 수정
    fix_diagnostic = {
      normal = "<leader>cf",
    },
    -- 다음/이전 이력
    next_entry = {
      normal = "]h",
    },
    prev_entry = {
      normal = "[h",
    },
  },
  -- 사용자 정의 프롬프트
  prompts = {
    Refactor = {
      prompt = "Refactor the following code to improve readability and efficiency:",
      mapping = "<leader>cfr",
      description = "코드 리팩토링",
    },
    Optimize = {
      prompt = "Optimize the following code for better performance:",
      mapping = "<leader>cfo",
      description = "코드 최적화",
    },
    DocString = {
      prompt = "Create a comprehensive documentation string for the following code:",
      mapping = "<leader>cfd",
      description = "문서화 생성",
    },
  },
})