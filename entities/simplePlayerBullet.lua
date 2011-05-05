-- SimplePlayerBullet class
SimplePlayerBullet = {
  new = function(player, isPowerupEnabled)
    
    local imageFilename = isPowerupEnabled and "images/player-bullet-powerup.png" or "images/player-bullet.png"
    
    local displayObject = display.newImage(imageFilename)
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
