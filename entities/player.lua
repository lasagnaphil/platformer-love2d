-- libs
local Vector = require 'vector'

-- classes
local Entity = require 'entity'
local Bullet = require 'entities.bullet'

-- The  Player class
local Player = class('Player', Entity)

-- some constants
local gunLength = 70

function Player:initialize(world, x, y, size, speed, accel, decel)
    Entity.initialize(self, world, x, y, size, size)
    self.speed = 300
    self.accel = 2000
    self.decel = 2000
    self.accelY = 3000
    self.jumpVel = 700
    
    self.health = 100
    
    self.onGround = false
    self.bullets = {}
    self.isJetpacking = false
    self.isJumping = false
end
 
function Player:update(dt)
    self:changeVelocityByKeys(dt)
    self:changeVelocityByGravity(dt)
    self:moveColliding(dt)
    -- update the bullets
    for _, bullet in ipairs(self.bullets) do
        bullet:update(dt)
        if bullet.toDestroy then
            -- remove the bullet
            bullet:destroy()
            table.remove(self.bullets, _)
        end
    end
    love.audio.setPosition(self.x,self.y,0)
    love.audio.setDirection(self.direction.x, self.direction.y, 0)
    love.audio.setVelocity(self.vx,self.vy,0)
end

function Player:changeVelocityByKeys(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		if (self.vx - self.accel * dt) > -self.speed then
            self.vx = self.vx - self.accel * dt
        end
	elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        if (self.vx + self.accel * dt) < self.speed then
            self.vx = self.vx + self.accel * dt
        end
	else
        local brake = dt * (self.vx < 0 and self.decel or -self.decel)
        if math.abs(brake) > math.abs(self.vx) then
            self.vx = 0
        else
            self.vx = self.vx + brake
        end
    end
    if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and self.onGround then
        if self.isJetpacking == false then self.vy = -self.jumpVel end
        self.isJumping = true
    elseif love.keyboard.isDown(" ") then
        if self.isJumping == false then self.vy = self.vy - self.accelY * dt end
        self.isJetpacking = true
    else
        self.isJumping = false
        self.isJetpacking = false
    end
end

function Player:moveColliding(dt)
    local playerFilter = function(item, other)
        if other.class.name == 'Block' then return 'slide' end
        if other.class.name == 'Bullet' then return 'cross' end
    end

    self.onGround = false
    
    local futureX = self.x + self.vx * dt
    local futureY = self.y + self.vy * dt
    
    local actualX, actualY, cols, length = self.world:move(self, futureX, futureY, playerFilter)
    --self.x, self.y = actualX, actualY
    for i=1,length do
        --print('collided with ' .. tostring(cols[i].other))
        local col = cols[i]
        self:changeVelocityByCollisionNormal(col.normal.x, col.normal.y, 0)
        self:checkIfOnGround(col.normal.y)
    end
    self.x, self.y = actualX, actualY
end

function Player:checkIfOnGround(ny)
    if ny < 0 then self.onGround = true end
end

function Player:takeDamage(damage)
    self.health = self.health - damage
end

function Player:keypressed(key, code)
end

function Player:mousepressed(x, y, button)
    if button == 'l' then
        local cx, cy = self:getCenter()
        local gunX, gunY = self:gunVector():expand()
        table.insert(self.bullets, Bullet:new(self.world, cx + gunX, cy + gunY, 15, self.direction, 100000))
    end
end

function Player:gunVector()
    return self.direction:normalize() * gunLength
end

function Player:draw(camera)
    -- draw the player body
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    
    --
    -- draw the gun
    -- first, calculate the direction
    love.graphics.setColor(255,255,255,255)
    local cx, cy = self:getCenter()
    local tx, ty = love.mouse.getPosition()
    tx, ty = camera:convertToWorldPosition(tx, ty)
    self.direction = Vector:new(tx-cx,ty-cy)
    -- now draw the gun vector
    local gunX, gunY = self:gunVector():expand()
    love.graphics.line(cx, cy, cx+gunX, cy+gunY)
    
    self:drawHealth()
    --
    -- draw the bullets
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
    
end


function Player:drawHealth()
    local barWidth = self.w * 1.5
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill", self.x + self.w/2 - barWidth/2, self.y - self.h/4, barWidth * player.health / 100, 10)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line", self.x + self.w/2 - barWidth/2, self.y - self.h/4, barWidth, 10)
end

return Player