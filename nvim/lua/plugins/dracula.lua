-- IntelliJ IDEA Bruce Style 테마 설정 (Dracula 기반)
return {
  -- Dracula 테마 플러그인 (더 나은 커스터마이징 지원)
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        -- IntelliJ Bruce Style의 색상 팔레트
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#98AFFF",      -- IntelliJ의 밝은 파랑 주석
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50FA7B",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",         -- 사이드바/패널 배경
          visual = "#666B87",       -- IntelliJ의 선택 영역 색상
          gutter_fg = "#A3A5BA",    -- IntelliJ의 줄 번호 색상
          nontext = "#3E404B",      -- 들여쓰기 가이드 색상
        },
        -- IntelliJ 스타일 설정
        italic_comment = true,
        transparent_bg = true,  -- 터미널 배경색 사용하도록 투명 설정
        show_end_of_buffer = false,
        
        -- IntelliJ Bruce Style 하이라이트 오버라이드
        overrides = function(colors)
          return {
            -- 함수 (밝은 초록)
            ["@function"] = { fg = colors.green },
            ["@function.call"] = { fg = colors.green },
            ["@method"] = { fg = colors.green },
            ["@method.call"] = { fg = colors.green },
            Function = { fg = colors.green },
            
            -- 변수와 파라미터 (IntelliJ 스타일)
            ["@variable"] = { fg = "#B9BCD1" },  -- IntelliJ의 일반 변수 색상
            ["@variable.parameter"] = { fg = "#B9BCD1", italic = true },  -- 파라미터는 이탤릭
            ["@variable.builtin"] = { fg = colors.purple, italic = true },
            
            -- 속성/필드 (오렌지)
            ["@property"] = { fg = colors.orange },
            ["@field"] = { fg = colors.orange },
            
            -- 상수 (보라색 + 이탤릭)
            ["@constant"] = { fg = colors.purple, italic = true },
            ["@constant.builtin"] = { fg = colors.purple, bold = true },
            
            -- 키워드 (분홍)
            ["@keyword"] = { fg = colors.pink },
            ["@keyword.function"] = { fg = colors.pink },
            ["@keyword.return"] = { fg = colors.pink },
            Keyword = { fg = colors.pink },
            
            -- 타입과 클래스 (청록)
            ["@type"] = { fg = colors.cyan, italic = false },
            ["@type.builtin"] = { fg = colors.cyan, italic = true },
            Type = { fg = colors.cyan },
            
            -- 문자열 (노랑)
            ["@string"] = { fg = colors.yellow },
            String = { fg = colors.yellow },
            
            -- 숫자와 불린 (보라)
            ["@number"] = { fg = colors.purple },
            ["@boolean"] = { fg = colors.purple },
            Number = { fg = colors.purple },
            Boolean = { fg = colors.purple },
            
            -- 주석 (밝은 파랑 + 이탤릭)
            ["@comment"] = { fg = "#98AFFF", italic = true },
            Comment = { fg = "#8BE9FD", italic = false },  -- Telescope 파일 경로에도 사용되므로 더 밝게, 이탤릭 제거
            
            -- 연산자
            ["@operator"] = { fg = colors.pink },
            Operator = { fg = colors.pink },
            
            -- 에디터 배경 및 기본 요소 (투명 배경)
            Normal = { fg = "#F8F8F2", bg = "NONE" },  -- 배경 투명
            NormalFloat = { fg = "#F8F8F2", bg = "#3A3D4C" },  -- 팝업은 배경 유지
            FloatBorder = { fg = "#6272A4", bg = "#3A3D4C" },
            
            -- 줄 번호와 거터 (배경 투명)
            LineNr = { fg = "#A3A5BA", bg = "NONE" },
            CursorLineNr = { fg = "#FF79C6", bg = "NONE", bold = true },
            SignColumn = { bg = "NONE" },
            FoldColumn = { fg = "#6272A4", bg = "NONE" },
            
            -- 캐럿 라인
            CursorLine = { bg = "#44475A" },
            CursorColumn = { bg = "#44475A" },
            
            -- 선택 영역 (IntelliJ 색상)
            Visual = { bg = "#666B87" },
            VisualNOS = { bg = "#666B87" },
            
            -- 검색
            Search = { fg = "#282A36", bg = "#50FA7B" },
            IncSearch = { fg = "#282A36", bg = "#FFB86C" },
            
            -- 들여쓰기 가이드 (거의 안 보이게)
            IndentBlanklineChar = { fg = "#262830" },  -- 극도로 연한 회색 (배경과 거의 비슷)
            IndentBlanklineContextChar = { fg = "#303340" },  -- 활성 컨텍스트도 매우 연하게
            
            -- 경계선
            VertSplit = { fg = "#6B7090", bg = "NONE" },
            WinSeparator = { fg = "#6B7090", bg = "NONE" },
            
            -- 상태바
            StatusLine = { fg = "#F8F8F2", bg = "#21222C" },
            StatusLineNC = { fg = "#6272A4", bg = "#21222C" },
            
            -- 탭라인
            TabLine = { fg = "#6272A4", bg = "#21222C" },
            TabLineSel = { fg = "#F8F8F2", bg = "#44475A" },
            TabLineFill = { bg = "#21222C" },
            
            -- NvimTree 파일 탐색기
            NvimTreeNormal = { fg = "#F8F8F2", bg = "#21222C" },
            NvimTreeNormalNC = { fg = "#F8F8F2", bg = "#21222C" },
            NvimTreeRootFolder = { fg = "#BD93F9", bold = true },
            NvimTreeFolderName = { fg = "#8BE9FD" },
            NvimTreeFolderIcon = { fg = "#8BE9FD" },
            NvimTreeOpenedFolderName = { fg = "#50FA7B" },
            NvimTreeEmptyFolderName = { fg = "#6272A4" },
            NvimTreeIndentMarker = { fg = "#3E404B" },
            NvimTreeVertSplit = { fg = "#21222C", bg = "#21222C" },
            NvimTreeEndOfBuffer = { fg = "#21222C" },
            
            -- Neo-tree (LazyVim 기본 파일 탐색기)
            NeoTreeNormal = { bg = "#21222C" },
            NeoTreeNormalNC = { bg = "#21222C" },
            NeoTreeDirectoryName = { fg = "#8BE9FD" },
            NeoTreeDirectoryIcon = { fg = "#8BE9FD" },
            NeoTreeRootName = { fg = "#BD93F9", bold = true },
            
            -- Git 상태 색상
            GitSignsAdd = { fg = "#50FA7B", bg = "#3F4152" },
            GitSignsChange = { fg = "#8BE9FD", bg = "#3F4152" },
            GitSignsDelete = { fg = "#FF5555", bg = "#3F4152" },
            DiffAdd = { bg = "#344535" },
            DiffChange = { bg = "#344F54" },
            DiffDelete = { bg = "#4C273C" },
            DiffText = { bg = "#4C273C", bold = true },
            
            -- 진단 메시지
            DiagnosticError = { fg = "#FF5555" },
            DiagnosticWarn = { fg = "#FFB86C" },
            DiagnosticInfo = { fg = "#8BE9FD" },
            DiagnosticHint = { fg = "#50FA7B" },
            
            -- 매칭 괄호
            MatchParen = { fg = "#F8F8F2", bg = "#747A9D", bold = true },
            
            -- 팝업 메뉴
            Pmenu = { fg = "#F8F8F2", bg = "#3A3D4C" },
            PmenuSel = { fg = "#F8F8F2", bg = "#44475A" },
            PmenuSbar = { bg = "#3A3D4C" },
            PmenuThumb = { bg = "#BD93F9" },
            
            -- 폴딩
            Folded = { fg = "#6272A4", bg = "#242632" },
            FoldColumn = { fg = "#6272A4", bg = "#3F4152" },
            
            -- 디렉토리 및 특수 텍스트 (Telescope 파일 경로에 사용)
            Directory = { fg = "#8BE9FD", bold = false },  -- 디렉토리 색상 - 밝은 청록
            NonText = { fg = "#A3A5BA" },  -- 보이지 않는 문자 - 밝은 회색
            SpecialKey = { fg = "#A3A5BA" },  -- 특수 키
            Conceal = { fg = "#6272A4" },  -- 숨겨진 텍스트
            
            -- 경고/에러 강조
            ErrorMsg = { fg = "#FF5555", bold = true },
            WarningMsg = { fg = "#FFB86C", bold = true },
            
            -- TODO 주석
            Todo = { fg = "#E998FF", bold = true },
            
            -- Telescope 색상 설정
            TelescopeNormal = { fg = "#F8F8F2", bg = "#282A36" },
            TelescopeBorder = { fg = "#6272A4", bg = "#282A36" },
            TelescopePromptNormal = { fg = "#F8F8F2", bg = "#282A36" },
            TelescopePromptBorder = { fg = "#6272A4", bg = "#282A36" },
            TelescopePromptTitle = { fg = "#BD93F9", bold = true },
            TelescopePromptPrefix = { fg = "#50FA7B" },
            TelescopeResultsNormal = { fg = "#F8F8F2", bg = "#282A36" },
            TelescopeResultsBorder = { fg = "#6272A4", bg = "#282A36" },
            TelescopeResultsTitle = { fg = "#BD93F9", bold = true },
            TelescopePreviewNormal = { fg = "#F8F8F2", bg = "#282A36" },
            TelescopePreviewBorder = { fg = "#6272A4", bg = "#282A36" },
            TelescopePreviewTitle = { fg = "#BD93F9", bold = true },
            
            -- Telescope 선택 및 매칭
            TelescopeSelection = { fg = "#F8F8F2", bg = "#44475A" },
            TelescopeSelectionCaret = { fg = "#FF79C6", bg = "#44475A" },
            TelescopeMultiSelection = { fg = "#BD93F9", bg = "#44475A" },
            TelescopeMatching = { fg = "#50FA7B", bold = true },
            
            -- Telescope 파일 경로 디렉토리 부분 (중요!)
            -- 이 부분이 파일명 앞의 경로를 보여주는 색상입니다
            TelescopeResultsDiffAdd = { fg = "#50FA7B" },
            TelescopeResultsDiffChange = { fg = "#8BE9FD" },
            TelescopeResultsDiffDelete = { fg = "#FF5555" },
            TelescopeResultsComment = { fg = "#8BE9FD" },  -- 파일 경로 - 밝은 청록색으로 변경
            TelescopeResultsLineNr = { fg = "#A3A5BA" },
            TelescopeResultsConstant = { fg = "#BD93F9" },
            TelescopeResultsFunction = { fg = "#50FA7B" },
            TelescopeResultsOperator = { fg = "#FF79C6" },
            TelescopeResultsField = { fg = "#FFB86C" },
            TelescopeResultsVariable = { fg = "#F8F8F2" },
            TelescopeResultsMethod = { fg = "#50FA7B" },
            
            -- 파일 경로의 디렉토리 부분을 더 밝게 (핵심 수정)
            TelescopeResultsIdentifier = { fg = "#8BE9FD" },  -- 파일 경로
            TelescopeResultsNumber = { fg = "#BD93F9" },      -- 줄 번호
            TelescopeResultsSpecialComment = { fg = "#A3A5BA" }, -- 특수 주석
            TelescopePreviewLine = { bg = "#44475A" },
            TelescopePreviewMatch = { fg = "#50FA7B", bold = true },
          }
        end,
      })
      
      -- 테마 적용
      vim.cmd("colorscheme dracula")
    end,
  },
  
  -- LazyVim colorscheme 설정
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
