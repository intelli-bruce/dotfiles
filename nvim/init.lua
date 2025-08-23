-- 중복 로드 방지
if vim.g.init_lua_loaded then
  return
end
vim.g.init_lua_loaded = true

-- 리더 키 설정 (반드시 다른 설정보다 먼저 로드되어야 함)
vim.g.mapleader = " " -- 스페이스바를 리더 키로 설정
vim.g.maplocalleader = " " -- 로컬 리더 키도 스페이스바로 설정

-- Leader 키를 누를 때 자동으로 영문으로 전환
vim.keymap.set({'n', 'v', 'x', 's', 'o'}, '<Space>', function()
  -- im-select를 사용하여 영문(ABC)으로 전환
  vim.fn.system('im-select com.apple.keylayout.ABC')
  -- 원래 leader 키 기능 수행
  return '<Space>'
end, { expr = true, silent = true, desc = "Switch to English and act as leader" })

-- Normal 모드 진입 시 자동으로 영문으로 전환 (ESC 키)
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    -- 현재 입력 방법 저장
    vim.b.input_method = vim.fn.system('im-select'):gsub('\n', '')
    -- 영문으로 전환
    vim.fn.system('im-select com.apple.keylayout.ABC')
  end,
  desc = "Switch to English when leaving Insert mode"
})

-- Insert 모드 진입 시 이전 입력 방법으로 복원
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    -- 이전에 저장된 입력 방법이 있으면 복원
    if vim.b.input_method and vim.b.input_method ~= '' then
      vim.fn.system('im-select ' .. vim.b.input_method)
    end
  end,
  desc = "Restore previous input method when entering Insert mode"
})

-- 기본 옵션
vim.opt.number = true
vim.opt.relativenumber = false  -- 상대 줄 번호 비활성화 (절대 줄 번호만 표시)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes" -- 사인 컬럼 표시
vim.opt.numberwidth = 4 -- 줄 번호 컬럼 너비 (기본값)
vim.opt.fillchars = "eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸" -- 빈 공간 문자 설정
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
vim.opt.autoread = true -- 외부에서 파일이 변경되면 자동으로 다시 로드
vim.opt.timeoutlen = 300 -- 키 시퀀스 대기 시간 (leader 키 지연 감소)
vim.opt.shada = "!,'1000,<50,s10,h" -- 최근 파일 1000개까지 기억

