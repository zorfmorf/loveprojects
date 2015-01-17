
state_intro = Gamestate.new()
local gui = require "lib.quickie"

local font = love.graphics.newFont("font/Linden Hill.otf", 30)
local timer = 0

function state_intro:enter()
    
    -- group defaults
    gui.group.default.size[1] = 150
    gui.group.default.size[2] = 25
    gui.group.default.spacing = 5
end


function state_intro:update(dt)
    timer = timer + dt
    gui.group.push{grow = "down", pos = {love.graphics.getWidth()/2, love.graphics.getHeight()/2}}
    if timer > 2 then
        gui.Label{text = "Ravensburgh,"}
    end
    if timer > 4 then
        gui.Label{text = "somewhere during the Age of War..."}
    end
end


function state_intro:draw()
    love.graphics.setFont(font)
    gui.core.draw()
end
