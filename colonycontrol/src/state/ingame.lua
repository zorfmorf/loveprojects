
state_ingame = Gamestate.new()

local contact
local station

function state_ingame:enter()
    contact = Entity(Vector:c(screen.w / 2, screen.h / 2), Vector:c(0.1, 0.1))
    station = Station(Vector:c(20, 20))
    contact.target = station
end
    

function state_ingame:update(dt)
        
    -- gui elements
    Gui.group.push{grow="right"}
    Gui.Label{text="Test"}
    Gui.Button{text="Button"}
    
    -- objects
    contact:update(dt)
    station:update(dt)
end


function state_ingame:draw()
    
    love.graphics.translate(-10, -10)
    
    love.graphics.setBackgroundColor(style.hud.bkg)
    
    love.graphics.setColor(style.hud.grid)
    for i=0, screen.w, style.hud.gridw do
        love.graphics.line(i,0,i,screen.h)
    end
    for j=0, screen.h, style.hud.gridw do
        love.graphics.line(0,j,screen.w,j)
    end
    
    -- draw all contacts
    contact:draw()
    
    -- draw all planets
    station:draw()
    
    --Gui.core.draw()
end
    

function state_ingame:keypressed(key, isrepeat)
    Gui.keyboard.pressed(key)
    if key == " " then contact:switchTactic() end
end


function state_ingame:textinput(str)
	Gui.keyboard.textinput(str)
end
