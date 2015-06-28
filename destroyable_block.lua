local class = require 'lib.middleclass'

local Block = require 'Block'
local DestroyableBlock = class('DestroyableBlock', Block)

function DestroyableBlock:initialize(world, x, y, size)
    Block:initialize(world, x, y, size)
    self.name = 'dblock'
end

function DestroyableBlock:update(dt)
    
end

function DestroyableBlock:draw()

end
