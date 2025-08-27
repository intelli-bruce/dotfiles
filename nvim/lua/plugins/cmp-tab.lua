-- 확실하게 작동하는 Tab 설정
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      
      -- 디버그: 현재 매핑 상태 출력
      vim.schedule(function()
        vim.notify("nvim-cmp Tab setup loaded", vim.log.levels.INFO)
      end)
      
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      -- opts.mapping이 없으면 생성
      opts.mapping = opts.mapping or {}
      
      -- Tab 키 매핑 (VSCode 스타일 - 바로 선택)
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- 다음 항목 선택이 아닌 현재 항목 확정!
          cmp.confirm({ select = true })
        elseif vim.snippet and vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" })
      
      -- Shift-Tab 키 매핑
      opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet and vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end, { "i", "s" })
      
      -- Enter 키도 설정 (확실하게)
      opts.mapping["<CR>"] = cmp.mapping.confirm({ select = false })
      
      -- 자동완성 트리거 설정
      opts.completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      }
      
      return opts
    end,
  },
}