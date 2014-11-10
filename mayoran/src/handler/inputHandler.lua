
local oldMousePos = nil

local konamichain = {"up", "up", "down", "down", "left", "right", "left", "right", "b", "a",}
local konamicurrent = 1

function inputHandler_update(dt)
    
    if state == "ingame" then
        
        if love.mouse.isDown( "r" ) then
            
            if oldMousePos ~= nil then
                
                local x,y = love.mouse.getPosition()
               
                worldDrawer.camera_shift(x - oldMousePos[1], y - oldMousePos[2])
                oldMousePos = {x, y}
                
            end
            
        end
        
    end
    
end

function inputHandler_keypressed(key, isrepeat)
   
    if key == "escape" then love.event.push('quit') end
    
    if state == "loading" then
        if konamichain[konamicurrent] ~= nil and key == konamichain[konamicurrent] then 
            konamicurrent = konamicurrent + 1 
            if konamichain[konamicurrent] == nil then
                loadScreen_konamiCode()
            end    
        else
            if konamichain[konamicurrent] ~= nil then konamicurrent = 1 end
        end
        
        if key == " " then loadScreen_spacePressed() end
    end
    
    if state == "ingame" then
        if key == " " then questHandler_acceptQuest() end
        if key == "up" then gameHandler.moveUp() end
        if key == "down" then gameHandler.moveDown() end
        if key == "f1" then showHelp = not showHelp end
        --if key == "return" then state = "fin" end
    end
   
end

function inputHandler_keyreleased(key, isrepeat)
    
end

function inputHandler_mousepressed( x, y, button )
    if state == "ingame" then
        if button == "r" then oldMousePos = {x, y} gameHandler.deselect() end
        if button == "l" then gameHandler.click() end
        if button == "wu" then worldDrawer.camera_zoomOut() end
        if button == "wd" then worldDrawer.camera_zoomIn() end
    end
end

function inputHandler_mousereleased( x, y, button )
    if state == "ingame" and button == "r" then oldMousePos = nil end
end