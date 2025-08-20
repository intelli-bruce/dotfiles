local wezterm = require 'wezterm'
local act = wezterm.action

-- 레이아웃 순환을 위한 커스텀 이벤트 핸들러
wezterm.on('cycle-pane-layout', function(window, pane)
    -- 간단한 패널 회전 (tmux의 Space와 유사)
    window:perform_action(act.RotatePanes 'Clockwise', pane)
end)

-- 균등 분할 레이아웃
wezterm.on('balance-panes', function(window, pane)
    -- WezTerm은 자동 균등 분할이 없어서 수동으로 조정 필요
    -- 일단 모든 패널을 리셋하는 효과로 회전 사용
    window:perform_action(act.PaneSelect { mode = 'SwapWithActive' }, pane)
end)

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
    freetype_load_target = 'Normal',  -- Light에서 Normal로 변경 (더 안정적인 렌더링)
    freetype_render_target = 'Normal',  -- HorizontalLcd에서 Normal로 변경
    
    color_scheme = "Dracula",
    initial_rows = 30,
    initial_cols = 100,
    enable_tab_bar = true,  -- 탭바 활성화 (Alt+c, Alt+1~5 등 탭 기능 사용을 위해)
    hide_tab_bar_if_only_one_tab = true,  -- 탭이 하나일 때는 탭바 숨김
    tab_bar_at_bottom = false,  -- 탭바를 상단에 표시
    use_fancy_tab_bar = false,  -- 네이티브 탭바 대신 통합 탭바 사용

    -- 투명도 및 블러 설정 (잔상 문제 해결)
    window_background_opacity = 0.95,  -- 0.85에서 0.95로 증가 (덜 투명하게)
    macos_window_background_blur = 5,  -- 20에서 10으로 감소 (블러 효과 감소)
    native_macos_fullscreen_mode = false,

  
    -- 추가 렌더링 최적화 설정
    front_end = "WebGpu",  -- 더 나은 GPU 가속 사용
    webgpu_power_preference = "HighPerformance",  -- GPU 성능 우선
    max_fps = 240,  -- 최대 FPS 240Hz로 증가 (더 부드러운 렌더링)

    -- Window padding (상단과 좌우에 패딩 추가)
    window_padding = {
        left = 10,   -- 좌측 패딩 (15 → 10)
        right = 10,  -- 우측 패딩 (15 → 10)
        top = 10,    -- 상단 패딩
        bottom = 0,  -- 하단은 패딩 없음
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
        -- === 기존 CMD 키 바인딩 ===
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
        -- Ctrl+Space로 레이아웃 순환 (tmux 스타일을 WezTerm 네이티브로)
        {
            key = 'Space',
            mods = 'CTRL',
            action = act.EmitEvent 'cycle-pane-layout',  -- 바로 레이아웃 순환
        },
        
        -- 화면 리프레시 단축키들
        {
            key = 'l',
            mods = 'CTRL',
            action = act.Multiple {
                act.ClearScrollback 'ScrollbackAndViewport',  -- 스크롤백과 뷰포트 클리어
                act.SendKey { key = 'L', mods = 'CTRL' },  -- Ctrl+L을 쉘로 전달 (clear 명령)
            },
        },
        {
            key = 'r',
            mods = 'CMD',
            action = act.ReloadConfiguration,  -- WezTerm 설정 리로드
        },
        {
            key = 'k',
            mods = 'CMD',
            action = act.ClearScrollback 'ScrollbackAndViewport',  -- 화면 완전 클리어
        },

        -- === tmux Alt 키 기능 이식 ===
        
        -- 패널(Pane) 이동 - Alt+h/j/k/l
        { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
        
        -- 패널 위치 교체 - Alt+Shift+H/J/K/L
        { key = 'H', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'SwapWithActive' } },
        { key = 'J', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'SwapWithActive' } },
        { key = 'K', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'SwapWithActive' } },
        { key = 'L', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'SwapWithActive' } },
        
        -- 패널 분할 - Alt+\ (수직), Alt+- (수평)
        { key = '\\', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = '-', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        
        -- 패널 크기 조절 - Alt+Ctrl+h/j/k/l
        { key = 'h', mods = 'ALT|CTRL', action = act.AdjustPaneSize { 'Left', 5 } },
        { key = 'j', mods = 'ALT|CTRL', action = act.AdjustPaneSize { 'Down', 5 } },
        { key = 'k', mods = 'ALT|CTRL', action = act.AdjustPaneSize { 'Up', 5 } },
        { key = 'l', mods = 'ALT|CTRL', action = act.AdjustPaneSize { 'Right', 5 } },
        
        -- 대체: 패널 크기 조절 - Alt+Shift+h/j/k/l (tmux와 동일)
        { key = 'h', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
        { key = 'j', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
        { key = 'k', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
        { key = 'l', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
        
        -- 패널 관리
        { key = 'w', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } }, -- Alt+w 패널 닫기
        { key = 'f', mods = 'ALT', action = act.TogglePaneZoomState }, -- Alt+f 패널 확대/축소
        { key = '!', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'MoveToNewTab' } }, -- Alt+! 패널을 새 탭으로
        { key = 'o', mods = 'ALT', action = act.ActivatePaneDirection 'Next' }, -- Alt+o 다음 패널
        { key = 'O', mods = 'ALT|SHIFT', action = act.ActivatePaneDirection 'Prev' }, -- Alt+Shift+o 이전 패널
        { key = 'q', mods = 'ALT', action = act.PaneSelect }, -- Alt+q 패널 선택 모드
        { key = 'Space', mods = 'ALT', action = act.EmitEvent 'cycle-pane-layout' }, -- Alt+Space 레이아웃 순환
        { key = '=', mods = 'ALT', action = act.PaneSelect { mode = 'SwapWithActive' } }, -- Alt+= 패널 균등 분할 효과
        
        -- 탭(창) 이동 - Alt+1~5
        { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
        { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
        { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
        { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
        { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
        
        -- 탭(창) 관리
        { key = 'c', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' }, -- Alt+c 새 탭
        { key = 'n', mods = 'ALT', action = act.ActivateTabRelative(-1) }, -- Alt+n 이전 탭
        { key = 'p', mods = 'ALT', action = act.ActivateTabRelative(1) }, -- Alt+p 다음 탭
        { key = 'x', mods = 'ALT', action = act.ShowTabNavigator }, -- Alt+x 탭 네비게이터
        
        -- 이름 변경 (tmux의 Alt+r/R/S에 해당)
        { key = 'r', mods = 'ALT', action = act.PromptInputLine {
            description = 'Enter new name for pane',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_pane():set_title(line)
                end
            end),
        }},
        { key = 'R', mods = 'ALT|SHIFT', action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }},
        
        -- 복사 모드 & 스크롤
        { key = 'a', mods = 'ALT', action = act.ActivateCopyMode }, -- Alt+a 복사 모드
        { key = 'u', mods = 'ALT', action = act.ScrollByPage(-0.5) }, -- Alt+u 반 페이지 위로
        { key = 'd', mods = 'ALT', action = act.ScrollByPage(0.5) }, -- Alt+d 반 페이지 아래로
        { key = 'UpArrow', mods = 'ALT', action = act.ScrollByLine(-3) }, -- Alt+↑ 3줄 위로
        { key = 'DownArrow', mods = 'ALT', action = act.ScrollByLine(3) }, -- Alt+↓ 3줄 아래로
        
        -- 패널 조인 기능 (근사치 구현)
        { key = 'V', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'MoveToNewWindow' } }, -- Alt+V 새 창으로
        { key = 'J', mods = 'ALT|SHIFT', action = act.PaneSelect { mode = 'MoveToNewTab' } }, -- Alt+J 새 탭으로
    },
}
