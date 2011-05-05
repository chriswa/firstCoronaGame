module(..., package.seeall)

-- globals
require("entities.entity")
require("entities.simpleEnemy")
require("entities.simpleEnemyBullet")
require("entities.simplePowerup")
require("entities.simplePlayerBullet")
require("entities.player")


all = {}

collisionGroups = { player = {}, enemies = {}, player_bullets = {}, enemy_bullets = {}, powerups = {} }

defaultParent = display.newGroup()

--
update = function()
  -- call individual entities' update methods
  for entity, _ in pairs(all) do
    entity.age = entity.age + 1
    entity.update()
  end
  
  -- check for collisions
  doCollisions()
  
  -- reap entities which have been marked for reaping
  for entity, _ in next, all, nil do
    if entity.reap then
      entity._remove()
    end
  end
end

--  
local function _doCollisions(group1, group2)
  for e1, _ in pairs(collisionGroups[group1]) do
    local s1 = e1.displayObject
    for e2, _ in pairs(collisionGroups[group2]) do
      local s2 = e2.displayObject
      local fudge = e1.collisionFudge + e2.collisionFudge
      if math.abs(s1.x - s2.x) < (s1.width  + s2.width ) / 2 - fudge and
         math.abs(s1.y - s2.y) < (s1.height + s2.height) / 2 - fudge then
        e1.collide(group2, e2)
        e2.collide(group1, e1)
      end
    end
  end
end

doCollisions = function()
  _doCollisions("player_bullets", "enemies")
  _doCollisions("player", "enemies")
  _doCollisions("player", "enemy_bullets")
  _doCollisions("player", "powerups")
end

