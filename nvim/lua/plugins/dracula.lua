-- IntelliJ IDEA Dracula Colorful 테마 설정
return {
  -- Dracula 테마 플러그인 (더 나은 커스터마이징 지원)
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        -- IntelliJ Dracula Colorful의 선명한 색상 팔레트
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
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
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
        },
        -- IntelliJ 스타일 설정
        italic_comment = true,
        transparent_bg = false,
        show_end_of_buffer = false,
        
        -- IntelliJ Dracula Colorful 하이라이트 오버라이드
        overrides = function(colors)
          return {
            -- 함수 (밝은 초록)
            ["@function"] = { fg = colors.green },
            ["@function.call"] = { fg = colors.green },
            ["@method"] = { fg = colors.green },
            ["@method.call"] = { fg = colors.green },
            Function = { fg = colors.green },
            
            -- 변수와 파라미터
            ["@variable"] = { fg = colors.fg },
            ["@variable.parameter"] = { fg = colors.orange },
            ["@variable.builtin"] = { fg = colors.purple, italic = true },
            
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
            
            -- 주석 (회색 + 이탤릭)
            ["@comment"] = { fg = colors.comment, italic = true },
            Comment = { fg = colors.comment, italic = true },
            
            -- 연산자
            ["@operator"] = { fg = colors.pink },
            Operator = { fg = colors.pink },
            
            -- UI 요소
            CursorLine = { bg = "#2F3142" },
            LineNr = { fg = colors.comment },
            Visual = { bg = colors.visual },
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
