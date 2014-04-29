--[[
Credit screen

]]--

local credits = {}

function credits_init()
    for i=1,20 do
        credits[i] = {}
        credits[i][1] = "Test"..i
        credits[i][2] = love.graphics:getHeight() + i * font_def:getHeight()
    end
end


function credits_update(dt)
    for i,entry in pairs(credits) do
        entry[2] = entry[2] - dt * 40
        if entry[2] < 0 then
           entry[2] = love.graphics:getWidth() * 1 
        end
    end
--    music:play()    
end


function credits_draw()
    love.graphics.setFont(font_def)
    for i,entry in pairs(credits) do
        love.graphics.print(entry[1], 50, entry[2])
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 400, 200)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(img_logo, 450, 100)
    love.graphics.setFont(font_title)
    love.graphics.print("Norimage", 50, 50) 
end
