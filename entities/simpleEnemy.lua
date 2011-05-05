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
      
      if game.speed > 500 then
        displayObject.x = displayObject.x + (vx * math.min(1, (game.speed - 500) / 500))
      end
      if game.speed > 1000 then
        displayObject.y = displayObject.y + (vy * math.min(1, (game.speed - 1000) / 500))
      end
      
      if self.age % 50 == 0 then
        SimpleEnemyBullet.new(self)
      end
      if displayObject.y > 320 then
        self.remove("bounds")
        game.onEnemyEscaped(self)
      end
      superUpdate()
    end
    self.collide = function(otherGroup, otherEntity)
      if otherGroup == 'player' then
        game.onEnemyEscaped(self)
      elseif otherGroup == 'player_bullets' then
        if math.random(1, 4) == 1 then
          SimplePowerup.new(self)
        end
      end
      self.remove(otherGroup)
    end
    
    return self
  end,
}
