
class = require 'lib/30logclean'
require 'lib/postshader'
require 'lib/light'
require 'lib/misc'

require 'model/layer'
require 'model/structure'
require 'model/ressource' -- to be loaded after structure
require 'model/tile'
require 'model/task'
require 'model/world'
require 'model/villager'

require 'handler/audioHandler'
require 'handler/gameHandler'
require 'handler/inputHandler'
require 'handler/ressourceHandler'
require 'handler/taskHandler'
require 'handler/questHandler'

require 'view/worldDrawer'
require 'view/hudDrawer'
require 'view/loadScreen'

DEBUG = true -- if true, villagers work faster

function love.load()
    
    -- debugger
    --if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    math.randomseed(os.time())
    
    state = "loading"
    
    ressourceHandler_loadTiles()
    gameHandler.init(3) -- param is size of world
    taskHandler.init()
    worldDrawer.init()
    loadScreen_init()
    questHandler_init()
    audioHandler.init()
end

function love.update(dt)
    
    if state == "loading" then
        loadScreen_update(dt)
    end
    
    if state == "ingame" then
        gameHandler.update(dt)
        taskHandler.update(dt)
        worldDrawer.update(dt)
    end
    
    inputHandler_update(dt)
end

function love.draw()
    
    if state == "loading" then
        loadScreen_draw()
    end
    
    if state == "ingame" then
        worldDrawer.draw()
        hudDrawer.draw()
    end
    
end

function love.keypressed(key, isrepeat)
   
    inputHandler_keypressed(key, isrepeat)
   
end

function love.keyreleased(key, isrepeat)
    
    inputHandler_keyreleased(key, isrepeat)
    
end

function love.mousepressed( x, y, button )
    inputHandler_mousepressed( x, y, button )
end

function love.mousereleased( x, y, button )
    inputHandler_mousereleased( x, y, button )
end
