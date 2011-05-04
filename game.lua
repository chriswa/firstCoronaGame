require "background" -- imports Background

local layers = {
  background = display.newGroup(),
  foreground = display.newGroup(),
  player     = display.newGroup(),
}

layers.background:insert(Background.displayGroup)




local player = SimplePlayer.new()

local age = 0
local update = function(event)
  age = age + 1
  if age % 30 == 1 then
    SimpleEnemy.new()
  end
  
  -- update, collide, and reap all entities
  Entity.update()
  
end
Runtime:addEventListener( "enterFrame", update );
