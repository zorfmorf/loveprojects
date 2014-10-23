
hudHandler = {}

function hudHandler.init()
    
end


function hudHandler.update(dt)
    
end


function hudHandler.drawHud()
    
end


function hudHandler.drawDebug()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() / 5)
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("FPS:"..tonumber(love.timer.getFPS()), 10, 5)
end
