-- WezTerm 설정
local wezterm = require("wezterm")
local config = {}

-- 버전에 따른 config builder 사용
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local act = wezterm.action

-- 창별 메모 저장소 (세션 중에만 유지)
local window_notes = {}

-- 기본 설정
config.automatically_reload_config = true
config.use_ime = true

-- 폰트 설정 (Ghostty와 동일)
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono",
	"D2Coding",
	"Apple SD Gothic Neo",
})
config.font_size = 16.0
config.line_height = 1.125
config.cell_width = 0.9 -- 자간을 10% 줄임 (기본값: 1.0)

-- 색상 테마
config.color_scheme = "Dracula"
config.colors = {
	background = "#191B21",

	-- Quick Select 라벨 색상 (눈에 잘 띄도록)
	quick_select_label_bg = { Color = "#ff79c6" }, -- 밝은 핑크 배경
	quick_select_label_fg = { Color = "#000000" }, -- 검은색 텍스트
	quick_select_match_bg = { Color = "#44475a" }, -- 매칭된 텍스트 배경 (회색)
	quick_select_match_fg = { Color = "#50fa7b" }, -- 매칭된 텍스트 (밝은 초록)

	tab_bar = {
		background = "#191B21",
		active_tab = {
			bg_color = "#191B21",
			fg_color = "#FFFFFF",
		},
		inactive_tab = {
			bg_color = "#191B21",
			fg_color = "#CCCCCC",
		},
		inactive_tab_hover = {
			bg_color = "#232530",
			fg_color = "#FFFFFF",
		},
		new_tab = {
			bg_color = "#191B21",
			fg_color = "#CCCCCC",
		},
		new_tab_hover = {
			bg_color = "#232530",
			fg_color = "#FFFFFF",
		},
	},
}

-- 창 설정
config.window_background_opacity = 1.0
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- 타이틀바/탭 바 설정
config.window_frame = {
	inactive_titlebar_bg = "#191B21",
	active_titlebar_bg = "#191B21",
	inactive_titlebar_fg = "#CCCCCC",
	active_titlebar_fg = "#FFFFFF",
	inactive_titlebar_border_bottom = "#191B21",
	active_titlebar_border_bottom = "#191B21",
	font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font Mono",
		"D2Coding",
		"Apple SD Gothic Neo",
	}),
	font_size = 16.0, -- 탭/메모 폰트 크기
}

-- 패딩 설정
config.window_padding = {
	left = "10px",
	right = "10px",
	top = "1.5cell",
	bottom = "0px",
}

-- 탭 바 설정
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false -- 메모 표시를 위해 항상 탭 바 표시
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true

-- 스크롤백
config.scrollback_lines = 10000

-- 커서 설정
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- macOS 특정 설정
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "AlwaysPrompt"

-- Quick Select 설정
config.quick_select_patterns = {
	"https?://[^\\s]+",
	"/[^\\s]+",
	"[a-f0-9]{7,40}",
	"[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+",
	"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+",
	"[A-Z]+-[0-9]+",
	"@[a-zA-Z0-9_]+",
	"#[0-9]+",
	"[0-9]{4}-[0-9]{2}-[0-9]{2}",
}
config.quick_select_alphabet = "asdfghjklqwertyuiop"