-- netrw 비활성화 (nvim-tree와 충돌 방지)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 한글 입력 자동 전환 설정 (macOS) - 임시 비활성화 (에러 디버깅)
-- if vim.fn.has('mac') == 1 then
--   -- Insert mode 진입 시 이전 입력 소스 저장
--   vim.api.nvim_create_autocmd({"InsertEnter"}, {
--     pattern = "*",
--     callback = function()
--       vim.b.ime_status = vim.fn.system([[osascript -e 'tell application "System Events" to get the name of the current input source']])
--     end
--   })
--   
--   -- Insert mode 벗어날 때 영문으로 전환
--   vim.api.nvim_create_autocmd({"InsertLeave"}, {
--     pattern = "*",
--     callback = function()
--       os.execute([[osascript -e 'tell application "System Events" to select input source "ABC"' &]])
--     end
--   })
-- end

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
  { "dracula/vim", name = "dracula", priority = 1000 },  -- Dracula 테마
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
  { 
    "lukas-reineke/indent-blankline.nvim", 
    main = "ibl",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- 하이라이트 그룹 설정
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2A2D37" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#6272A4", bold = true })
      
      require("ibl").setup({
        indent = {
          char = "┊",
        },
        scope = {
          enabled = true,
          char = "┊",
          show_start = true,
          show_end = true,
          highlight = "IblScope",
        },
      })
    end,
  },
  { "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  -- { "github/copilot.vim" }, -- 기존 VimScript 버전 (비활성화)
  {
    "zbirenbaum/copilot.lua",  -- 더 빠른 Lua 버전으로 업그레이드
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,  -- 자동으로 제안 표시
          hide_during_completion = true,  -- nvim-cmp 열릴 때 숨김
          debounce = 75,
          keymap = {
            accept = "<C-J>",  -- 기존 키맵 유지
            accept_word = false,
            accept_line = false,
            next = "<C-L>",    -- 기존 키맵 유지
            prev = "<C-H>",    -- 기존 키맵 유지
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom",
            ratio = 0.4
          },
        },
        filetypes = {
          ["*"] = true,  -- 모든 파일 타입에서 활성화
          yaml = false,
          markdown = true,  -- Markdown에서도 활성화
          help = false,
          gitcommit = true,  -- Git 커밋 메시지에서도 활성화
          gitrebase = false,
          ["."] = false,
        },
        copilot_node_command = 'node',  -- Node.js 20+ 필요
        server_opts_overrides = {},
      })
    end,
  },
  { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" }, -- Git diff 뷰어
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },  -- copilot.lua와 함께 사용
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- MacOS/Linux에만 필요
    opts = {}, -- 기본 설정 사용
  },
  { "folke/which-key.nvim", opts = {} },
  { "b0o/schemastore.nvim" }, -- JSON 스키마 저장소
  { "HiPhish/rainbow-delimiters.nvim" }, -- 괄호 색상 표시
  
  -- 한/영 자동 전환 플러그인 (im-select 사용)
  {
    "keaising/im-select.nvim",
    config = function()
      require('im_select').setup({
        -- 기본 입력기 (영어)
        default_im_select = "com.apple.keylayout.ABC",
        
        -- macOS의 im-select 명령어 사용
        default_command = "im-select",
        
        -- Normal 모드로 전환 시 영어로 변경
        set_default_events = { "VimEnter", "InsertLeave", "CmdlineLeave" },
        
        -- Insert 모드 진입 시 이전 입력기로 복원
        set_previous_events = { "InsertEnter" },
      })
    end,
  },
  -- minimap.vim 제거 (code-minimap 바이너리 필요)
  -- { 
  --   "wfxr/minimap.vim", 
  --   config = function()
  --     vim.g.minimap_width = 10
  --     vim.g.minimap_auto_start = 1
  --     vim.g.minimap_auto_start_win_enter = 1
  --     vim.g.minimap_highlight_range = 1
  --     vim.g.minimap_highlight_search = 1
  --     vim.g.minimap_git_colors = 1
  --   end
  -- },

  { "rafamadriz/friendly-snippets" }, -- 추가 스니펫 컬렉션
  
  -- Flutter 개발 도구
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- UI 개선
    },
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
          },
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
        lsp = {
          color = {
            enabled = true,
            background = true,
            virtual_text = true,
          },
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
          },
        },
        debugger = {
          enabled = false, -- 디버거 사용시 true
          run_via_dap = false,
        },
      })
    end,
  },
  
  -- Code Action 개선 플러그인 (더 안정적인 버전)
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup({
        diff = {
          algorithm = "patience",
          ignore_whitespace = true,
        },
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      })
    end,
  },
  
  -- 미니맵 플러그인 옵션 1: Satellite (스크롤바 스타일)
  {
    "lewis6991/satellite.nvim",
    enabled = true,  -- false로 변경하면 mini.map 사용
    config = function()
      require('satellite').setup({
        current_only = false,  -- 모든 창에 미니맵 표시
        winblend = 50,  -- 투명도 (0-100, 낮을수록 불투명)
        zindex = 40,
        excluded_filetypes = { "NvimTree", "prompt", "TelescopePrompt", "DashboardHeader", "alpha" },
        width = 2,  -- 미니맵 너비
        handlers = {
          cursor = {
            enable = true,
            overlap = true,
            -- 커서 위치 표시
            symbols = { '⎺', '⎻', '⎼', '⎽' }
          },
          search = {
            enable = true,
            overlap = true,
            -- 검색 결과 표시
            symbols = { '◉', '◎' }
          },
          diagnostic = {
            enable = true,
            signs = {'-', '=', '≡'},
            min_severity = vim.diagnostic.severity.HINT,
          },
          gitsigns = {
            enable = true,
            signs = {
              add = "│",
              change = "│",
              delete = "-",
            },
          },
          marks = {
            enable = true,
            show_builtins = false,
          },
        },
      })
    end
  },
  
  -- 미니맵 플러그인 옵션 2: mini.map (코드 미니맵)
  {
    'echasnovski/mini.map',
    enabled = false,  -- true로 변경하면 이것을 사용
    version = false,
    config = function()
      local map = require('mini.map')
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = 'DiagnosticFloatingError',
            warn  = 'DiagnosticFloatingWarn',
            info  = 'DiagnosticFloatingInfo',
            hint  = 'DiagnosticFloatingHint',
          }),
          map.gen_integration.gitsigns(),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot('4x2'),
          scroll_line = '█',
          scroll_view = '┃',
        },
        window = {
          side = 'right',
          width = 15, -- 미니맵 너비
          winblend = 15, -- 투명도
          show_integration_count = false,
        },
      })
      
      -- 자동으로 미니맵 열기
      vim.keymap.set('n', '<Leader>mm', map.toggle, { desc = "미니맵 토글" })
      vim.keymap.set('n', '<Leader>mr', map.refresh, { desc = "미니맵 새로고침" })
      
      -- 파일 열 때 자동으로 미니맵 표시
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local ft = vim.bo.filetype
          local excluded = { "NvimTree", "TelescopePrompt", "alpha", "dashboard" }
          if not vim.tbl_contains(excluded, ft) and vim.fn.line('$') > 50 then
            map.open()
          end
        end,
      })
    end
  },
  
  -- 대시보드 플러그인 (선택사항)
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      -- 헤더 (로고)
      dashboard.section.header.val = {
        "",
        "                        Small Team. Huge Impact.",
        "",
        "░▒▓█▓▒░▒▓███████▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░",
        "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░",
        "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░",
        "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓██████▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░",
        "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░",
        "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░",
        "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓████████▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓█▓▒░",
        "",
        "░▒▓████████▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓██████▓▒░▒▓████████▓▒░",
        "░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ",
        "░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░    ",
        "░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░        ░▒▓█▓▒░    ",
        "░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░    ",
        "░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ",
        "░▒▓████████▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓████████▓▒░▒▓██████▓▒░  ░▒▓█▓▒░   ░▒▓██████▓▒░",
        "",
        "",
      }
      
      -- 메뉴 버튼 (비활성화)
      dashboard.section.buttons.val = {
        -- 버튼을 원하지 않으면 빈 테이블로 설정
      }
      
      -- 푸터 (선택사항)
      local function footer()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
      end
      
      dashboard.section.footer.val = footer()
      
      -- 색상 설정
      dashboard.section.header.opts.hl = "Title"  -- 더 밝은 색상으로 변경
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.section.footer.opts.hl = "Comment"
      
      -- 레이아웃
      dashboard.opts.layout[1].val = 8
      
      alpha.setup(dashboard.opts)
      
      -- 대시보드 자동 열기 설정
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          dashboard.section.footer.val = footer()
          pcall(vim.cmd.AlphaRedraw)
          
          -- 대시보드 로드 후 nvim-tree 자동 열기
          vim.defer_fn(function()
            if vim.bo.filetype == "alpha" then
              require("nvim-tree.api").tree.open()
            end
          end, 100)
        end,
      })
      
      -- nvim 시작 시 특정 조건에서만 대시보드와 nvim-tree 함께 열기
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- 조건: 인수 없음, 빈 버퍼, 인서트 모드 아님, 파이프 입력 없음
          local should_open_dashboard = vim.fn.argc() == 0 
            and vim.fn.line2byte("$") == -1 
            and not vim.o.insertmode
            and vim.fn.empty(vim.v.stdin_data) == 1  -- 파이프 입력 체크
          
          if should_open_dashboard then
            vim.defer_fn(function()
              -- alpha 대시보드가 현재 버퍼인지 확인 후 nvim-tree 열기
              if vim.bo.filetype == "alpha" then
                require("nvim-tree.api").tree.open()
              end
            end, 200)  -- 딜레이를 200ms로 증가
          end
        end,
      })
    end,
  },
}, {
  -- Lazy.nvim 옵션
  install = {
    missing = true,
    colorscheme = { "dracula" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
    },
  },
})

-- 색상 테마 적용 (Dracula 스타일)
vim.cmd("colorscheme dracula")

-- nvim-tree 색상을 즉시 적용
vim.defer_fn(function()
  vim.cmd("highlight NvimTreeNormal guibg=#2A2D37")  -- 트리 패널 배경색 (약간 밝은 회색)
  vim.cmd("highlight NvimTreeNormalNC guibg=#2A2D37")  -- 비활성 상태 트리 패널
  vim.cmd("highlight NvimTreeWinSeparator guifg=#44475A guibg=#2A2D37")  -- 트리 패널 구분선
  vim.cmd("highlight NvimTreeEndOfBuffer guibg=#2A2D37")  -- 버퍼 끝 부분
  vim.cmd("highlight NvimTreeCursorLine guibg=#383C4A")  -- 커서 라인 (더 밝게)
  vim.cmd("highlight NvimTreeFolderIcon guifg=#8BE9FD")  -- 폴더 아이콘 색상
  vim.cmd("highlight NvimTreeFolderName guifg=#8BE9FD")  -- 폴더 이름 색상
  vim.cmd("highlight NvimTreeOpenedFolderName guifg=#50FA7B")  -- 열린 폴더 색상
  vim.cmd("highlight NvimTreeEmptyFolderName guifg=#6272A4")  -- 빈 폴더 색상
  vim.cmd("highlight NvimTreeRootFolder guifg=#F1FA8C gui=bold")  -- 루트 폴더 (노란색, 굵게)
  vim.cmd("highlight NvimTreeGitDirty guifg=#FFB86C")  -- Git 변경된 파일
  vim.cmd("highlight NvimTreeGitNew guifg=#50FA7B")  -- Git 새 파일
  vim.cmd("highlight NvimTreeGitDeleted guifg=#FF5555")  -- Git 삭제된 파일
  
  -- Indent-Blankline 색상도 함께 적용
  vim.cmd("highlight IblIndent guifg=#2A2D37")  -- 매우 연한 회색
  vim.cmd("highlight IblScope guifg=#6272A4")  -- 현재 스코프는 보라색으로 강조
  
  -- Cursorline 설정 재적용
  vim.cmd("highlight CursorLine cterm=NONE ctermbg=234 guibg=#323442")
  vim.cmd("highlight CursorLineNr cterm=bold ctermfg=226 guifg=#F1FA8C gui=bold")
end, 100)  -- 100ms 딜레이 후 적용

