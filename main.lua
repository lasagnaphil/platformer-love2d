class = require 'lib.middleclass'
Stateful = require 'lib.stateful'
local Game = require 'game'

local game
function love.load()
    game = Game:new()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key, code)
    game:keypressed(key, code)
end

function love.keyreleased(key, code)
    game:keyreleased(key, code)
end

function love.mousepressed(x, y, button)
    game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    game:mousereleased(x, y, button)
end
function love.textinput(str)
    game:textinput(str)
end

function love.resize(w,h)
    game:resize(w,h)
end
--]]