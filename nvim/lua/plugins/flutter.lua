return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({})

      -- Dart 파일 저장 시 자동 hot reload
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.dart",
        callback = function()
          -- Flutter 앱이 실행 중일 때만 reload
          vim.cmd("silent! FlutterReload")
        end,
        desc = "Auto hot reload on save",
      })
    end,
  },
}