-- Dracula Colorful 스타일을 위한 추가 하이라이팅 설정
-- 기본 텍스트 색상을 약간 더 어둡게 변경 (#F8F8F2 -> #E6E6E6)
-- 배경을 투명하게 설정 (guibg=NONE)
vim.api.nvim_command("highlight Normal guifg=#E6E6E6 guibg=NONE ctermbg=NONE")
vim.api.nvim_command("highlight NormalFloat guifg=#E6E6E6 guibg=NONE ctermbg=NONE")
vim.api.nvim_command("highlight NormalNC guifg=#CCCCCC guibg=NONE ctermbg=NONE")

vim.api.nvim_command("highlight Comment ctermfg=61 guifg=#6272A4")
vim.api.nvim_command("highlight CursorLine cterm=NONE ctermbg=234 guibg=#323442")
vim.api.nvim_command("highlight CursorLineNr cterm=bold ctermfg=226 guifg=#F1FA8C gui=bold")
vim.api.nvim_command("highlight Visual ctermbg=61 guibg=#3E4452")
vim.api.nvim_command("highlight Search ctermbg=180 ctermfg=16 guibg=#FFB86C guifg=#282A36")
vim.api.nvim_command("highlight IncSearch ctermbg=169 ctermfg=16 guibg=#FF79C6 guifg=#282A36")
vim.api.nvim_command("highlight String ctermfg=228 guifg=#F1FA8C")
vim.api.nvim_command("highlight Function ctermfg=84 guifg=#50FA7B")
vim.api.nvim_command("highlight Identifier ctermfg=159 guifg=#8BE9FD")
vim.api.nvim_command("highlight Statement ctermfg=212 guifg=#FF79C6")
vim.api.nvim_command("highlight Keyword ctermfg=212 guifg=#FF79C6")
vim.api.nvim_command("highlight PreProc ctermfg=141 guifg=#BD93F9")
vim.api.nvim_command("highlight Number ctermfg=215 guifg=#FFB86C")
vim.api.nvim_command("highlight Special ctermfg=141 guifg=#BD93F9")
vim.api.nvim_command("highlight Type ctermfg=84 guifg=#50FA7B")

-- 특수 텍스트 요소들도 약간 더 어둡게 조정
vim.api.nvim_command("highlight NonText guifg=#CCCCCC")
vim.api.nvim_command("highlight SpecialKey guifg=#CCCCCC")
vim.api.nvim_command("highlight Whitespace guifg=#444444") -- 탭, 공백 등 표시
vim.api.nvim_command("highlight LineNr guifg=#6272A4") -- 라인 번호 (더 연한 보라색)
vim.api.nvim_command("highlight SignColumn guibg=NONE") -- 사인 컬럼 배경 투명

-- Indent-Blankline 하이라이팅
vim.api.nvim_command("highlight IblIndent guifg=#2A2D37")  -- 매우 연한 회색
vim.api.nvim_command("highlight IblScope guifg=#6272A4")  -- 현재 스코프는 보라색으로 강조

-- minimap 관련 색상 설정 (Dracula 테마와 어울리게)
vim.api.nvim_command("highlight MinimapCursor ctermfg=228 ctermbg=59 guifg=#F8F8F2 guibg=#6272A4")
vim.api.nvim_command("highlight MinimapRange ctermfg=228 ctermbg=59 guifg=#F8F8F2 guibg=#44475A")

-- nvim-tree 색상 설정을 autocmd로 나중에 적용
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- nvim-tree 색상 설정 (패널 배경을 약간 밝게)
    vim.cmd("highlight NvimTreeNormal guibg=#2A2D37")  -- 트리 패널 배경색 (약간 밝은 회색)
    vim.cmd("highlight NvimTreeNormalNC guibg=#2A2D37")  -- 비활성 상태 트리 패널
    vim.cmd("highlight NvimTreeWinSeparator guifg=#44475A guibg=#2A2D37")  -- 트리 패널 구분선
    vim.cmd("highlight NvimTreeEndOfBuffer guibg=#2A2D37")  -- 버퍼 끝 부분
    vim.cmd("highlight NvimTreeCursorLine guibg=#383C4A")  -- 커서 라인 (더 밝게)
    vim.cmd("highlight NvimTreeFolderIcon guifg=#8BE9FD")  -- 폴더 아이콘 색상
    vim.cmd("highlight NvimTreeFolderName guifg=#8BE9FD")  -- 폴더 이름 색상
    vim.cmd("highlight NvimTreeOpenedFolderName guifg=#50FA7B")  -- 열린 폴더 색상
    vim.cmd("highlight NvimTreeEmptyFolderName guifg=#6272A4")  -- 빈 폴더 색상
    vim.cmd("highlight NvimTreeRootFolder guifg=#F1FA8C gui=bold")  -- 루트 폴더 (노란색, 굵게)
    vim.cmd("highlight NvimTreeGitDirty guifg=#FFB86C")  -- Git 변경된 파일
    vim.cmd("highlight NvimTreeGitNew guifg=#50FA7B")  -- Git 새 파일
    vim.cmd("highlight NvimTreeGitDeleted guifg=#FF5555")  -- Git 삭제된 파일
  end,
  desc = "Apply nvim-tree colors after colorscheme"
})

