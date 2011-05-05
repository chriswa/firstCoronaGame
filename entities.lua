-- Entity (base) class
Entity = {

  -- class vars
  all = {},
  collisionGroups = { player = {}, enemies = {}, player_bullets = {}, enemy_bullets = {}, powerups = {} },
  
  -- ctor
  new = function(displayObject, collisionGroup)
    local self = {}
    
    -- member vars
    self.displayObject  = displayObject
    self.age            = 0
    self.reap           = false
    self.collisionFudge = 0
    
    -- initialization
    Entity.collisionGroups[collisionGroup][self] = true
    Entity.all[self] = true
    
    -- methods
    function self.update()
      if math.abs(self.displayObject.x - 240) > 480 + 32 or math.abs(self.displayObject.y - 160) > 320 + 32 then
        self.remove("bounds")
      end
    end
    function self.collide(otherGroup, otherEntity)
    end
    function self.remove(reason)
      self.reap = true
    end
    function self._remove()
      if not self.reap then throw("LOGIC ERROR") end
      self.displayObject:removeSelf()
      Entity.all[self] = nil
      Entity.collisionGroups[collisionGroup][self] = nil
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
  Entity.doCollisions()
  
  -- reap entities which have been marked for reaping
  for entity, _ in next, Entity.all, nil do
    if entity.reap then
      entity._remove()
    end
  end
end

--  
Entity.doCollisions = function()
  Entity._doCollisions("player_bullets", "enemies")
  Entity._doCollisions("player", "enemies")
  Entity._doCollisions("player", "enemy_bullets")
  Entity._doCollisions("player", "powerups")
end
Entity._doCollisions = function(group1, group2)
  for e1, _ in pairs(Entity.collisionGroups[group1]) do
    local s1 = e1.displayObject
    for e2, _ in pairs(Entity.collisionGroups[group2]) do
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


-- SimpleEnemy class
SimpleEnemy = {
  new = function()
    local displayObject = display.newImage("images/enemy.png")
    local self = Entity.new(displayObject, "enemies")
    
    self.displayObject.x = math.random(0, 480 - self.displayObject.width) + self.displayObject.width / 2
    self.displayObject.y = -self.displayObject.height
    
    local vx = math.random() - 0.5
    local vy = math.random() - 0.5
    
    -- clamp vx to prevent enemies from going off edges of screen
    vx = math.max(vx, -(self.displayObject.x - 20) / 320)
    vx = math.min(vx, (480 - 20 - self.displayObject.x) / 320)
    
    -- override methods
    local superUpdate = self.update
    self.update = function()
      local displayObject = self.displayObject
      displayObject.y = displayObject.y + 1
      
      if Game.speed > 500 then
        displayObject.x = displayObject.x + (vx * math.min(1, (Game.speed - 500) / 500))
      end
      if Game.speed > 1000 then
        displayObject.y = displayObject.y + (vy * math.min(1, (Game.speed - 1000) / 500))
      end
      
      if self.age % 50 == 0 then
        SimpleEnemyBullet.new(self)
      end
      if displayObject.y > 320 then
        self.remove("bounds")
        Game.onEnemyEscaped(self)
      end
      superUpdate()
    end
    self.collide = function(otherGroup, otherEntity)
      if otherGroup == 'player' then
        Game.onEnemyEscaped(self)
      elseif otherGroup == 'player_bullets' then
        if math.random(1, 20) == 1 then
          SimplePowerup.new(self)
        end
      end
      self.remove(otherGroup)
    end
    
    return self
  end,
}

-- SimpleEnemyBullet class
SimpleEnemyBullet = {
  new = function(enemy)
    local displayObject = display.newImage("images/enemy-bullet.png")
    local self = Entity.new(displayObject, "enemy_bullets")
    
    self.displayObject.x = enemy.displayObject.x
    self.displayObject.y = enemy.displayObject.y + 5
    
    -- override methods
    local superUpdate = self.update
    self.update = function()
      self.displayObject.y = self.displayObject.y + 5
      superUpdate()
    end
    self.collide = function(otherGroup, otherEntity)
      self.remove(otherGroup)
    end
    
    return self
  end,
}

-- SimplePowerup class
SimplePowerup = {
  new = function(enemy)
    local displayObject = display.newImage("images/powerup-blue.png")
    local self          = Entity.new(displayObject, "powerups")
  
    self.displayObject.x = enemy.displayObject.x
    self.displayObject.y = enemy.displayObject.y
    
    self.collisionFudge = -10 -- tweak collision system to give us a bigger hitbox (to compensate for player's smaller hitbox)
    
    local vy = 1.2
    local vx = math.random() - 0.5
    
    -- override methods
    local superUpdate = self.update
    self.update = function()
      if self.reap then return end -- DEBUG
      vy = vy - 0.02
      self.displayObject.x = self.displayObject.x + vx
      self.displayObject.y = self.displayObject.y + vy
      superUpdate()
    end
    self.collide = function(otherGroup, otherEntity)
      self.remove(otherGroup)
    end
    
    return self
  end,
}

-- SimplePlayerBullet class
SimplePlayerBullet = {
  new = function(player)
    local displayObject = display.newImage("images/player-bullet.png")
    local self          = Entity.new(displayObject, "player_bullets")
  
    self.displayObject.x = player.displayObject.x
    self.displayObject.y = player.displayObject.y - 10
    
    -- override methods
    local superUpdate = self.update
    self.update = function()
      if self.reap then return end -- DEBUG
      self.displayObject.y = self.displayObject.y - 5
      superUpdate()
    end
    self.collide = function(otherGroup, otherEntity)
      self.remove(otherGroup)
    end
    
    return self
  end,
}

-- SimplePlayer class
SimplePlayer = {
  new = function()
    local spriteSheet = sprite.newSpriteSheet( "images/player.png", 30, 30 )
    local spriteSet = sprite.newSpriteSet(spriteSheet, 1, 16)
    sprite.add(spriteSet, "healthy", 1, 8, 500)
    sprite.add(spriteSet, "wounded", 9, 1, 500)
    
    local displayObject = sprite.newSprite(spriteSet)
    
    local self = Entity.new(displayObject, "player")
    
    self.displayObject.x = 240
    self.displayObject.y = 300
    
    self.collisionFudge = 10 -- tweak collision system to give us a smaller hitbox
    self.speed          = 4
    self.powerup        = 0
    
    -- private member vars?
    local weaponCooldown      = 0
    local hurtFramesRemaining = 0
    
    self.init = function()
      self.heal() -- start animation
      return self
    end
    self.hurt = function()
      self.speed = self.speed / 2
      hurtFramesRemaining = 30 * 3
      self.displayObject:prepare("wounded")
      self.displayObject:play()
    end
    self.heal = function()
      self.speed = 4
      self.displayObject:prepare("healthy")
      self.displayObject:play()
    end
    
    -- override methods
    self.update = function()
      
      if hurtFramesRemaining > 0 then
        hurtFramesRemaining = hurtFramesRemaining - 1
        if hurtFramesRemaining == 0 then self.heal() end
      end
      
      -- move
      if Input.touch then
      
        local displayObject = self.displayObject
        local dx = Input.x - displayObject.x
        local dy = Input.y - displayObject.y
        local correctedSpeed = self.speed
        if self.powerup > 0 and hurtFramesRemaining == 0 then correctedSpeed = correctedSpeed * 1.5 end
        vx, vy = normalize2dVector(dx, dy, correctedSpeed)
        if vx ~= 1 / 0 then
          if math.abs(dx) < math.abs(vx) then vx = dx end
          if math.abs(dy) < math.abs(vy) then vy = dy end
        
          displayObject.x = displayObject.x + vx
          displayObject.y = displayObject.y + vy
        end
      end
      
      -- shoot
      if weaponCooldown <= 0 then
        SimplePlayerBullet.new(self)
        weaponCooldown = weaponCooldown + 20
        if self.powerup > 0 then
          self.powerup = self.powerup - 1
          weaponCooldown = weaponCooldown - 10
        end
      else
        weaponCooldown = weaponCooldown - 1
      end
      
    end
    self.collide = function(otherGroup, otherEntity)
      if otherGroup == "powerups" then
        self.powerup = self.powerup + 20
        if weaponCooldown > 10 then weaponCooldown = weaponCooldown - 10 end
      else
        self.hurt()
      end
    end
    
    return self.init(self)
  end,
}



