-- 반응형 레이아웃을 위한 동적 패딩 계산 함수
local function compute_responsive_padding(window)
	local window_dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	-- 다단계 브레이크포인트 시스템
	local breakpoints = {
		{ width = 2600, content_width = 2200 }, -- 울트라와이드 (최대 2200px)
	}

	-- 현재 창 크기에 맞는 브레이크포인트 찾기
	local target_content_width = nil
	for _, bp in ipairs(breakpoints) do
		if window_dims.pixel_width >= bp.width then
			target_content_width = bp.content_width
			break
		end
	end

	if target_content_width then
		-- 가용 공간과 컨텐츠 너비의 차이 계산
		local horizontal_space = window_dims.pixel_width - target_content_width

		-- 좌우 패딩 균등 분배
		local horizontal_padding = math.max(0, math.floor(horizontal_space / 2))

		-- 셀 단위 정렬 (cols가 있을 때만)
		if window_dims.cols and window_dims.cols > 0 then
			local cell_width = window_dims.pixel_width / window_dims.cols
			-- 셀 크기의 배수로 조정
			local cells_for_padding = math.floor(horizontal_padding / cell_width)
			horizontal_padding = cells_for_padding * cell_width
		end

		-- 상하 패딩
		local vertical_padding = "1.5cell"

		local new_padding = {
			left = horizontal_padding,
			right = horizontal_padding,
			top = vertical_padding,
			bottom = "0px",
		}

		-- 변경사항이 없으면 불필요한 업데이트 방지
		if
			overrides.window_padding
			and overrides.window_padding.left == new_padding.left
			and overrides.window_padding.right == new_padding.right
		then
			return
		end

		overrides.window_padding = new_padding

	-- 디버깅용 로그 (필요시 주석 해제)
	-- wezterm.log_info(string.format(
	--   'Window: %dpx, Target: %dpx, Padding: %dpx',
	--   window_dims.pixel_width, target_content_width, horizontal_padding
	-- ))
	else
		-- 작은 창에서는 기본 패딩 사용
		if overrides.window_padding then
			overrides.window_padding = nil -- 기본값으로 복원
		end
	end

	window:set_config_overrides(overrides)
end

-- 창 크기 변경 시 패딩 재계산
wezterm.on("window-resized", function(window, pane)
	compute_responsive_padding(window)
end)

-- 설정 리로드 시에도 패딩 재계산
wezterm.on("window-config-reloaded", function(window)
	compute_responsive_padding(window)
end)

-- 초기 GUI 시작 시 패딩 적용
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	-- 약간의 지연 후 패딩 계산 (창이 완전히 로드된 후)
	wezterm.time.call_after(0.1, function()
		compute_responsive_padding(window)
	end)
end)

-- 창 메모 입력 액션 (한/영 키 바인딩 공유용)
local note_input_action = wezterm.action_callback(function(window, pane)
	local window_id = tostring(window:window_id())
	local current_note = window_notes[window_id] or ""

	-- macOS osascript dialog 사용 (한글 IME 지원)
	local success, stdout, stderr = wezterm.run_child_process({
		"osascript",
		"-e",
		string.format(
			[[
			set dialogResult to display dialog "창 메모 입력 (빈칸 입력시 삭제):" default answer "%s" buttons {"취소", "확인"} default button "확인"
			if button returned of dialogResult is "확인" then
				return text returned of dialogResult
			else
				return "___CANCEL___"
			end if
		]],
			current_note
		),
	})

	if success then
		local result = stdout:gsub("[\n\r]", "")
		if result ~= "___CANCEL___" then
			if result == "" then
				window_notes[window_id] = nil
			else
				window_notes[window_id] = result
			end
		end
	end
end)

-- 창 메모 상태 표시줄 업데이트
wezterm.on("update-status", function(window, pane)
	local window_id = tostring(window:window_id())
	local note = window_notes[window_id] or ""

	if note ~= "" then
		window:set_right_status(wezterm.format({
			{ Foreground = { Color = "#bd93f9" } },
			{ Text = "📝 " .. note .. "    " },
		}))
	else
		window:set_right_status("")
	end
end)

