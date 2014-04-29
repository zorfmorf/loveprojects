require 'core/core'
require 'core/class'
require 'core/awareness'
require 'drawHandler'

DEBUG = 1 -- debug mode

-- executed on startup
function love.load()

	math.randomseed(os.time())
    
    core_init()
    drawHandler_init()
    
end


function love.update(dt)

    drawHandler_update(dt)
    core_update(dt)
    
end


function love.draw()

    drawHandler_draw()
    
end


function love.keypressed( key, isrepeat )
    
    if key == "up" or key == "left" or
       key == "down" or key == "right" then
        drawHandler_shift(key)
    end
    
    if key == "escape" then
        love.event.quit()
    end
   
end


function love.mousepressed(x, y, button)
        
    if button == "wu" then
        drawHandler_zoomIn()
    end
    
    if button == "wd" then
        drawHandler_zoomOut()
    end
    
    if button == "l" then
        local xn, yn = drawHandler_screenToTiles(x, y)
        core_switchTiles(xn, yn)
    end
        
end


function love.quit()
    
end

