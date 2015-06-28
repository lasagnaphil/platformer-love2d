local class = require 'middleclass'

--
-- Mixin for destroyable objects
--

Destroyable = {}

function Destroyable:included()
    self.health = 100
end

function Destroyable:hit(damage)
    self.health = self.health - damage
    self:checkDestroyed()
end

function Destroyable:checkDestroyed()
    if self.health < 0 then
        self:initDestruction()
    end
end

function Destroyable:initDestruction()
    -- do some explosion effects
    -- destroy the object
    self:destroy()
end