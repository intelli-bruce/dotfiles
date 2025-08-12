-- Dracula Colorful Theme for Neovim
-- Based on IntelliJ IDEA's Dracula Colorful theme

local M = {}

-- Dracula Colorful 정확한 색상 값
local colors = {
  -- 배경 및 기본
  bg = "#282A36",           -- 배경
  fg = "#F8F8F2",           -- 전경 (기본 텍스트)
  selection = "#44475A",    -- 선택 영역
  comment = "#6272A4",      -- 주석
  current_line = "#44475A", -- 현재 줄
  
  -- Dracula Colorful 특징적인 밝은 색상들
  cyan = "#80FFEA",         -- 밝은 청록 (함수명, 메서드)
  green = "#8AFF80",        -- 밝은 초록 (문자열)
  orange = "#FFCA80",       -- 밝은 주황 (매개변수, 상수)
  pink = "#FF80BF",         -- 밝은 핑크 (키워드)
  purple = "#9580FF",       -- 밝은 보라 (타입, 클래스명)
  red = "#FF9580",          -- 밝은 빨강 (에러, 중요 키워드)
  yellow = "#FFFF80",       -- 밝은 노랑 (속성, 태그)
  
  -- 추가 색상
  bright_white = "#FFFFFF",
  bright_black = "#21222C",
  menu = "#21222C",
  visual = "#3E4452",
  gutter_fg = "#4B5263",
  nontext = "#3B4048",
  
  -- IntelliJ 특유의 색상
  method_declaration = "#80FFEA",  -- 메서드 선언
  field = "#F8F8F2",               -- 필드
  variable = "#F8F8F2",            -- 변수
  parameter = "#FFCA80",           -- 매개변수
  annotation = "#FFFF80",          -- 어노테이션
  interface = "#8AFF80",           -- 인터페이스
}

