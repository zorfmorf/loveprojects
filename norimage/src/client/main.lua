corepath = '../core/' -- CHANGE FOR DISTRIBUTION

-- Require core
package.path =  corepath .. "?.lua;" .. package.path
class = require 'misc/30logclean'
require 'actor'
require 'case'
require 'conversation'
require 'hint'
require 'item'
require 'location'
require 'requirement'
require 'solution'


-- Require client files
require 'handler/loadHandler'
require 'handler/audioHandler'
require 'views/credits'
require 'views/evidenceboard'


-- Load
function love.load(arg)
    
    -- enable debugger
--    if arg[#arg] == "-debug" then require("mobdebug").start() end

    load_Music()
    load_Images()
    load_Fonts()
    load_Colors()
    
    credits_init()
    board_init()
    
    state = "board"
end


-- update
function love.update(dt)
    
    if state == "credits" then
        credits_update(dt)
    end
    
    if state == "board" then
        board_update(dt)
    end
    
end


-- draw
function love.draw()
    
    if state == "credits" then
        credits_draw()
    end
    
    if state == "board" then
        board_draw()
    end
    
end

