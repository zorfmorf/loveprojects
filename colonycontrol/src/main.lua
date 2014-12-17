-- Library includes
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"
Gui = require "lib.quickie"
Vector = require "lib.vector"

-- Class includes
require "class.entity"
require "class.station"

-- Misc includes
steering = require "misc.steering"

-- Gamestates
require "state.ingame"

-- Visual style
style = require "view.style"

-- Gui override
--override = require "lib.quickie.style-bfrpg"

function love.load()
    math.randomseed(os.time())
    
    -- define screen
    screen = { 
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }
    
    -- load all fonts
    font = love.graphics.newFont(20)
    textfont = love.graphics.newFont(20)
    titlefont = love.graphics.newFont(35)
    
    -- initiate gamestates
    Gamestate.registerEvents()
    Gamestate.switch(state_ingame)
    
    -- gui setup defaults
    Gui.group.default.size[1] = 150
    Gui.group.default.size[2] = 25
    Gui.group.default.spacing = 10
    --gui.core.style = override
    
end


function love.update(dt)
    
end


function love.draw()
    
end


function love.keypressed(key, isrepeat)
    if key == "escape" then love.event.push("quit") end
end
