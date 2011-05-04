require "background" -- imports Background

local layers = {
  background = display.newGroup(),
  foreground = display.newGroup(),
  player     = display.newGroup(),
}

layers.background:insert(Background.displayGroup)


-- TODO: background speed is score bonus indicator (or the only indicator that you're doing well!)


Game = {}
Game.age = 0
Game.speed = 0
Game.player = SimplePlayer.new()
Game.onEnemyEscaped = function(enemy)
  print "ENEMY ESCAPED!!!"
  Game.speed = math.max(0, Game.speed / 2)
end
Game.points = { bronze = 0, silver = 0, gold = 0 }


local update = function(event)
  Game.age   = Game.age + 1
  Game.speed = Game.speed + 1
  
  if Game.speed > 500 then
    Game.points.bronze = Game.points.bronze + 1
  end
  if Game.speed > 1000 then
    Game.points.bronze = Game.points.bronze + 1
  end
  if Game.speed > 1500 then
    Game.points.bronze = Game.points.bronze + 1
  end
  
  Background.speed = math.min(math.pow(math.max(0, Game.speed) / 500, 4) + 0.05, 90)
  --print(Game.speed, Background.speed)
  
  -- create a new enemy every so often
  if Game.age % 30 == 1 then
    SimpleEnemy.new()
  end
  
  -- update, collide, and reap all entities
  Entity.update()
  
end
Runtime:addEventListener( "enterFrame", update );
