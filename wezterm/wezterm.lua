local wezterm = require 'wezterm'
local act = wezterm.action

return {
    -- 폰트 설정을 단순화하고 JetBrainsMono를 메인으로 사용
    font = wezterm.font_with_fallback {
        { family = 'JetBrainsMono Nerd Font', weight = 'Regular' },
        { family = 'Apple Color Emoji' },
        { family = 'Noto Sans CJK KR' },
        { family = 'Apple SD Gothic Neo' },
    },

    font_size = 16.0,
    
    -- 폰트 렌더링 최적화
    freetype_load_target = 'Light',
    freetype_render_target = 'HorizontalLcd',
    
    color_scheme = "Dracula",
    initial_rows = 30,
    initial_cols = 100,
    enable_tab_bar = false,

    window_background_opacity = 0.85,
    macos_window_background_blur = 20,

    -- Window padding (모든 패딩 제거)
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    -- Line height
    line_height = 1.0,

    -- 한글 입력 지원
    use_ime = true,
    
    -- macOS 설정
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = false,

    -- 런처 메뉴 설정
    launch_menu = {},

    -- macOS에서 Option 키를 Meta 키로 사용
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = false,
    
    -- 키 바인딩
    keys = {
        -- vim 스타일 윈도우 이동
        {
            key = 'h',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindowRelative(-1),
        },
        {
            key = 'l',
            mods = 'CMD|SHIFT',
            action = act.ActivateWindowRelative(1),
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