-- Indent line 설정
return {
  -- indent-blankline.nvim 설정
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  
  -- mini.indentscope 설정 (LazyVim이 기본으로 사용)
  {
    "nvim-mini/mini.indentscope",
    opts = {
      symbol = "│",
      options = { 
        try_as_border = true,
        -- 애니메이션 설정
        indent_at_cursor = true,  -- 커서 위치의 들여쓰기 표시
      },
      -- 애니메이션 설정
      draw = {
        delay = 0,  -- 애니메이션 비활성화 (0 = 즉시 표시)
        animation = function() return 0 end,  -- 애니메이션 완전 비활성화
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}