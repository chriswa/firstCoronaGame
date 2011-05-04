Input = { x = 0, y = 0, touch = false }
local function on_touch(event)
  Input.x = event.x
  Input.y = event.y
  if event.phase == "began" then
    Input.touch = true
  elseif event.phase == "ended" then
    Input.touch = false
  end
end
Runtime:addEventListener( "touch", on_touch );
