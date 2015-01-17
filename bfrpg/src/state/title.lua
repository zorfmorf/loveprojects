
state_title = Gamestate.new()

function state_title:enter()
    
end


function state_title:update(dt)
    gui.group.push{grow = "down", pos = {love.graphics.getWidth()/2, love.graphics.getHeight()/4}}
    gui.Label{text="Basic Fantasy RPG"}
    
    -- TODO: find out why the first element always highlights so we don't need this workaround
    gui.Checkbox{checked = false, draw=function() end}
    
    if gui.Button{text = "Generate Character"} then
        Gamestate.switch(state_generation)
    end
end


function state_title:draw()
    love.graphics.setFont(font)
    gui.core.draw()
end

function state_title:keypressed(key, isRepeat)
    if key == "escape" then love.event.push("quit") end
end