-- nvim-tree 초기화
require("nvim-tree").setup({
  view = {
    width = 45,  -- 패널 너비 설정 (40에서 35로 조정)
    side = "left",  -- 패널 위치 ("left", "right", "top", "bottom" 중 선택)
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    float = {
      enable = false,  -- 플로팅 모드 비활성화 (고정 패널)
    },
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        git = true,
      },
    },
  },
  -- Dracula 테마에 맞는 색상 설정
  git = {
    ignore = false,
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },
  -- 작업 디렉토리 관련 설정
  update_cwd = false,  -- nvim-tree가 작업 디렉토리를 변경하지 못하도록 설정
  respect_buf_cwd = false,  -- 버퍼의 작업 디렉토리를 따르지 않음
  hijack_directories = {
    enable = false,  -- 디렉토리 탐색을 가로채지 않음
    auto_open = false,
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {},
  },
  actions = {
    change_dir = {
      enable = false,  -- 디렉토리 변경 비활성화
      global = false,
      restrict_above_cwd = true,  -- 현재 작업 디렉토리 상위로 이동 제한
    },
  },
  -- 새로운 API를 사용한 자동 열기 설정
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    
    -- 기본 매핑을 먼저 적용
    api.config.mappings.default_on_attach(bufnr)
    
    -- Git diff 관련 커스텀 키맵 추가
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    
    -- h/l 키로 폴더 접기/펼치기
    vim.keymap.set('n', 'l', function()
      local node = api.tree.get_node_under_cursor()
      if node then
        if node.type == "directory" then
          api.node.open.edit()
        else
          api.node.open.edit()
        end
      end
    end, opts('Open'))
    
    vim.keymap.set('n', 'h', function()
      local node = api.tree.get_node_under_cursor()
      if node then
        if node.type == "directory" and node.open then
          api.node.open.edit()
        else
          api.node.navigate.parent_close()
        end
      end
    end, opts('Close'))
    
    -- 프로젝트 루트로 돌아가기 (작업 디렉토리 상위로는 이동 제한)
    vim.keymap.set('n', 'H', function()
      local cwd = vim.fn.getcwd()
      local tree_root = api.tree.get_nodes().absolute_path
      -- 현재 트리 루트가 작업 디렉토리와 같거나 하위인 경우에만 상위로 이동
      if tree_root and tree_root ~= cwd and vim.fn.stridx(tree_root, cwd) == 0 then
        api.tree.change_root_to_parent()
      else
        vim.notify("Cannot go above working directory", vim.log.levels.WARN)
      end
    end, opts('Up to parent directory'))
    vim.keymap.set('n', '.', api.tree.change_root_to_node, opts('Change root to current node'))
    vim.keymap.set('n', '~', function()
      -- 현재 작업 디렉터리로 변경하고 트리 새로고침
      local cwd = vim.fn.getcwd()
      api.tree.change_root(cwd)
      api.tree.reload()
    end, opts('Change to current working directory'))
    
    -- 추가: 프로젝트 루트로 포커스 이동 (루트 변경 없이)
    vim.keymap.set('n', 'P', function()
      -- 트리의 최상위로 이동
      api.tree.focus()
      vim.cmd('normal! gg')
    end, opts('Go to tree root'))
    
    -- Git diff 보기 (수직 분할)
    vim.keymap.set('n', 'gd', function()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
        vim.cmd("wincmd l") -- 오른쪽 창으로 이동 (없으면 새로 생성)
        vim.cmd("e " .. node.absolute_path)
        vim.cmd("Gvdiffsplit")
      end
    end, opts('Git Diff (수직 분할)'))
    
    -- Git diff 보기 (플로팅 창)
    vim.keymap.set('n', 'gD', function()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
        vim.cmd("DiffviewOpen -- " .. node.absolute_path)
      end
    end, opts('Git Diff (Diffview)'))
    
    -- Git 상태 미리보기
    vim.keymap.set('n', 'gs', function()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
        vim.cmd("wincmd l")
        vim.cmd("e " .. node.absolute_path)
        vim.cmd("Gitsigns preview_hunk")
      end
    end, opts('Git 변경 사항 미리보기'))
    
    -- Git blame 보기
    vim.keymap.set('n', 'gb', function()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
        vim.cmd("wincmd l")
        vim.cmd("e " .. node.absolute_path)
        vim.cmd("Gitsigns toggle_current_line_blame")
      end
    end, opts('Git Blame 토글'))
  end,
  -- Git 상태 표시를 위한 하이라이트 그룹
  renderer = {
    highlight_git = true,
    icons = {
      glyphs = {
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
})

-- nvim 시작 시 처리 (대시보드가 처리하므로 주석 처리)
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     -- 인자 없이 nvim을 실행한 경우
--     if vim.fn.argc() == 0 then
--       -- 빈 버퍼를 스크래치 버퍼로 설정 (저장 요구 안함)
--       vim.bo.buftype = 'nofile'
--       vim.bo.bufhidden = 'hide'
--       vim.bo.swapfile = false
--     end
--   end,
-- })

-- 상태바 초기화 (Dracula Colorful 스타일)
require("lualine").setup({
  options = {
    theme = 'auto',  -- 커스텀 테마에 맞춰 자동 조정
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      {'branch', icon = '', color = {fg = '#50FA7B'}},
      {'diff',
        symbols = {added = ' ', modified = ' ', removed = ' '},
        diff_color = {
          added = {fg = '#50FA7B'},
          modified = {fg = '#FFB86C'},
          removed = {fg = '#FF5555'}
        }
      }
    },
    lualine_c = {
      {'filename', path = 1, color = {fg = '#8BE9FD'}},
      {'diagnostics',
        sources = {'nvim_lsp'},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
        diagnostics_color = {
          error = {fg = '#FF5555'},
          warn = {fg = '#FFB86C'},
          info = {fg = '#8BE9FD'},
          hint = {fg = '#BD93F9'}
        }
      }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})

-- Telescope 확장 기능 설정
local telescopeActions = require("telescope.actions")
local telescopeLayout = require("telescope.actions.layout")

require("telescope").setup({
  defaults = {
    -- Dracula Colorful 색상과 어울리는 설정
    prompt_prefix = " ",
    selection_caret = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55, -- 미리보기 창 너비 (전체 너비의 55%)
        results_width = 0.45, -- 결과 창 너비 (전체 너비의 45%)
        width = { padding = 0.02 }, -- 전체 창 패딩 축소
        height = { padding = 0.10 }, -- 전체 창 높이 패딩
        preview_cutoff = 120, -- 이 값보다 화면이 좁으면 미리보기 창 숨김
      },
      vertical = {
        mirror = false,
        preview_height = 0.6, -- 수직 레이아웃에서 미리보기 높이
      },
      width = 0.9, -- 전체 너비 (화면의 90%)
      height = 0.85, -- 전체 높이 (화면의 85%)
      preview_cutoff = 120, -- 미리보기 표시를 위한 최소 너비
    },
    -- Dracula 테마 색상
    color_devicons = true,
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    set_env = { ["COLORTERM"] = "truecolor" },
    -- 단축키 설정
    mappings = {
      i = {
        -- 레이아웃 변경 단축키
        ["<C-l>"] = function() require("telescope.actions.layout").cycle_layout_next() end,
        -- 미리보기 창 토글
        ["<C-p>"] = function() require("telescope.actions.layout").toggle_preview() end,
        -- 창 크기 조절
        ["<C-minus>"] = function() require("telescope.actions.layout").cycle_layout_prev() end,
        ["<C-=>"] = function() require("telescope.actions.layout").cycle_layout_next() end,
        -- 미리보기 창 스크롤
        ["<C-d>"] = telescopeActions.preview_scrolling_down,
        ["<C-u>"] = telescopeActions.preview_scrolling_up,
      },
      n = { -- 노멀 모드에서도 동일한 키매핑 제공
        ["<C-l>"] = function() require("telescope.actions.layout").cycle_layout_next() end,
        ["<C-p>"] = function() require("telescope.actions.layout").toggle_preview() end,
        ["<C-minus>"] = function() require("telescope.actions.layout").cycle_layout_prev() end,
        ["<C-=>"] = function() require("telescope.actions.layout").cycle_layout_next() end,
        ["<C-d>"] = telescopeActions.preview_scrolling_down,
        ["<C-u>"] = telescopeActions.preview_scrolling_up,
      },
    },
  },
  pickers = {
    find_files = {
      previewer = false, -- 파일 검색 시 미리보기 비활성화
      -- 파일 검색 성능 개선
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
      -- 경로 포함 검색 활성화
      path_display = { "smart" },
      -- fuzzy 검색 개선
      file_sorter = require("telescope.sorters").get_fzy_sorter,
      -- 대소문자 구분 없이 검색
      file_ignore_patterns = { "node_modules", ".git/", "%.jpg", "%.png", "%.jpeg", "%.pdf" },
    },
    live_grep = {
      previewer = false, -- 텍스트 검색 시 미리보기 비활성화
      -- ripgrep 추가 옵션
      additional_args = function()
        return { "--hidden", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
      end,
      -- 검색 결과 제한 (성능 향상)
      max_results = 1000,
    },
    buffers = {
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.5, -- 버퍼 목록에서는 균등하게
      },
      sort_mru = true, -- 최근 사용한 버퍼 우선 정렬
      sort_lastused = true,
    },
    -- 레이아웃 전환 기능 설정
    layout_switcher = {
      layouts = {
        "horizontal",
        "vertical", 
        "flex", 
        "cursor",
      },
    },
  },
  -- Colorful 스타일의 하이라이팅 추가
  highlights = {
    TelescopePromptBorder = { fg = "#BD93F9" },
    TelescopeResultsBorder = { fg = "#FF79C6" },
    TelescopePreviewBorder = { fg = "#8BE9FD" },
    TelescopeSelection = { bg = "#44475A", fg = "#E6E6E6" },
    TelescopeSelectionCaret = { fg = "#FF79C6" },
    TelescopeMultiSelection = { fg = "#50FA7B" },
    TelescopeNormal = { bg = "NONE" },
    TelescopeMatching = { fg = "#FFB86C" },
  },
})
require("telescope").load_extension("file_browser")

