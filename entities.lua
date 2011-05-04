-- Entity (base) class
Entity = {

  -- class vars
  all = {},
  collision_groups = { player = {}, enemies = {}, player_bullets = {}, enemy_bullets = {} },
  
  -- ctor
  new = function(sprite, collision_group)
    local self = {}
    
    -- member vars
    self.sprite = sprite
    self.age    = 0
    self.reap   = false
    
    -- initialization
    Entity.collision_groups[collision_group][self] = true
    Entity.all[self] = true
    
    -- methods
    function self.update()
      if math.abs(self.sprite.x - 240) > 480 + 32 or math.abs(self.sprite.y - 160) > 320 + 32 then
        self.reap = true
      end
    end
    function self.collide(otherGroup, otherEntity)
    end
    function self.remove()
      self.reap = true
    end
    function self._remove()
      if not self.reap then throw("LOGIC ERROR") end
      self.sprite:removeSelf()
      Entity.all[self] = nil
      Entity.collision_groups[collision_group][self] = nil
    end
    
    return self
  end,
}

--
Entity.update = function()
  -- call individual entities' update methods
  for entity, _ in pairs(Entity.all) do
    entity.age = entity.age + 1
    entity.update()
  end
  
  -- check for collisions
  Entity.do_collisions()
  
  -- reap entities which have been marked for reaping
  for entity, _ in next, Entity.all, nil do
    if entity.reap then
      entity._remove()
    end
  end
end

--  
Entity.do_collisions = function()
  Entity._do_collisions("player_bullets", "enemies")
  Entity._do_collisions("player", "enemies")
  Entity._do_collisions("player", "enemy_bullets")
end
Entity._do_collisions = function(group1, group2)
  for e1, _ in pairs(Entity.collision_groups[group1]) do
    for e2, _ in pairs(Entity.collision_groups[group2]) do
      local s1 = e1.sprite
      local s2 = e2.sprite
      if math.abs(s1.x - s2.x) < (s1.width  + s2.width ) / 2 and
         math.abs(s1.y - s2.y) < (s1.height + s2.height) / 2 then
        e1.collide(group2, e2)
        e2.collide(group1, e1)
      end
    end
  end
end


-- SimpleEnemy class
SimpleEnemy = {
  new = function()
    local sprite = display.newImage("enemy.png")
    local self = Entity.new(sprite, "enemies")
  
    self.sprite.x = math.random(0, 480 - self.sprite.width) + self.sprite.width / 2
    self.sprite.y = -self.sprite.height
    
    -- override methods
    local super_update = self.update
    self.update = function()
      local sprite = self.sprite
      sprite.y = sprite.y + 1
      if self.age % 50 == 0 then
        SimpleEnemyBullet.new(self)
      end
      super_update()
    end
    self.collide = function(otherGroup, otherEntity)
      self.remove()
    end
    
    return self
  end,
}

-- SimpleEnemyBullet class
SimpleEnemyBullet = {
  new = function(enemy)
    local sprite = display.newImage("enemy-bullet.png")
    local self = Entity.new(sprite, "enemy_bullets")
    
    self.sprite.x = enemy.sprite.x
    self.sprite.y = enemy.sprite.y
    
    -- override methods
    local super_update = self.update
    self.update = function()
      self.sprite.y = self.sprite.y + 5
      super_update()
    end
    self.collide = function(otherGroup, otherEntity)
      self.remove()
    end
    
    return self
  end,
}

-- SimplePlayerBullet class
SimplePlayerBullet = {
  new = function(player)
    local sprite = display.newImage("player-bullet.png")
    local self = Entity.new(sprite, "player_bullets")
  
    self.sprite.x = player.sprite.x
    self.sprite.y = player.sprite.y
    
    -- override methods
    local super_update = self.update
    self.update = function()
      if self.reap then return end -- DEBUG
      self.sprite.y = self.sprite.y - 5
      super_update()
    end
    self.collide = function(otherGroup, otherEntity)
      self.remove()
    end
    
    return self
  end,
}

-- SimplePlayer class
SimplePlayer = {
  new = function()
    local sprite = display.newImage("player.png")
    local self = Entity.new(sprite, "player")
    
    self.sprite.x = 240
    self.sprite.y = 300
  
    -- override methods
    self.update = function()
      
      -- move
      if Input.touch then
        local sprite = self.sprite
        local dx = Input.x - sprite.x
        local dy = Input.y - sprite.y
        vx, vy = normalize2dVector(dx, dy, 4)
        if vx ~= 1 / 0 then
          if math.abs(dx) < math.abs(vx) then vx = dx end
          if math.abs(dy) < math.abs(vy) then vy = dy end
        
          sprite.x = sprite.x + vx
          sprite.y = sprite.y + vy
        end
      end
      
      -- shoot
      if self.age % 20 == 0 then
        SimplePlayerBullet.new(self)
      end
      
    end
    
    return self
  end,
}



















