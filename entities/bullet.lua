local class = require 'lib.middleclass'
local Vector = require 'vector'

local Entity = require 'entity'

local Bullet = class('Bullet',Entity)

function Bullet:initialize(world, x, y, size, direction, speed)
    Entity.initialize(self, world, x, y, size, size)
    self.direction = direction -- this is a vector object
    self.speed = speed
    self.dv = self.direction:normalize() * speed
    self.toDestroy = false
    
    self.damage = 10
end

function Bullet:update(dt)
    local goalX, goalY = self.x + self.dv.x * dt, self.y + self.dv.y * dt
    local actualX, actualY, cols, length = self.world:move(self, goalX, goalY, function() return "touch" end)
    -- if the bullet touches a static block, then the bullet disappears
    for i=1,length do
        local other = cols[i].other
        if other.class.name == "Block" then
            self.toDestroy = true
        elseif other.class.name == "Player" or "DestroyableBlock" then
            self.toDestroy = true
            other:takeDamage(self.damage)
        end
    end
    self.x, self.y = actualX, actualY
end

function Bullet:draw()
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill",self.x, self.y, self.w, self.h)
end

return Bullet