-- Telescope file browser 단축키 설정
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { desc = "파일 브라우저 열기", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fp", ":Telescope file_browser path=%:p:h<CR>", { desc = "현재 파일 위치에서 브라우저 열기", noremap = true, silent = true })

-- 추가 투명 배경 설정 (더 많은 요소들에 적용)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- 메인 배경 투명화
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
    
    -- 사이드바 및 기타 UI 요소 투명화
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
    
    -- NvimTree 투명화
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "NONE", ctermbg = "NONE" })
    
    -- Telescope 투명화
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
    
    -- Satellite 미니맵 투명화
    vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteBackground", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteCursor", { fg = "#FF79C6", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteDiagnosticError", { fg = "#FF5555", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteDiagnosticWarn", { fg = "#FFB86C", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteDiagnosticInfo", { fg = "#8BE9FD", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteDiagnosticHint", { fg = "#BD93F9", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteGitSignsAdd", { fg = "#50FA7B", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteGitSignsChange", { fg = "#FFB86C", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteGitSignsDelete", { fg = "#FF5555", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteSearch", { fg = "#F1FA8C", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SatelliteMark", { fg = "#BD93F9", bg = "NONE" })
    
    -- Mini.map 투명화 (사용 시)
    vim.api.nvim_set_hl(0, "MiniMapNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniMapSymbolCount", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniMapSymbolLine", { fg = "#BD93F9", bg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniMapSymbolView", { fg = "#8BE9FD", bg = "NONE" })
  end
})

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
    "jsonls",        -- JSON
    -- "dartls"는 Mason으로 설치 불가 (Dart/Flutter SDK에 포함되어 있음)
  },
  automatic_installation = true,
  -- 자동 서버 설정 비활성화 (수동으로 설정)
  handlers = nil,
})

-- LSP 설정
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 전역 on_attach 함수 (모든 LSP 서버에 적용)
local on_attach = function(client, bufnr)
  -- 버퍼별 활성 클라이언트 확인
  local active_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  
  -- 같은 이름의 클라이언트가 이미 있는지 확인
  local client_names = {}
  for _, c in ipairs(active_clients) do
    if client_names[c.name] and c.id ~= client.id then
      -- 중복 클라이언트 발견 - 새로운 것을 중지
      vim.notify("Duplicate LSP client detected: " .. client.name .. ", stopping...", vim.log.levels.WARN)
      vim.schedule(function()
        client.stop()
      end)
      return
    end
    client_names[c.name] = true
  end
  
  -- TypeScript 특별 처리
  if client.name == "ts_ls" or client.name == "tsserver" then
    -- 포맷팅은 prettier 등 별도 도구 사용
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

-- 중복 진단 필터링 함수
local function filter_duplicate_diagnostics()
  local function dedupe_diagnostics(diagnostics)
    local seen = {}
    local result = {}
    
    for _, diagnostic in ipairs(diagnostics) do
      -- 진단 메시지와 위치를 기준으로 중복 확인
      local key = string.format("%s:%d:%d:%s", 
        diagnostic.source or "unknown",
        diagnostic.lnum or 0,
        diagnostic.col or 0,
        diagnostic.message or ""
      )
      
      if not seen[key] then
        seen[key] = true
        table.insert(result, diagnostic)
      end
    end
    
    return result
  end
  
  -- 진단 핸들러 오버라이드
  local orig_handler = vim.diagnostic.handlers["virtual_text"]
  vim.diagnostic.handlers["virtual_text"] = {
    show = function(namespace, bufnr, diagnostics, opts)
      local filtered = dedupe_diagnostics(diagnostics)
      if orig_handler and orig_handler.show then
        orig_handler.show(namespace, bufnr, filtered, opts)
      end
    end,
    hide = orig_handler and orig_handler.hide,
  }
end

-- 중복 진단 필터 적용
filter_duplicate_diagnostics()

-- 진단 설정
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",  -- 여러 소스가 있을 때만 소스 표시
    prefix = "●",
  },
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- LSP 서버 설정
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
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
  on_attach = on_attach,
})

-- TypeScript/JavaScript 설정 (tsserver -> ts_ls로 서버 이름 변경)
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  single_file_support = false,  -- 단일 파일 지원 비활성화로 중복 방지
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  -- 한 프로젝트에 하나의 서버만 실행
  autostart = true,
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
      -- 중복 진단 방지
      format = {
        enable = false,  -- 포맷터는 별도로 사용
      },
      validate = {
        enable = true,
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
      -- 중복 진단 방지
      format = {
        enable = false,
      },
      validate = {
        enable = true,
      },
    },
    -- 중복 진단 필터링
    completions = {
      completeFunctionCalls = true,
    },
    diagnostics = {
      ignoredCodes = {},  -- 중복되는 진단 코드가 있으면 여기에 추가
    },
  },
})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.clangd.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.marksman.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.jsonls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Dart/Flutter 설정
-- 주의: dartls는 Mason으로 설치할 수 없음 (Dart/Flutter SDK에 포함됨)
-- Dart SDK가 시스템에 설치되어 있어야 함 (brew install dart 또는 Flutter SDK 설치)
lspconfig.dartls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "dart", "language-server", "--protocol=lsp" },  -- Dart SDK의 language-server 사용
  filetypes = { "dart" },
  root_dir = lspconfig.util.root_pattern("pubspec.yaml", ".git"),
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = false,
    outline = true,
    suggestFromUnimportedLibraries = true,
  },
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
      enableSnippets = true,
      enableSdkFormatter = true,
      lineLength = 80,
      devToolsPort = 9100,
      devToolsReuseWindows = true,
      analysisExcludedFolders = {
        vim.fn.expand("$HOME/.pub-cache"),
        vim.fn.expand("$HOME/fvm"),
      },
    },
  },
})

