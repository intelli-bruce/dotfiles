-- ~/.hammerspoon/init.lua

local ESCAPE_KEY = hs.eventtap.event.types.keyDown
local escapeTap = hs.eventtap.new({ESCAPE_KEY}, function(event)
  if event:getKeyCode() == hs.keycodes.map.escape then
    -- 입력기를 ABC로 설정
    hs.keycodes.setLayout("ABC")

    -- esc 키 한 번만 시스템에 전달
    -- 원본 이벤트 그대로 통과시킴
    return false
  end
end)

escapeTap:start()