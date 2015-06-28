-- the Play gamestate
local Play = Game:addState("Play")
-- imported libraries
local bump = require 'lib.bump'
local sti = require 'lib.sti'
local Camera = require 'lib.camera'
-- imported classes
local Player = require 'player'
local Block = require 'block'

-- global variables
local tileSize = 70
local cameraScale = 2

local blocks = {}

function Play:enteredState()
    print("entering the play screen")
    sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    
    -- initialize the camera
    camera = Camera:new()
    
    -- load the map
    map = sti.new("assets/maps/map01")

    -- initialize collision world
    world = bump.newWorld(50)
    
    player = Player:new(world, 1000, 1000, 70, 500, 1000, 1000)
    
    -- code for generating block objects
    local blockLayer = map.layers["Block Layer"]
    for tileX=1, map.width do
        for tileY=1, map.height do
            if blockLayer.data[tileY][tileX] ~= nil then
                local block = Block:new(world, (tileX-1)*tileSize, (tileY-1)*tileSize, 70)
                table.insert(blocks, block)
            end
        end
    end
    
    --[[
    -- Create the main layer
    local mainLayer = map.layers["Main Layer"]
    -- Insert the objects into the layer
    mainLayer.objects = {player}
    
    -- update and draw the layer
    function mainLayer:update(dt)
        for _, object in pairs(self.objects) do
            object:update(dt)
        end
    end
    
    function mainLayer:draw()
        for _, object in pairs(self.objects) do
            object:draw()
        end
    end]]--
    
end

function Play:update(dt)
    map:update(dt)
    player:update(dt)
    self:movePlayer(player, dt)
    
    -- reposition the camera (do this before draw() is called, to reduce jankiness)
    camera:setPosition(player.x + player.w/2 - sw/2*cameraScale, player.y + player.h/2 - sh/2*cameraScale)
end

function Play:movePlayer(player, dt)
    -- deal with the collisions
    local goalX, goalY = player.x + player.vx * dt, player.y + player.vy * dt
    local actualX, actualY, cols, length = world:move(player, goalX, goalY)
  player.x, player.y = actualX, actualY
    for i=1,length do
        print('collided with ' .. tostring(cols[i].other))
    end
end

function Play:draw()
    camera:set()
    
    local translateX = 0
    local translateY = 0
    --map:setDrawRange(translateX, translateY, ww*cameraScale, wh*cameraScale)
    map:draw()
    player:draw(camera)
    print(player.x .. " " .. player.y)
    
    for _, block in ipairs(blocks) do
        block:draw()
    end
    
    camera:setScale(cameraScale,cameraScale)

    love.graphics.setColor(255,255,255,255)
    
    camera:unset()
    
        -- draw the fps
    love.graphics.setColor(255,255,255)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function Play:keypressed(key, code)
    player:keypressed(key, code)
end

function Play:keyreleased(key, code)
    
end

function Play:mousepressed(x, y, button)
    player:mousepressed(x, y, button)
end

function Play:mousereleased(x, y, button)
    
end

function Play:textinput(str)

end

function Play:resize(w,h)
    map:resize(w,h)
end

function Play:exitedState()
    print("exiting the play screen")
end