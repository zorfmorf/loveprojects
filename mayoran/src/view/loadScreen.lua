
local nebulator = love.thread.newThread("lib/nebulator.lua")

local output = love.thread.getChannel("nebulator_output")
local percentage = love.thread.getChannel("nebulator_percentage")
local input = love.thread.getChannel("nebulator_input")

local loadValue = nil

local ready = false

local font = nil
local titlefont = nil

local realtitlefont = nil

function loadScreen_init()
    input:push(love.graphics:getWidth())
    input:push(love.graphics:getHeight())
    input:push(34534534)
    
    nebulator:start()
    loadValue = 0
    font = love.graphics.newFont("font/SFPixelate.ttf", 25)
    titlefont = love.graphics.newFont("font/SFPixelate.ttf", 50)
    realtitlefont  = love.graphics.newFont("font/SFPixelate.ttf", 100)

end


function loadScreen_update(dt)
    
    if output:peek() == nil then
    
    
        local t = percentage:pop()
        
        while percentage:peek() do t = percentage:pop() end
        
        if t ~= nil then loadValue = t end
    
    else
        ready = true
        worldDrawer.generateBackground(output:pop())
    end
end

function loadScreen_spacePressed()
    
    if ready then state = "ingame" end
    
end

function loadScreen_konamiCode()
    
end

function loadScreen_draw()

    
    love.graphics.setColor(255, 255, 255, 255)
    
    love.graphics.setFont(realtitlefont)
    
    if not showHelp then 
        local tmp = "Mayoran"
        love.graphics.print(tmp, love.graphics.getWidth() / 2, 50, 
                0, 1, 1, realtitlefont:getWidth(tmp) / 2, realtitlefont:getHeight() / 2)
    end
    
    
    love.graphics.setFont(titlefont)
    
    tmp = "Quickguide"
    love.graphics.print(tmp, love.graphics.getWidth() / 2, 140, 
            0, 1, 1, titlefont:getWidth(tmp) / 2, titlefont:getHeight() / 2)
        
    
    love.graphics.setFont(font)

    love.graphics.printf("Your ressources", love.graphics.getWidth() - 200, 150, 200)
    love.graphics.draw(tut_ressources, love.graphics.getWidth() - 110, 20 )
    
    love.graphics.printf("Switch layers", love.graphics.getWidth() - 220, love.graphics.getHeight() / 2 - 25, 150)
    love.graphics.draw(tut_layer, love.graphics.getWidth() - 110, love.graphics.getHeight() / 2, 0, 1, 1, 0, tut_layer:getHeight() / 2 )
    
    love.graphics.draw(tut_mouse, love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2, 
        0, 1, 1, tut_mouse:getWidth() / 2, tut_mouse:getHeight() / 2)
    love.graphics.print("Interact", love.graphics:getWidth() / 2 - (tut_mouse:getWidth() + 175), love.graphics:getHeight() / 2 - 45)
    love.graphics.print("Deselect / \n Grab to move map", love.graphics:getWidth() / 2 + (tut_mouse:getWidth() / 2)  - 100, 
        love.graphics:getHeight() / 2 - 70)
    love.graphics.print("Zoom in/out", love.graphics:getWidth() / 2 + (tut_mouse:getWidth() / 2)  - 100, 
        love.graphics:getHeight() / 2 + 40)
    
    
    love.graphics.printf("Build things here!", love.graphics.getWidth() - 200, love.graphics.getHeight() - 180, 200)
    love.graphics.draw(tut_build, love.graphics.getWidth() - 80, love.graphics.getHeight() - 150 )

    if not showHelp then 
        if ready then
            local string = "Press space to start game... "
            love.graphics.print(string, love.graphics.getWidth() / 2, love.graphics:getHeight() - 60, 
                0, 1, 1, font:getWidth(string) / 2, font:getHeight() / 2)
        else
            love.graphics.rectangle("fill", 300, love.graphics:getHeight() - 80, (love.graphics:getWidth() - 600) * loadValue, 30)
        end
    end
    
end