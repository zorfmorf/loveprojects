
state_title = {}


function state_title:init()
    
end


function state_title:enter()

end


function state_title:update(dt)
    
end


function state_title:draw()
    love.graphics.print("title")
end


function state_title:keypressed(key, isrepeat)
    if key == "return" then
        Gamestate.switch(state_ingame)
    end
end
