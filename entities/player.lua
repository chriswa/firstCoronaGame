-- Player class
Player = {
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
      if self.powerup > 0 then
        self.powerup = self.powerup - 1
      end
      if weaponCooldown <= 0 then
        local cooldown = 20
        cooldown = math.max(10, math.min(20, game.speed / 50))
        print(game.speed, cooldown)
        SimplePlayerBullet.new(self, self.powerup > 0)
        if self.powerup > 0 then
          cooldown = cooldown / 2
        end
        weaponCooldown = weaponCooldown + cooldown
      else
        weaponCooldown = weaponCooldown - 1
      end
      
    end
    self.collide = function(otherGroup, otherEntity)
      if otherGroup == "powerups" then
        self.powerup = self.powerup + 90
        if weaponCooldown > 10 then weaponCooldown = weaponCooldown - 10 end
      else
        self.hurt()
      end
    end
    
    return self.init(self)
  end,
}
