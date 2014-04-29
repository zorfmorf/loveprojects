-- main.lua serves as an interface between the love2d engine and the
-- game code. All methods included in this file (so called 'callbacks')
-- are called by love2d depending on their functions. For further information
-- refer to the specific method heads 

require 'misc/constants'
require 'misc/slither'
require 'misc/helper'

require 'model/addon'
require 'model/background'
require 'model/challenge'
require 'model/lifeform'
require 'model/object'
require 'model/traderun'
require 'model/shipFactory'
require 'model/shipPart'
require 'model/ship'
require 'model/quadtree'

require 'view/drawHandler'
require 'view/screen'
require 'view/hud'
require 'view/loadScreen'

require 'controller/inputHandler'
require 'controller/loadHandler'
require 'controller/logicHandler'
require 'controller/runHandler'
require 'controller/soundHandler'
require 'controller/stateHandler'

-- love.load is called once on startup before all other code is launched
-- Everything that needs to be loaded on startup should be hooked here
function love.load()

    statehandler_init() -- define states
    loadHandler_loadImages() -- load all tilesets
    hud_init()
    screen_init()
		
    -- list of all objects currently flying around!
    entities = {}
    
	-- create player ship
    main_ship = shipFactory_buildTestShip()
    entities[main_ship.id] = main_ship
    main_ship.enginesActive = true
	
	-- define and place the actual player
	main_player = Lifeform("Player")
	main_player.x = 2
	main_player.y = 2
	main_ship:addLifeform(main_player)
	
	-- initiate the first traderun
	runHandler = RunHandler()
		
	statehandler_loading_finished() -- asset initiation finished
		
	-- initiate the game loading screen
	-- during the loading screen the background is generated
	loadScreen = LoadScreen()
	
	--set random seed
	math.randomseed(os.time())
end

-- love.update is called as often as possible. all game logic hooks here
-- @param dt the time in seconds since the method was last invoked. 
function love.update(dt)
    
	-- if we are ingame update all game related entities
	if GAME_STATE == "ingame" then
		inputHandler_update(dt)
		logicHandler_updateObjects(dt)
		logicHandler_checkCollisions()
		drawHandler_updateOffset()
		runHandler:update(dt)
		hud_update(dt)
	end
	
		-- if we are paused nothing really happens
	if GAME_STATE == "paused" then
		
	end
	
	-- if we are ingame update all game related entities
	if GAME_STATE == "end" then
		logicHandler_updateObjects(dt)
		logicHandler_checkCollisions()
		endScreen_update(dt)
	end
	
	-- if we are in the loading screen update the loading screen
	if GAME_STATE == "generating" then
	
		local tmp = runHandler.background:checkGeneration()
		
		if tmp < 2 then
			loadScreen.percentage = tmp
		else
			statehandler_generating_finished()
		end
	end
end

-- love.draw is called when the screen has to be redrawn. Every method that
-- draws to the screen hooks here
-- we make heavy use of the coordinate system transformation feature of
-- love2d. Everytime the player moves, zooms or rotates the camera we don't
-- adjust object positions (which would be the intuitive way to do this)
-- but we translate this into adjustments to the coordinate system.
-- This allows us to always use the normal object positions when drawing
-- and we don't get confused when we try to find out if ships collide or
-- stuff like that
function love.draw()
	
	-- if we are generating draw the loading bar
	if GAME_STATE == "generating" then
		loadScreen:draw()
	end
	
	-- if we are ingame draw the game
	if GAME_STATE == "ingame" or GAME_STATE == "paused" then
		
		-- draw the background nebula and stars
		runHandler.background:draw()
		
		-- save default coordinate system to stack
		love.graphics.push()
		
		-- apply scale and shift to coordinate system
		drawHandler_applyTransformations()
		
		-- BEGIN TEMP Draw outline around area visible to player
		--love.graphics.setColor(230, 150, 150, 255)
		--love.graphics.setLineWidth( 1 / scale )
		--love.graphics.rectangle("line", -2000, -2000, 4000, 4000)
		--love.graphics.setLineWidth( 1 )
		-- END TEMP
		
		-- draw all space objects
        for i,element in pairs(entities) do
            
            if isinstance(element, objects.Asteroid) then
            
                drawHandler_drawEntity(element)
                
            else
                
                drawHandler_drawShip(element)
                
            end
            
        end
        
        -- restore default coordinate system
		love.graphics.pop() 
		
		-- draw hud information
		hud_draw() 
	end
	
	-- pause screen draws not much
	if GAME_STATE == "paused" then
		screen_drawPaused()
	end
	
	-- if we are finished draw endscreen
	if GAME_STATE == "end" then
		runHandler.background:draw()
		love.graphics.push()
		drawHandler_applyTransformations()
		drawHandler_drawShip(main_ship) 
		love.graphics.pop()
		endScreen_draw()
	end
end

-- Called, whenever a keyboard key is pressed down
-- @param key ASCII value of key pressed
-- @param unicode Unicode value of key pressed
function love.keypressed(key, unicode)
    inputHandler_keyPressed(key, unicode)
end

-- Called, whenever a keyboard key is released
-- @param key ASCII value of key released
-- @param unicode Unicode value of key released
function love.keyreleased(key, unicode)
    inputHandler_keyReleased(key, unicode)
end

-- Called when a mouse button is pressed
-- @param x coordinate
-- @param y coordinate
-- @param button can be "l" "r" "m" "wd" "wu" "x1" "x2"
function love.mousepressed(x, y, button)
    inputHandler_mousePressed(x, y, button)
end

-- Called when a mouse button is released
-- @param x coordinate
-- @param y coordinate
-- @param button can be "l" "r" "m" "wd" "wu" "x1" "x2"
function love.mousereleased(x, y, button)
    inputHandler_mouseReleased(x, y, button)
end

-- love.quit is called once before the game quits. Backing up and saving
-- should be hooked here
function love.quit()

end
