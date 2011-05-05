-- Entity (base) class
Entity = {

  -- ctor
  new = function(displayObject, collisionGroup)
    local self = {}
    
    -- member vars
    self.displayObject  = displayObject
    self.age            = 0
    self.reap           = false
    self.collisionFudge = 0
    
    -- initialization
    entities.collisionGroups[collisionGroup][self] = true
    entities.all[self] = true
    
    -- methods
    function self.setParent(parent)
      parent:insert(self.displayObject)
    end
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
      entities.all[self] = nil
      entities.collisionGroups[collisionGroup][self] = nil
    end
    
    self.setParent(entities.defaultParent)
    
    return self
  end,
}
