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
