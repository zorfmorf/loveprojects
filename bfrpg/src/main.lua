-- Library includes
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"
gui = require "lib.quickie"

-- Class includes
require "class.character"
require "class.dice"

-- Gamestates
require "state.generation"
require "state.intro"
require "state.title"

-- Gui override
override = require "lib.quickie.style-bfrpg"

function love.load()
    math.randomseed(os.time())
    
    -- define screen
    screen = { 
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }
    
    -- load all fonts
    font = love.graphics.newFont("font/Linden Hill.otf", 20)
    textfont = love.graphics.newFont("font/Linden Hill Italic.otf", 20)
    titlefont = love.graphics.newFont("font/Linden Hill Italic.otf", 35)
    
    -- initiate gamestates
    Gamestate.registerEvents()
    Gamestate.switch(state_generation)
    
    -- gui setup defaults
    gui.group.default.size[1] = 150
    gui.group.default.size[2] = 25
    gui.group.default.spacing = 10
    gui.core.style = override
    
end


function love.update(dt)
    
end


function love.draw()
    
end