-- nvim-cmp 설정 (자동 완성)
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Copilot과 nvim-cmp 통합을 위한 이벤트 설정
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

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
vim.keymap.set("n", "gd", function()
  require('telescope.builtin').lsp_definitions({
    jump_type = "vsplit",
    reuse_win = true,
  })
end, { desc = "Go to definition with Telescope" })
vim.keymap.set("n", "gr", function()
  require('telescope.builtin').lsp_references({
    include_declaration = false,
    show_line = true,
  })
end, { desc = "Show references in Telescope" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Code Action 중복 제거 함수
local function dedupe_code_actions(actions)
  local seen = {}
  local result = {}
  
  for _, action in ipairs(actions) do
    local key = action.title .. (action.kind or "")
    if not seen[key] then
      seen[key] = true
      table.insert(result, action)
    end
  end
  
  return result
end

-- Code Action 설정 (개선된 UI 사용)
vim.keymap.set("n", "<leader>ca", function()
  local ok, actions_preview = pcall(require, "actions-preview")
  if ok then
    actions_preview.code_actions()
  else
    vim.lsp.buf.code_action({
      filter = function(action)
        return action
      end,
      apply = false,
    })
  end
end, { desc = "Code action (미리보기)" })

vim.keymap.set({"n", "v"}, "<leader>a", function()
  -- actions-preview가 로드되지 않았으면 기본 code action 사용
  local ok, actions_preview = pcall(require, "actions-preview")
  if ok then
    actions_preview.code_actions()
  else
    vim.lsp.buf.code_action({
      filter = function(action)
        return action
      end,
      apply = false,
    })
  end
end, { desc = "빠른 액션 (Quick Fix)" })
vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
  print("Formatting code with LSP")
end, { desc = "Format code" })
vim.keymap.set("n", "<leader>ed", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- IntelliJ 스타일 진단 네비게이션
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.HINT },
    float = { border = "rounded", source = "always" },
  })
end, { desc = "다음 에러/경고로 이동" })

vim.keymap.set("n", "<leader>E", function()
  vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.HINT },
    float = { border = "rounded", source = "always" },
  })
end, { desc = "이전 에러/경고로 이동" })

-- 에러만 네비게이션 (Option)
vim.keymap.set("n", "<leader>en", function()
  vim.diagnostic.goto_next({
    severity = vim.diagnostic.severity.ERROR,
    float = { border = "rounded", source = "always" },
  })
end, { desc = "다음 에러로만 이동" })

vim.keymap.set("n", "<leader>ep", function()
  vim.diagnostic.goto_prev({
    severity = vim.diagnostic.severity.ERROR,
    float = { border = "rounded", source = "always" },
  })
end, { desc = "이전 에러로만 이동" })

-- 전체 진단 목록 보기
vim.keymap.set("n", "<leader>el", vim.diagnostic.setloclist, { desc = "진단 목록 열기" })
vim.keymap.set("n", "<leader>eq", vim.diagnostic.setqflist, { desc = "모든 진단 Quickfix 열기" })

-- Trouble.nvim 단축키 (v3 API)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list (Trouble)" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list (Trouble)" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP references (Trouble)" })

-- 추가 단축키 설정
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- 탐색기 토글
vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>", { noremap = true, silent = true }) -- 파일 검색 (Ctrl+P에서 Ctrl+F로 변경)
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "파일 검색 (기본)" }) -- ff를 기본 파일 검색으로
vim.keymap.set("n", "<leader>fa", ":Telescope find_files hidden=true no_ignore=true<CR>", { desc = "모든 파일 검색 (숨김/무시 파일 포함)" }) -- fa를 모든 파일 검색으로
vim.keymap.set("n", "<leader>fp", function()
  require('telescope.builtin').find_files({
    find_command = { 'fd', '--type', 'f', '--hidden', '--follow', '--exclude', '.git' },
    path_display = { "truncate" },
    file_sorter = require('telescope.sorters').get_fzy_sorter(),
  })
end, { desc = "파일 검색 (경로 포함)" }) -- fp는 경로 포함 검색으로 유지
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })

-- 추가 검색 단축키
vim.keymap.set("n", "<leader>fw", ":Telescope grep_string<CR>", { desc = "현재 단어 검색" })
vim.keymap.set("n", "<leader>fr", function()
  require('telescope.builtin').oldfiles({
    prompt_title = "최근 파일",
    cwd_only = false,  -- 모든 디렉토리의 파일 표시
    initial_mode = "normal",  -- 노멀 모드로 시작 (j/k로 이동 가능)
    layout_config = {
      preview_width = 0.6,
    },
  })
end, { desc = "최근 파일 열기" })
vim.keymap.set("n", "<leader>fs", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "현재 버퍼에서 검색" })
vim.keymap.set("n", "<leader>fc", ":Telescope commands<CR>", { desc = "명령어 검색" })
vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "키맵 검색" })
vim.keymap.set("n", "<leader>fm", ":Telescope marks<CR>", { desc = "마크 검색" })
vim.keymap.set("n", "<leader>fj", ":Telescope jumplist<CR>", { desc = "점프 리스트" })

-- Comment.nvim 초기화
require("Comment").setup({
  mappings = {
    basic = true,  -- 기본 매핑 활성화
    extra = true,  -- 추가 매핑 활성화
  },
})

-- Diffview 설정 (Git diff 뷰어)
require("diffview").setup({
  diff_binaries = false,
  enhanced_diff_hl = false,
  git_cmd = { "git" },
  use_icons = true,
  icons = {
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    default = {
      layout = "diff2_horizontal",
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
    },
    file_history = {
      layout = "diff2_horizontal",
    },
  },
  file_panel = {
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
    win_config = {
      position = "left",
      width = 35,
    },
  },
  file_history_panel = {
    log_options = {
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
    },
    win_config = {
      position = "bottom",
      height = 16,
    },
  },
  keymaps = {
    disable_defaults = false,
    view = {
      ["<tab>"]      = false,
      ["<s-tab>"]    = false,
      ["gf"]         = false,
      ["<C-w><C-f>"] = false,
      ["<C-w>gf"]    = false,
      ["<leader>e"]  = false,
      ["<leader>b"]  = false,
      ["<leader>co"] = false,
      ["<leader>ct"] = false,
      ["<leader>cb"] = false,
      ["<leader>ca"] = false,
      ["<leader>dO"] = false,
      ["<leader>da"] = false,
      ["<leader>dw"] = false,
      ["<leader>du"] = false,
    },
    diff1 = {
      ["g?"] = false,
    },
    diff2 = {
      ["g?"] = false,
    },
    diff3 = {
      ["g?"] = false,
    },
    diff4 = {
      ["g?"] = false,
    },
    file_panel = {
      ["j"]          = false,
      ["<down>"]     = false,
      ["k"]          = false,
      ["<up>"]       = false,
      ["<cr>"]       = false,
      ["o"]          = false,
      ["<2-LeftMouse>"] = false,
      ["-"]          = false,
      ["s"]          = false,
      ["S"]          = false,
      ["U"]          = false,
      ["R"]          = false,
      ["<tab>"]      = false,
      ["<s-tab>"]    = false,
      ["gf"]         = false,
      ["<C-w><C-f>"] = false,
      ["<C-w>gf"]    = false,
      ["i"]          = false,
      ["f"]          = false,
      ["<c-u>"]      = false,
      ["<c-d>"]      = false,
      ["<leader>e"]  = false,
      ["<leader>b"]  = false,
      ["<leader>co"] = false,
      ["<leader>ct"] = false,
      ["<leader>cb"] = false,
      ["<leader>ca"] = false,
      ["<leader>dO"] = false,
      ["<leader>da"] = false,
      ["<leader>du"] = false,
      ["g?"]         = false,
    },
    file_history_panel = {
      ["g!"]         = false,
      ["<C-A-d>"]    = false,
      ["<C-c>q"]     = false,
      ["<C-c><C-q>"] = false,
      ["<C-c>w"]     = false,
      ["<C-c><C-w>"] = false,
      ["y"]          = false,
      ["Y"]          = false,
      ["O"]          = false,
      ["<tab>"]      = false,
      ["<s-tab>"]    = false,
      ["gf"]         = false,
      ["<C-w><C-f>"] = false,
      ["<C-w>gf"]    = false,
      ["<leader>e"]  = false,
      ["<leader>b"]  = false,
      ["<leader>co"] = false,
      ["<leader>ct"] = false,
      ["<leader>cb"] = false,
      ["<leader>ca"] = false,
      ["<leader>dO"] = false,
      ["<leader>da"] = false,
      ["g?"]         = false,
    },
    option_panel = {
      ["<tab>"] = false,
      ["q"]     = false,
      ["o"]     = false,
      ["<cr>"]  = false,
      ["?"]     = false,
    },
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
require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    priority = 500, -- 높은 우선순위로 스코프 선이 잘 보이도록
  },
  exclude = {
    filetypes = { "help", "dashboard", "NvimTree", "Trouble", "lazy", "mason", "alpha" },
    buftypes = { "terminal", "nofile", "quickfix", "prompt" },
  },
})

