
require "class.world"
require "class.faction"
require "class.ai"
require "view.drawHandler"
require "view.hudHandler"

state_ingame = {}

local tileset = nil
local world = nil
local player = nil
local debug = false


function state_ingame:init()
    player = Faction("Player")
    drawHandler.init()
    world = World(player)
    drawHandler.focusCamera(world.islands[1]:getCenter())
end


function state_ingame:enter()

end


function state_ingame:update(dt)
    
end


function state_ingame:draw()
    drawHandler.drawBkg()
    drawHandler.drawIslands(world.islands)
    if debug then hudHandler.drawDebug() end
end


function state_ingame:mousepressed(x, y, button)
    
end


function state_ingame:keypressed(key, isrepeat)
    if key == "return" then
        Gamestate.switch(state_title)
    end
    if key == "f1" then
        debug = not debug
        world:redraw()
    end
    if key == "left" then drawHandler.moveCamera(-1, 0) end
    if key == "right" then drawHandler.moveCamera(1, 0) end
    if key == "up" then drawHandler.moveCamera(0, -1) end
    if key == "down" then drawHandler.moveCamera(0, 1) end
end

function state_ingame:isDebug()
    return debug
end
