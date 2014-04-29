--[[
The evidence board

]]--

local case = nil

function board_init()
    local hint = Hint()
    hint:activate()
    
    case = Case({hint})
end


function board_update(dt)
    
end


function board_draw()
    
    love.graphics.setBackgroundColor(color_white)
    
    love.graphics.setColor(color_black)
    love.graphics.setFont(font_title)
    love.graphics.print(case.title, love.graphics:getWidth() / 2, 20, 0, 1, 1, 
        font_title:getWidth(case.title) / 2)
    love.graphics.setFont(font_head)
    love.graphics.setColor(color_red)
    
    
end
