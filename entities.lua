-- collision_groups
local collision_groups = { player = {}, enemies = {}, player_bullets = {}, enemy_bullets = {} }

-- Entity (base) class
Entity = { all = {} }
function Entity.new(sprite, collision_group)
  local self = {}
  
  -- member vars
  self.sprite = sprite
  self.age    = 0
  
  -- initialization
  if collision_group then
    table.insert(collision_groups[collision_group], self)
  end
  table.insert(Entity.all, self)
  
  -- methods
  function self.update()
  end
  function self.collide(otherGroup, otherEntity)
  end
  
  return self
end

-- SimpleEnemy class
SimpleEnemy = {}
function SimpleEnemy.bless(self)
  self.sprite.x = math.random(0, 480-self.sprite.width) + self.sprite.width/2
  self.sprite.y = -self.sprite.height
  
  -- override methods
  function self.update()
    local sprite = self.sprite
    sprite.y = sprite.y + 1
    if self.age % 50 == 0 then
      SimpleEnemyBullet.new(self)
    end
  end
  
  return self
end
function SimpleEnemy.new()
  local sprite = display.newImage("enemy.png")
  return SimpleEnemy.bless( Entity.new(sprite, "enemies") )
end

-- SimpleEnemyBullet class
SimpleEnemyBullet = {}
function SimpleEnemyBullet.bless(self, enemy)
  self.sprite.x = enemy.sprite.x
  self.sprite.y = enemy.sprite.y
  
  -- override methods
  function self.update()
    self.sprite.y = self.sprite.y + 5
  end
  
  return self
end
function SimpleEnemyBullet.new(enemy)
  local sprite = display.newImage("enemy-bullet.png")
  return SimpleEnemyBullet.bless( Entity.new(sprite, "enemy_bullets"), enemy )
end

-- SimplePlayerBullet class
SimplePlayerBullet = {}
function SimplePlayerBullet.bless(self, player)
  self.sprite.x = player.sprite.x
  self.sprite.y = player.sprite.y
  
  -- override methods
  function self.update()
    self.sprite.y = self.sprite.y - 5
  end
  
  return self
end
function SimplePlayerBullet.new(player)
  local sprite = display.newImage("player-bullet.png")
  return SimplePlayerBullet.bless( Entity.new(sprite, "player_bullets"), player )
end

-- SimplePlayer class
SimplePlayer = {}
function SimplePlayer.bless(self)
  self.sprite.x = 240
  self.sprite.y = 300

  -- override methods
  function self.update()
    if Input.touch then
      local sprite = self.sprite
      local dx = Input.x - sprite.x
      local dy = Input.y - sprite.y
      if (dx < -2) then
        dx = -2
      end
      if (dx > 2) then
        dx = 2
      end
      if (dy < -2) then
        dy = -2
      end
      if (dy > 2) then
        dy = 2
      end
      sprite.x = sprite.x + dx
      sprite.y = sprite.y + dy
    end
  end
  
  return self
end
function SimplePlayer.new()
  local sprite = display.newImage("player.png")
  return SimplePlayer.bless( Entity.new(sprite, "player") )
end


