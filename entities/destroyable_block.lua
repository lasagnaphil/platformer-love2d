local class = require 'lib.middleclass'

local Entity = require 'entity'

local DestroyableBlock = class('DestroyableBlock', Entity)
DestroyableBlock:include(Destroyable)
    
function DestroyableBlock:initialize(world, x, y, size)
    Entity.initialize(self, world, x, y, size, size)
    self.name = "dblock"
    self.health = 100
    self.toDestroy = false
end

function DestroyableBlock:update(dt)
    self:changeVelocityByGravity(dt)
    
    local futureX = self.x + self.vx * dt
    local futureY = self.y + self.vy * dt
    
    local actualX, actualY, cols, length = self.world:move(self, futureX, futureY)
    --self.x, self.y = actualX, actualY
    for i=1,length do
        --print('collided with ' .. tostring(cols[i].other))
        local col = cols[i]
        self:changeVelocityByCollisionNormal(col.normal.x, col.normal.y, 0)
    end
    self.x, self.y = actualX, actualY
end

function DestroyableBlock:takeDamage(damage)
    self.health = self.health - damage
    self:checkDestroyed()
end

function DestroyableBlock:checkDestroyed()
    if self.health < 0 then
        self.toDestroy = true
        self:initDestruction()
    end
end

function DestroyableBlock:initDestruction()
    -- effects when being destructed (such as explosion or spawn item/weapon)
end


function DestroyableBlock:draw()
    love.graphics.setColor(255*(1-self.health/100),255*self.health/100,0)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end

return DestroyableBlock