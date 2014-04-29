require 'core/core'
require 'drawHandler'


-- executed on startup
function love.load()
    
    core_init()
    drawHandler_init()
    
end


-- updaters periodically
function love.update(dt)

    drawHandler_update(dt)
    core_update(dt)
    
end


function love.draw()

    drawHandler_draw()
    
end


function love.keypressed( key, isrepeat )
    

   
end


function love.mousepressed(x, y, button)
        

        
end


function love.quit()
    
end