-- 키 바인딩
config.keys = {
	-- 설정 다시 로드
	{ key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },

	-- 창 메모 입력/수정 (한/영 모두 지원)
	{ key = "n", mods = "CMD|SHIFT", action = note_input_action },
	{ key = "ㅜ", mods = "CMD|SHIFT", action = note_input_action },

	-- Shift+Enter로 \x1b\r 전송
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },

	-- Copy Mode 활성화
	{ key = "o", mods = "CMD|SHIFT", action = act.ActivateCopyMode },

	-- Quick Select Mode
	{ key = "p", mods = "CMD|SHIFT", action = act.QuickSelect },

	-- 패널 분할
	{ key = "\\", mods = "CMD|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- 패널 네비게이션
	{ key = "h", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Right") },

	-- 패널 크기 조정
	{ key = "h", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- 패널 닫기
	{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },

	-- 탭 관리
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

	-- 탭 네비게이션
	{ key = "1", mods = "CMD", action = act.ActivateTab(0) },
	{ key = "2", mods = "CMD", action = act.ActivateTab(1) },
	{ key = "3", mods = "CMD", action = act.ActivateTab(2) },
	{ key = "4", mods = "CMD", action = act.ActivateTab(3) },
	{ key = "5", mods = "CMD", action = act.ActivateTab(4) },
	{ key = "6", mods = "CMD", action = act.ActivateTab(5) },
	{ key = "7", mods = "CMD", action = act.ActivateTab(6) },
	{ key = "8", mods = "CMD", action = act.ActivateTab(7) },
	{ key = "9", mods = "CMD", action = act.ActivateTab(-1) },

	-- 복사/붙여넣기
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },

	-- 검색
	{ key = "f", mods = "CMD", action = act.Search("CurrentSelectionOrEmptyString") },

	-- 전체화면 단축키 비활성화
	{ key = "Enter", mods = "ALT", action = act.Nop }, -- Alt+Enter 명시적 비활성화

	-- 폰트 크기 조정
	{ key = "+", mods = "CMD", action = act.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = act.DecreaseFontSize },
	{ key = "0", mods = "CMD", action = act.ResetFontSize },
}

-- 마우스 바인딩
config.mouse_bindings = {
	-- URL 클릭으로 열기
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = act.OpenLinkAtMouseCursor,
	},
	-- 우클릭으로 붙여넣기
	{
		event = { Up = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
}

-- hyperlink 설정
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Copy Mode 키 테이블 (vim 스타일)
config.key_tables = {
	copy_mode = {
		-- 이동
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

		-- 단어 단위 이동
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },

		-- 줄 시작/끝
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },

		-- 화면 이동
		{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },

		-- 스크롤
		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },

		-- 선택 모드
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "r", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Block" }) }, -- 블록 선택 (더 편한 키)
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) }, -- vim 호환성 유지
		{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },

		-- 선택 영역 조정
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },

		-- 문자 검색 (vim f/F/t/T)
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },

		-- 텍스트 검색 모드 진입 (vim의 / 와 ?)
		{
			key = "/",
			mods = "NONE",
			action = act.Multiple({
				act.CopyMode("ClearPattern"),
				act.Search({ CaseSensitiveString = "" }),
			}),
		},
		{
			key = "?",
			mods = "NONE",
			action = act.Multiple({
				act.CopyMode("ClearPattern"),
				act.Search({ CaseSensitiveString = "" }),
			}),
		},

		-- 검색 결과 네비게이션 (vim의 n/N)
		{ key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
		{ key = "N", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
		{ key = "N", mods = "NONE", action = act.CopyMode("PriorMatch") }, -- Shift 없이도 동작

		-- 복사 및 종료
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				{ CopyTo = "ClipboardAndPrimarySelection" },
				{ CopyMode = "Close" },
			}),
		},

		-- 선택 해제 (vim의 Escape 동작)
		{ key = "Escape", mods = "NONE", action = act.CopyMode("ClearSelectionMode") },

		-- 종료
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },

		-- 다음 줄로
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
	},

	-- Search Mode (검색 창에서의 키 바인딩)
	search_mode = {
		-- Enter로 검색 확정하고 Copy Mode로 돌아가기
		{
			key = "Enter",
			mods = "NONE",
			action = act.Multiple({
				act.CopyMode("AcceptPattern"),
				act.CopyMode("ClearSelectionMode"),
			}),
		},
		-- Esc로 검색 취소하고 Copy Mode로 돌아가기
		{
			key = "Escape",
			mods = "NONE",
			action = act.Multiple({
				act.CopyMode("ClearPattern"),
				act.CopyMode("ClearSelectionMode"),
			}),
		},
		-- 검색 중 매치 네비게이션
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
	},
}

return config