-- ibl 하이라이트 그룹 설정 (플러그인 설정 후)
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4048", nocombine = true })
vim.api.nvim_set_hl(0, "IblScope", { fg = "#BD93F9", nocombine = true })

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

-- Diffview 단축키 설정
vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Diffview 열기" })
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Diffview 닫기" })
vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory %<CR>", { desc = "현재 파일 히스토리" })
vim.keymap.set("n", "<leader>dH", ":DiffviewFileHistory<CR>", { desc = "전체 히스토리" })
vim.keymap.set("n", "<leader>dt", ":DiffviewToggleFiles<CR>", { desc = "파일 패널 토글" })

-- 파일 유형별 자동 포맷팅 설정
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = false })
      print("JSON 포맷팅 완료")
    end, { buffer = true, desc = "JSON 포맷팅" })
  end,
})

-- 터미널 크기 조절 단축키
vim.keymap.set("n", "<leader>t+", ":lua require('toggleterm').resize(5)<CR>", { noremap = true, silent = true }) -- 터미널 크기 증가
vim.keymap.set("n", "<leader>t-", ":lua require('toggleterm').resize(-5)<CR>", { noremap = true, silent = true }) -- 터미널 크기 감소

-- Yazi 파일 탐색기 단축키
vim.keymap.set("n", "<leader>fe", ":ToggleTerm direction=float cmd=yazi<CR>", { desc = "Yazi 파일 탐색기 열기", noremap = true, silent = true })
-- 미니맵 토글 단축키 (minimap.vim 비활성화)
-- vim.keymap.set("n", "<leader>mm", ":MinimapToggle<CR>", { desc = "미니맵 토글", noremap = true, silent = true })

-- Treesitter 설정
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "vim", "vimdoc", "query", -- Neovim 개발
    "python", "javascript", "typescript", "tsx", -- 웹/앱 개발
    "html", "css", "json", "yaml", "toml", -- 마크업/데이터
    "rust", "c", "cpp", -- 시스템 프로그래밍
    "markdown", "markdown_inline", -- 추가 언어
    "dart" -- Dart/Flutter
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
vim.keymap.set("n", "<C-Left>", ":vertical resize -3<CR>", { desc = "창 너비 줄이기", silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +3<CR>", { desc = "창 너비 늘리기", silent = true })
vim.keymap.set("n", "<C-Up>", ":resize +3<CR>", { desc = "창 높이 늘리기", silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -3<CR>", { desc = "창 높이 줄이기", silent = true })

-- Leader 키를 사용한 대체 단축키 (tmux와 충돌 방지)
vim.keymap.set("n", "<leader>wh", ":vertical resize -5<CR>", { desc = "창 너비 줄이기", silent = true })
vim.keymap.set("n", "<leader>wl", ":vertical resize +5<CR>", { desc = "창 너비 늘리기", silent = true })
vim.keymap.set("n", "<leader>wk", ":resize +5<CR>", { desc = "창 높이 늘리기", silent = true })
vim.keymap.set("n", "<leader>wj", ":resize -5<CR>", { desc = "창 높이 줄이기", silent = true })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "모든 창 크기 동일하게", silent = true })

-- 버퍼 관리 단축키
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "이전 버퍼" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "다음 버퍼" })

-- LuaSnip 설정
require("luasnip.loaders.from_vscode").lazy_load()

-- 명령어는 플러그인 설정에서 정의됨

-- 자동 설정
vim.cmd [[
  augroup json_settings
    autocmd!
    autocmd FileType json setlocal tabstop=2 shiftwidth=2
    autocmd BufWritePre *.json lua vim.lsp.buf.format({ async = false })
  augroup END
]]

-- 설정 파일 리로드 단축키
vim.keymap.set("n", "<leader>sv", function()
  -- 가드 초기화 후 설정 리로드
  vim.g.init_lua_loaded = false
  vim.cmd("source $MYVIMRC")
  vim.notify("설정 리로드 완료", vim.log.levels.INFO)
end, { desc = "Neovim 설정 다시 로드" })

vim.keymap.set("n", "<leader>se", ":e $MYVIMRC<CR>", { desc = "Neovim 설정 파일 열기" })

-- Lazy 관련 단축키
vim.keymap.set("n", "<leader>ps", ":Lazy sync<CR>", { desc = "플러그인 동기화" })
vim.keymap.set("n", "<leader>pu", ":Lazy update<CR>", { desc = "플러그인 업데이트" })
vim.keymap.set("n", "<leader>pc", ":Lazy clean<CR>", { desc = "사용하지 않는 플러그인 제거" })
vim.keymap.set("n", "<leader>pp", ":Lazy<CR>", { desc = "플러그인 관리자 열기" })

-- LSP 디버깅 명령어
vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { desc = "LSP 정보 보기" })
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { desc = "LSP 재시작" })
vim.keymap.set("n", "<leader>ls", function()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    print("No active LSP clients")
    return
  end
  
  print("Active LSP clients:")
  for _, client in ipairs(clients) do
    print(string.format("  - %s (id: %d)", client.name, client.id))
  end
end, { desc = "활성 LSP 클라이언트 목록" })

-- 기타 유용한 단축키
-- 스마트 저장: 파일명이 없으면 입력받고, 있으면 그냥 저장
vim.keymap.set("n", "<leader>w", function()
  if vim.fn.expand('%') == '' then
    -- 파일명이 없으면 입력 받기
    vim.ui.input({ prompt = 'Save as: ' }, function(filename)
      if filename and filename ~= '' then
        vim.cmd('write ' .. filename)
      end
    end)
  else
    -- 파일명이 있으면 그냥 저장
    vim.cmd('write')
  end
end, { desc = "저장 (파일명 없으면 입력)", noremap = true, silent = true })

