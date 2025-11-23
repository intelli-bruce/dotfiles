return {
  "3rd/image.nvim",
  build = false, -- so that it doesn't build the rock
  opts = {
    backend = "kitty", -- WezTerm supports Kitty graphics protocol
    processor = "magick_cli", -- Use ImageMagick CLI (just installed via brew)
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = {
        enabled = true,
        filetypes = { "norg" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = false,
  },
}
