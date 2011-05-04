local background = display.newImage("background-nebula.png")

require "entities"

local player = SimplePlayer.new()


--TODO: collision
--TODO: remove entities which have gone off-screen

-- Input
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

--
local age = 0
local function game_update(event)
  age = age + 1
  if age % 30 == 1 then
    SimpleEnemy.new()
  end
  if age % 20 == 0 then
    SimplePlayerBullet.new(player)
  end
  for i, entity in ipairs(Entity.all) do
    entity.age = entity.age + 1
    entity.update()
  end
  
  -- check for collisions
  --do_collisions("player_bullets", "enemies")
  --do_collisions("player", "enemies")
  --do_collisions("player", "enemy_bullets")
  
  -- destroy entities
end
Runtime:addEventListener( "enterFrame", game_update );

--
--local function do_collisions(group1, group2)
--  for _, e1 in ipairs(collision_groups[group1]) do
--    for _, e2 in ipairs(collision_groups[group2]) do
--      local s1 = e1.sprite
--      local s2 = e2.sprite
--      if math.abs(s1.x - s2.x) < (s1.width  + s2.width ) / 2 and
--         math.abs(s1.y - s2.y) < (s1.height + s2.height) / 2 then
--        e1:collide(group2, e2)
--        e2:collide(group1, e1)
--      end
--    end
--  end
--end



