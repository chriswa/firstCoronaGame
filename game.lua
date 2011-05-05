module(..., package.seeall)

local Background = require "background"
require "entities" 

age = 0
speed = -140  -- GLOBAL

-- set up layers
layers = {
  background = display.newGroup(),
  foreground = display.newGroup(),
  player     = display.newGroup(),
  hud        = display.newGroup(),
}
Background.setParent( layers.background )
entities.defaultParent = layers.foreground

-- 
player = entities.Player.new()
player.setParent( layers.player )

-- catch event from entity (XXX)
onEnemyEscaped = function(enemy) -- XXX GLOBAL
  speed = math.max(0, speed / 2)
end

-- medals (TODO: move these into another module)
local medals = {
  bronze = { row = 1, minSpeed =  200, maxSpeed = 1000, pointsPerAward = 350 },
  silver = { row = 2, minSpeed = 1000, maxSpeed = 1800, pointsPerAward = 350 },
  gold   = { row = 3, minSpeed = 1800, maxSpeed = 9999, pointsPerAward = 700 },
}
for colour, medal in pairs(medals) do
  medal.colour   = colour
  medal.points   = 0
  medal.awarded  = 0
  medal.progress = display.newImage("images/star-" .. colour .. ".png")
  medal.progress.x = 10 + 10
  medal.progress.y = medal.row * 16
  medal.award = function(medal)
    medal.points = 0
    if medal.awarded < 5 then
      medal.awarded = medal.awarded + 1
      local displayObject = display.newImage("images/star-" .. colour .. ".png")
      displayObject.x  = medal.awarded * 10 + 10
      displayObject.y  = medal.row     * 16
      medal.progress.x = medal.progress.x + 10
    end
  end
end



Runtime:addEventListener( "enterFrame", function(event)
  age   = age + 1
  speed = math.min(speed + 1, 2500)
  
  for _, medal in pairs(medals) do
    if speed > medal.minSpeed and speed < medal.maxSpeed then
      medal.points = medal.points + 1
      if medal.points >= medal.pointsPerAward then medal:award() end
      medal.progress.alpha = math.sin(age / 2) * 0.25 + 0.25
      local factor = (medal.points / medal.pointsPerAward) * (3/4) + (1/4)
      if medal.awarded == 5 then
        factor = 1
        speed = speed + 1
      end
      medal.progress.xScale = factor
      medal.progress.yScale = factor
    else
      medal.progress.alpha = 0
    end
  end
  
  local targetBackgroundSpeed = math.min(math.pow(math.max(0, speed) / 750, 4) + 0.05, 50)
  Background.speed = (Background.speed + targetBackgroundSpeed) / 2
  --print(speed, Background.speed)
  
  -- create a new enemy every so often
  if age % 30 == 1 then
    SimpleEnemy.new()
  end
  
  -- update, collide, and reap all entities
  entities.update()
  
end )
