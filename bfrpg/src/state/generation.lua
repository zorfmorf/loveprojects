
state_generation = Gamestate.new()

local char = nil
local state = nil

--TODO: remove
local panel_top = love.graphics.newImage("res/panel_top.png")
local panel = love.graphics.newImage("res/panel.png")
local panel_bottom = love.graphics.newImage("res/panel_bottom.png")
local titlebar = love.graphics.newImage("res/titlebar.png")
local bkg = nil

local function generateBkg()
    love.graphics.setColor(255, 255, 255, 255)
    bkg = love.graphics.newCanvas(screen.w, screen.h)
    local img = love.image.newImageData(1, 2)
    img:setPixel(0, 0, 30, 52, 65, 255)
    img:setPixel(0, 1,  0,  0,  0, 255)
    local data = love.graphics.newImage(img)
    love.graphics.setCanvas(bkg)
    love.graphics.draw(data, 0, 0, 0, screen.w, screen.h/2)
    love.graphics.setCanvas()
end


function state_generation:enter()
    
    generateBkg()
    
    char = Character()
    
    state = "gender"

    -- group defaults
    gui.group.default.size[1] = 150
    gui.group.default.size[2] = 25
    gui.group.default.spacing = 10
end


local function rerollStats()
    local dice = Dice(3, 6) --3d6
    for stat,t in pairs(char.stat) do
        t.value = dice:throw()
    end
end


local function showGenderPage()
    gui.group.push{grow = "down", pos = { screen.w/2.9, 20 + titlebar:getHeight()/2}}
    gui.Label{text="Select Gender", align="right", size={200}}
    gui.group.push{grow = "right"}
    gui.group.push{grow = "down"}
    
    -- TODO: find out why the first element always highlights so we don't need this workaround
    gui.Checkbox{checked = false, draw=function() end}
    
    if gui.Checkbox{checked = char:isFemale(), text = "Female"} then
        char.gender = "female"
    end
    if gui.Checkbox{checked = char:isMale(), text = "Male"} then
        char.gender = "male"
    end
    gui.group.pop{}
        gui.group.push{grow = "down"}
    gui.Label{text=""}
    gui.Label{text="Your chosen gender\ndoes not influence\ngameplay in any way"}
    gui.group.pop{}
    gui.group.pop{}
    
    gui.Label{text=""}
    gui.Label{text=""}
    gui.group.push{grow = "right"}
    if gui.Button{text="Cancel", direction="left"} then
        Gamestate.switch(state_title)
    end
    if gui.Button{text="Next"} then
        state = "stats"
        rerollStats()
    end
end


local function showStatsPage()
    gui.group.push{grow = "down", pos = { screen.w/2.9, 20 + titlebar:getHeight()/2}}
    gui.group.push{grow = "right"}
    gui.Label{text="Ability"}
    gui.Label{text="Value", size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    for stat,t in pairs(char.stat) do
        gui.group.push{grow = "right"}
        gui.Label{text=t.name}
        gui.Label{text=t.value, size={"tight"}}
        gui.Label{text=t.desc, size={"tight"}}
        gui.group.pop{}
    end
    gui.group.push{grow = "right"}
    gui.Label{text="Strength"}
    gui.Label{text=char.str, size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    gui.group.push{grow = "right"}
    gui.Label{text="Intelligence"}
    gui.Label{text=char.int, size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    gui.group.push{grow = "right"}
    gui.Label{text="Wisdom"}
    gui.Label{text=char.wis, size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    gui.group.push{grow = "right"}
    gui.Label{text="Dexterity"}
    gui.Label{text=char.dex, size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    gui.group.push{grow = "right"}
    gui.Label{text="Constitution"}
    gui.Label{text=char.con, size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    gui.group.push{grow = "right"}
    gui.Label{text="Charisma"}
    gui.Label{text=char.cha, size={"tight"}}
    gui.Label{text="Modifier", size={"tight"}}
    gui.group.pop{}
    gui.group.push{grow="right"}
    if gui.Button{text="Back", direction="left"} then
        state = "gender"
    end
    if gui.Button{text="Next"} then
        --state = "dunno"
    end
end


function state_generation:update(dt)
    if state == "gender" then showGenderPage() end
    if state == "stats" then showStatsPage() end
end


function state_generation:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(bkg)
    love.graphics.draw(panel, screen.w/2 + 5, titlebar:getHeight() / 3, 0, 0.5, 0.5, titlebar:getWidth()/2)
    love.graphics.draw(panel, screen.w/2 + 5, titlebar:getHeight(), 0, 0.5, 0.5, titlebar:getWidth()/2)
    love.graphics.draw(panel_bottom, screen.w/2 + 5, 360, 0, 0.5, 0.5, titlebar:getWidth()/2)
    love.graphics.draw(titlebar, screen.w/2, 20, 0, 0.5, 0.5, titlebar:getWidth()/2, 40)
    love.graphics.setColor(73, 40, 17)
    love.graphics.setFont(titlefont)
    love.graphics.print("Character Creation", screen.w / 2, 20, 0, 1, 1, titlefont:getWidth("Character Creation") / 2)
    love.graphics.setFont(font)    
    gui.core.draw(panel)
end

function state_generation:keypressed(key, isrepeat)
    if key == "escape" then Gamestate.switch(state_title) end
    gui.keyboard.pressed(key)
end

function state_generation:textinput(str)
	gui.keyboard.textinput(str)
end

