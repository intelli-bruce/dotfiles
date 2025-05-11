local wezterm = require 'wezterm'
local act = wezterm.action


return {
   font = wezterm.font_with_fallback {
    'JetBrainsMono Nerd Font',
    'Apple SD Gothic Neo',
    'D2Coding',
  },

  font_size = 16.0,

  enable_mouse = true, -- tmux와 충돌 없이 마우스 사용

  -- 마우스 드래그가 wezterm에서 처리되지 않도록 막음
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.DisableDefaultAssignment,
    },
  },

  color_scheme = "Dracula",
  initial_rows = 30,
  initial_cols = 100,
  enable_tab_bar = false,

  window_background_opacity = 0.85,           -- 투명도
  macos_window_background_blur = 20,          -- 아크릴 블러 (macOS 한정)

 -- 한글 입력 개선
  use_ime = true,
  enable_kitty_keyboard = true, -- 일부 조합 이슈 해결

  -- macOS 한글 조합 지연 줄이기
  macos_forward_to_ime_modifier_mask = "SHIFT|CTRL|ALT|CMD",

  -- true color 지원
  enable_wayland = false,
}