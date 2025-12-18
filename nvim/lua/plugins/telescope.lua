return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>jg",
      function()
        local tags_file = vim.fn.expand("~/Projects/bruce/.tags")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        -- 태그 파일에서 기존 태그 로드
        local tags = {}
        if vim.fn.filereadable(tags_file) == 1 then
          for line in io.lines(tags_file) do
            if line ~= "" then
              table.insert(tags, line)
            end
          end
        end

        -- 태그 삽입 함수
        local function insert_tag(tag)
          vim.api.nvim_put({ "---[" .. tag .. "]---" }, "c", true, true)
        end

        -- 새 태그 저장 함수
        local function save_tag(tag)
          local file = io.open(tags_file, "a")
          if file then
            file:write(tag .. "\n")
            file:close()
          end
        end

        pickers
          .new({}, {
            prompt_title = "Select or Add Tag",
            finder = finders.new_table({ results = tags }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local input = action_state.get_current_line()
                actions.close(prompt_bufnr)

                if selection then
                  insert_tag(selection[1])
                elseif input and input ~= "" then
                  save_tag(input)
                  insert_tag(input)
                end
              end)
              return true
            end,
          })
          :find()
      end,
      desc = "Insert tag block (with picker)",
    },
  },
}
