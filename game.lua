local Background = require("background") -- imports Background


Game = {}
Game.layers = {
  background = display.newGroup(),
  foreground = display.newGroup(),
  player     = display.newGroup(),
}
Game.age = 0
Game.speed = -140
Game.player = SimplePlayer.new()
Game.onEnemyEscaped = function(enemy)
  Game.speed = math.max(0, Game.speed / 2)
end
Game.medals = {
  bronze = { row = 1, minSpeed =  200, maxSpeed = 1000, pointsPerAward = 350 },
  silver = { row = 2, minSpeed = 1000, maxSpeed = 1800, pointsPerAward = 350 },
  gold   = { row = 3, minSpeed = 1800, maxSpeed = 9999, pointsPerAward = 700 },
}
for colour, medal in pairs(Game.medals) do
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

Game.layers.background:insert(Background.displayGroup)


local update = function(event)
  Game.age   = Game.age + 1
  Game.speed = math.min(Game.speed + 1, 2500)
  
  for _, medal in pairs(Game.medals) do
    if Game.speed > medal.minSpeed and Game.speed < medal.maxSpeed then
      medal.points = medal.points + 1
      if medal.points >= medal.pointsPerAward then medal:award() end
      medal.progress.alpha = math.sin(Game.age / 2) * 0.25 + 0.25
      local factor = (medal.points / medal.pointsPerAward) * (3/4) + (1/4)
      if medal.awarded == 5 then
        factor = 1
        Game.speed = Game.speed + 1
      end
      medal.progress.xScale = factor
      medal.progress.yScale = factor
    else
      medal.progress.alpha = 0
    end
  end
  
  local targetBackgroundSpeed = math.min(math.pow(math.max(0, Game.speed) / 750, 4) + 0.05, 50)
  Background.speed = (Background.speed + targetBackgroundSpeed) / 2
  --print(Game.speed, Background.speed)
  
  -- create a new enemy every so often
  if Game.age % 30 == 1 then
    SimpleEnemy.new()
  end
  
  -- update, collide, and reap all entities
  Entity.update()
  
end
Runtime:addEventListener( "enterFrame", update );
