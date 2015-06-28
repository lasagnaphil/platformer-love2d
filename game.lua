Game = class("Game"):include(Stateful)

-- The Game
function Game:initialize()
    self:gotoState("Play") -- start on the Menu state
end

dofile("menu.lua")
dofile("play.lua")

return Game