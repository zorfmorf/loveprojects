-- the draw handler contains all camera handling
-- and draw related code



-- load all textures
-- TODO: overwrite default values by reading from file
function drawHandler_init()

end


function drawHandler_zoomIn()
    
end


function drawHandler_update(dt)

end


function drawHandler_zoomOut()
    
end


-- move the camera into the Direction specified
function drawHandler_shift(dir)
    
end


-- main draw function
function drawHandler_draw()
    
    love.graphics.setBackgroundColor(10, 50, 130, 255)
    love.graphics.setColor(255, 255, 255, 255)
    
     
    love.graphics.origin()
    love.graphics.setColor(10, 50, 130, 255)
    love.graphics.rectangle('fill', 0, 0, 70, 30)
    love.graphics.setColor(230, 230, 230, 220)
    love.graphics.rectangle('line', 0, 0, 70, 30)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    
end
