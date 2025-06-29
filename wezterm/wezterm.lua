local wezterm = require 'wezterm'
local act = wezterm.action


return {
    font = wezterm.font_with_fallback {
        'JetBrainsMono Nerd Font',
        'Pretendard',
        'Apple SD Gothic Neo',
    },

    font_size = 16.0,

    color_scheme = "Dracula",
    initial_rows = 30,
    initial_cols = 100,
    enable_tab_bar = false,

    window_background_opacity = 0.85,  -- 투명도
    macos_window_background_blur = 20, -- 아크릴 블러 (macOS 한정)

    -- Window padding 추가 (tmux 테두리가 잘리지 않도록)
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    },

    -- Line height 조정 (테두리 연결 개선)
    line_height = 1.0,

    -- 한글 입력 개선
    use_ime = true,
    enable_kitty_keyboard = true, -- 일부 조합 이슈 해결

    -- macOS 한글 조합 지연 줄이기
    macos_forward_to_ime_modifier_mask = "SHIFT|CTRL|ALT|CMD",

    -- true color 지원
    enable_wayland = false,

    -- 런처 메뉴 설정 (tmux 세션 포함)
    launch_menu = {},

    -- 키 바인딩
    keys = {
        -- vim 스타일 윈도우 이동
        {
            key = 'h',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindowRelative(-1),  -- 이전 윈도우
        },
        {
            key = 'l',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindowRelative(1),   -- 다음 윈도우
        },
        -- 윈도우 인덱스로 직접 이동
        {
            key = '1',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindow(0),
        },
        {
            key = '2',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindow(1),
        },
        {
            key = '3',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindow(2),
        },
        -- tmux 세션 선택
        {
            key = 't',
            mods = 'CMD',
            action = act.SendString 'tms\n',
        },
    },
}
