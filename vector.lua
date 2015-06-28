local class = require 'lib.middleclass'

local Vector = class("Vector")

function Vector:initialize(x,y)
    self.x = x
    self.y = y
end

function Vector.__add(v1, v2)
    return Vector:new(v1.x + v2.x, v1.y + v2.y)
end

function Vector.__sub(v1, v2)
    return Vector:new(v1.x - v2.x, v1.y - v2.y)
end

function Vector.__mul(v, t)
    return Vector:new(t * v.x, t * v.y)
end

function Vector.__div(v, t)
    if t then
        return Vector:new(v.x / t, v.y / t)
    end
end

function Vector:cross(v)
    return Vector:new(self.x * v.x + self.y * v.y)
end

function Vector:size()
    return math.sqrt(self.x*self.x + self.y*self.y)
end

function Vector:sizesq()
    return self.x*self.x + self.y*self.y
end

function Vector:normalize()
    return self/(self:size())
end

function Vector:expand()
    return self.x, self.y
end

function Vector:rotate(angle)
    return Vector:new(math.cos(angle) * self.x - math.sin(angle) * self.y, math.sin(angle) * self.x + math.cos(angle) * self.y)
end


return Vector
    