-- 스마트 종료: 빈 버퍼이고 수정사항이 없으면 바로 종료
vim.keymap.set("n", "<leader>q", function()
  local success, result = pcall(function()
    local buf_name = vim.fn.expand('%')
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local is_empty = #buf_lines == 1 and buf_lines[1] == ""
    
    -- 파일명이 없고, 내용이 비어있으면 강제 종료
    if buf_name == '' and is_empty then
      return 'q!'
    else
      return 'q'
    end
  end)
  
  if success then
    vim.cmd(result)
  else
    -- 에러 발생 시 일반 종료 시도
    vim.cmd('q')
  end
end, { desc = "스마트 종료", noremap = true, silent = true })

vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "강제 종료", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "버퍼 닫기", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bD", ":bd!<CR>", { desc = "버퍼 강제 닫기", noremap = true, silent = true })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "검색 강조 제거", noremap = true, silent = true })
-- 검색 후 ESC ESC로 하이라이팅 제거 (두 번 눌러야 함으로 안전)
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { desc = "검색 하이라이팅 제거", noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", ":checktime<CR>", { desc = "외부 변경 사항 확인", noremap = true, silent = true })
-- ESC 키 매핑 제거 (기본 동작 유지)
-- vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "검색 하이라이팅 제거", noremap = true, silent = true })

-- 더 안정적인 방법: 자동 명령어로 ESC 키 누를 때 자동으로 하이라이팅 제거
vim.cmd([[
  augroup clear_search_highlight
    autocmd!
    autocmd InsertEnter * :nohlsearch
  augroup END
]])

-- 파일 변경 감지 및 자동 로드 설정
local auto_read_group = vim.api.nvim_create_augroup("AutoReadFileChanges", { clear = true })

-- 포커스를 얻거나 버퍼로 이동할 때 변경 사항 확인
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = auto_read_group,
  callback = function()
    if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
  desc = "외부 파일 변경 사항 확인"
})

-- 파일이 외부에서 변경된 경우 알림
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = auto_read_group,
  callback = function()
    vim.api.nvim_echo({
      { "파일이 외부에서 변경되었습니다. 내용이 다시 로드되었습니다.", "WarningMsg" }
    }, true, {})
  end,
  desc = "외부 파일 변경 알림"
})
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

-- GitHub Copilot 설정 (copilot.lua로 마이그레이션됨)
-- 키맵은 이제 플러그인 설정에서 직접 관리됩니다.
-- 추가 커스터마이징이 필요한 경우 아래 함수들을 사용할 수 있습니다:
-- require("copilot.suggestion").accept()
-- require("copilot.suggestion").next()
-- require("copilot.suggestion").prev()
-- require("copilot.suggestion").dismiss()
-- require("copilot.suggestion").toggle_auto_trigger()

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

-- rainbow-delimiters 설정
local rainbow_delimiters = require('rainbow-delimiters')

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
    blacklist = {'html'},
}

-- 괄호를 얇게 표시하기 위한 하이라이팅 설정
vim.cmd([[
  hi RainbowDelimiterRed guifg=#FF5555 gui=NONE
  hi RainbowDelimiterYellow guifg=#F1FA8C gui=NONE
  hi RainbowDelimiterBlue guifg=#BD93F9 gui=NONE
  hi RainbowDelimiterOrange guifg=#FFB86C gui=NONE
  hi RainbowDelimiterGreen guifg=#50FA7B gui=NONE
  hi RainbowDelimiterViolet guifg=#FF79C6 gui=NONE
  hi RainbowDelimiterCyan guifg=#8BE9FD gui=NONE
]])

-- which-key 설정
require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = false,
      suggestions = 20,
    },
    presets = {
      operators = false,  -- 비활성화로 지연 감소
      motions = false,    -- 비활성화로 지연 감소
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  delay = 0,  -- which-key 표시 지연 제거
  icons = {
    breadcrumb = "»", -- 경로 구분자 아이콘
    separator = "➜", -- 그룹 구분자 아이콘
    group = "+", -- 그룹 아이콘
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    border = "rounded", -- rounded/single/double/shadow
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0, -- 투명도 (0-100)
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "center",
  },
  ignore_missing = false,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  show_help = true,
  show_keys = true,
  triggers = "auto",
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
})

-- quit 명령어 개선 (빈 버퍼 자동 처리)
vim.api.nvim_create_user_command('Q', function()
  local buf_name = vim.fn.expand('%')
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local is_empty = #buf_lines == 1 and buf_lines[1] == ""
  
  if buf_name == '' and is_empty then
    vim.cmd('q!')
  else
    vim.cmd('q')
  end
end, { desc = "스마트 종료" })

-- Alpha 대시보드 유니콘 색상
vim.cmd([[
  hi AlphaUnicorn guifg=#FF79C6 gui=bold
  hi AlphaCompany guifg=#8BE9FD gui=bold
  hi AlphaMagic guifg=#F1FA8C gui=italic
]])

-- 테마 로드 후 즉시 투명 배경 적용
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalFloat guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi Folded guibg=NONE ctermbg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi StatusLineNC guibg=NONE ctermbg=NONE
  hi NvimTreeNormal guibg=NONE ctermbg=NONE
  hi NvimTreeEndOfBuffer guibg=NONE ctermbg=NONE
  hi NvimTreeVertSplit guibg=NONE ctermbg=NONE
  hi NvimTreeWinSeparator guibg=NONE ctermbg=NONE
  hi TelescopeNormal guibg=NONE ctermbg=NONE
  hi TelescopeBorder guibg=NONE ctermbg=NONE
  
  " Satellite 미니맵 투명 배경
  hi SatelliteBar guibg=NONE ctermbg=NONE
  hi SatelliteBackground guibg=NONE ctermbg=NONE
  hi SatelliteCursor guifg=#FF79C6 guibg=NONE
  hi SatelliteDiagnosticError guifg=#FF5555 guibg=NONE
  hi SatelliteDiagnosticWarn guifg=#FFB86C guibg=NONE
  hi SatelliteDiagnosticInfo guifg=#8BE9FD guibg=NONE
  hi SatelliteDiagnosticHint guifg=#BD93F9 guibg=NONE
  hi SatelliteGitSignsAdd guifg=#50FA7B guibg=NONE
  hi SatelliteGitSignsChange guifg=#FFB86C guibg=NONE
  hi SatelliteGitSignsDelete guifg=#FF5555 guibg=NONE
  hi SatelliteSearch guifg=#F1FA8C guibg=NONE
  hi SatelliteMark guifg=#BD93F9 guibg=NONE
  
  " Mini.map 투명 배경 (사용 시)
  hi MiniMapNormal guibg=NONE ctermbg=NONE
  hi MiniMapSymbolCount guibg=NONE ctermbg=NONE
  hi MiniMapSymbolLine guifg=#BD93F9 guibg=NONE
  hi MiniMapSymbolView guifg=#8BE9FD guibg=NONE
]])
