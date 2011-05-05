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
