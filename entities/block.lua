local class = require('lib.middleclass')

local Entity = require 'entity'
local Block = class('Block', Entity)

function Block:initialize(world, x, y, size)
    Entity.initialize(self, world, x, y, size, size)
    self.name = 'block'
end

function Block:update(dt)
    
end

function Block:draw()
    -- only for physics debug stuff
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Block