function M.setup()
  -- 테마 초기화
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  
  vim.o.termguicolors = true
  vim.g.colors_name = "dracula-colorful"
  
  -- 기본 하이라이트 그룹
  local highlights = {
    -- 에디터 색상
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.bg },
    Comment = { fg = colors.comment, italic = true },
    ColorColumn = { bg = colors.selection },
    Conceal = { fg = colors.comment },
    Cursor = { fg = colors.bg, bg = colors.fg },
    CursorColumn = { bg = colors.current_line },
    CursorLine = { bg = colors.current_line },
    Directory = { fg = colors.purple, bold = true },
    DiffAdd = { fg = colors.green, bg = colors.menu },
    DiffChange = { fg = colors.orange },
    DiffDelete = { fg = colors.red },
    DiffText = { fg = colors.comment },
    EndOfBuffer = { fg = colors.nontext },
    ErrorMsg = { fg = colors.red },
    VertSplit = { fg = colors.selection },
    Folded = { fg = colors.comment },
    FoldColumn = { fg = colors.comment },
    SignColumn = { fg = colors.fg, bg = colors.bg },
    IncSearch = { fg = colors.bg, bg = colors.orange },
    LineNr = { fg = colors.comment },
    CursorLineNr = { fg = colors.fg },
    MatchParen = { fg = colors.fg, bg = colors.selection, underline = true },
    ModeMsg = { fg = colors.fg },
    MoreMsg = { fg = colors.fg },
    NonText = { fg = colors.nontext },
    Pmenu = { fg = colors.fg, bg = colors.menu },
    PmenuSel = { fg = colors.fg, bg = colors.selection },
    PmenuSbar = { bg = colors.selection },
    PmenuThumb = { bg = colors.selection },
    Question = { fg = colors.purple },
    Search = { fg = colors.bg, bg = colors.yellow },
    SpecialKey = { fg = colors.nontext },
    StatusLine = { fg = colors.fg, bg = colors.current_line },
    StatusLineNC = { fg = colors.comment },
    TabLine = { fg = colors.comment },
    TabLineFill = { bg = colors.menu },
    TabLineSel = { fg = colors.fg },
    Title = { fg = colors.green, bold = true },
    Visual = { bg = colors.selection },
    VisualNOS = { bg = colors.selection },
    WarningMsg = { fg = colors.orange },
    WildMenu = { fg = colors.bg, bg = colors.purple },
    
    -- 구문 하이라이팅 (IntelliJ Dracula Colorful 스타일)
    Constant = { fg = colors.orange },
    String = { fg = colors.green },
    Character = { fg = colors.green },
    Number = { fg = colors.purple },
    Boolean = { fg = colors.purple },
    Float = { fg = colors.purple },
    
    Identifier = { fg = colors.fg },
    Function = { fg = colors.cyan, bold = true },  -- 밝은 청록색 함수
    
    Statement = { fg = colors.pink, bold = true },  -- 밝은 핑크 키워드
    Conditional = { fg = colors.pink },
    Repeat = { fg = colors.pink },
    Label = { fg = colors.pink },
    Operator = { fg = colors.fg },
    Keyword = { fg = colors.pink, bold = true },
    Exception = { fg = colors.pink },
    
    PreProc = { fg = colors.yellow },
    Include = { fg = colors.pink },
    Define = { fg = colors.pink },
    Macro = { fg = colors.yellow },
    PreCondit = { fg = colors.yellow },
    
    Type = { fg = colors.purple, bold = true },  -- 밝은 보라색 타입
    StorageClass = { fg = colors.pink },
    Structure = { fg = colors.purple },
    Typedef = { fg = colors.purple },
    
    Special = { fg = colors.yellow },
    SpecialChar = { fg = colors.yellow },
    Tag = { fg = colors.yellow },
    Delimiter = { fg = colors.fg },
    SpecialComment = { fg = colors.comment, italic = true },
    Debug = { fg = colors.red },
    
    Underlined = { fg = colors.cyan, underline = true },
    Ignore = { fg = colors.comment },
    Error = { fg = colors.red },
    Todo = { fg = colors.purple, bold = true },
    
    -- LSP 및 진단
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.orange },
    DiagnosticInfo = { fg = colors.cyan },
    DiagnosticHint = { fg = colors.cyan },
    
    -- Treesitter 하이라이트 (IntelliJ 스타일)
    ["@variable"] = { fg = colors.fg },
    ["@variable.parameter"] = { fg = colors.orange, italic = true },  -- 매개변수 주황색
    ["@variable.builtin"] = { fg = colors.purple },
    ["@variable.member"] = { fg = colors.fg },
    
    ["@constant"] = { fg = colors.orange },
    ["@constant.builtin"] = { fg = colors.purple },
    ["@constant.macro"] = { fg = colors.orange },
    
    ["@module"] = { fg = colors.fg },
    ["@label"] = { fg = colors.pink },
    
    ["@string"] = { fg = colors.green },
    ["@string.documentation"] = { fg = colors.green },
    ["@string.regex"] = { fg = colors.red },
    ["@string.escape"] = { fg = colors.yellow },
    ["@string.special.symbol"] = { fg = colors.cyan },
    
    ["@character"] = { fg = colors.green },
    ["@character.special"] = { fg = colors.yellow },
    
    ["@boolean"] = { fg = colors.purple },
    ["@number"] = { fg = colors.purple },
    ["@number.float"] = { fg = colors.purple },
    
    ["@type"] = { fg = colors.purple, bold = true },
    ["@type.builtin"] = { fg = colors.purple, italic = true },
    ["@type.definition"] = { fg = colors.purple },
    
    ["@attribute"] = { fg = colors.yellow },
    ["@property"] = { fg = colors.fg },
    
    ["@function"] = { fg = colors.cyan, bold = true },  -- 함수 밝은 청록
    ["@function.builtin"] = { fg = colors.cyan },
    ["@function.call"] = { fg = colors.cyan },
    ["@function.macro"] = { fg = colors.cyan },
    ["@function.method"] = { fg = colors.cyan },
    ["@function.method.call"] = { fg = colors.cyan },
    
    ["@constructor"] = { fg = colors.purple },
    ["@operator"] = { fg = colors.fg },
    ["@keyword"] = { fg = colors.pink, bold = true },  -- 키워드 밝은 핑크
    ["@keyword.coroutine"] = { fg = colors.pink },
    ["@keyword.function"] = { fg = colors.pink },
    ["@keyword.operator"] = { fg = colors.pink },
    ["@keyword.import"] = { fg = colors.pink },
    ["@keyword.storage"] = { fg = colors.pink },
    ["@keyword.repeat"] = { fg = colors.pink },
    ["@keyword.return"] = { fg = colors.pink },
    ["@keyword.debug"] = { fg = colors.red },
    ["@keyword.exception"] = { fg = colors.pink },
    ["@keyword.conditional"] = { fg = colors.pink },
    ["@keyword.directive"] = { fg = colors.yellow },
    
    ["@punctuation.delimiter"] = { fg = colors.fg },
    ["@punctuation.bracket"] = { fg = colors.fg },
    ["@punctuation.special"] = { fg = colors.yellow },
    
    ["@comment"] = { fg = colors.comment, italic = true },
    ["@comment.documentation"] = { fg = colors.comment, italic = true },
    ["@comment.error"] = { fg = colors.red },
    ["@comment.warning"] = { fg = colors.orange },
    ["@comment.todo"] = { fg = colors.purple, bold = true },
    ["@comment.note"] = { fg = colors.cyan },
    
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    
    ["@tag"] = { fg = colors.pink },
    ["@tag.attribute"] = { fg = colors.yellow },
    ["@tag.delimiter"] = { fg = colors.fg },
  }
  
  -- 하이라이트 적용
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
  
  -- NvimTree 색상
  vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.purple, bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = colors.purple, bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = colors.green })
  vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = colors.red })
  
  -- Telescope 색상
  vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.selection })
  vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.yellow, bold = true })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.comment })
  
  -- GitSigns 색상
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red })
end

return M