
-- hump utilities http://vrld.github.io/hump/
Gamestate = require "libraries.hump.gamestate"
Class     = require "libraries.hump.class"

require "misc.helper"
require "misc.parser"

require "states.ingame"
require "states.title"


function love.load()
    
    math.randomseed(os.time())
    
    Gamestate.registerEvents()
    Gamestate.switch(state_ingame)
end


function love.update(dt)
    
end


function love.draw()
    
end
