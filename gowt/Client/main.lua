-- main.lua serves as an interface between the love2d engine and the
-- game code. All methods included in this file (so called 'callbacks')
-- are called by love2d depending on their functions. For further information
-- refer to the specific method heads 

require 'misc/constants'
require 'misc/slither'
require 'misc/helper'

require 'controller/ai'
require 'model/quadtree'
require 'controller/loadScreen'
require 'controller/gameLogicHandler'
require 'controller/gameUpdater'
require 'controller/hudDrawer'
require 'controller/inputHandler'
require 'controller/loader'
require 'controller/drawHandler'
require 'controller/soundHandler'
require 'controller/stateMachine'
require 'controller/spaceHandler'
require 'model/object'
require 'model/addon'
require 'model/decal'
require 'model/effect'
require 'model/player'
require 'model/ship'
require 'model/shipFactory'
require 'model/shipParts'
require 'model/spacesuit'

-- love.load is called once on startup before all other code is launched
-- Everything that needs to be loaded on startup should be hooked here
function love.load()

    statemachine_init() -- define states
    loader_loadImages() -- load all tilesets
	
    hudDrawer_init() -- init the hud
	
	-- create player ship
    main_ship = shipFactory_buildTestShip()
	
	-- define and place the actual player
	main_player = Player(2, 3)
	main_player.suit = Spacesuit(self, 25, 100, 44, 100, 98, 100)
	main_ship:addPlayer(main_player)
	
	 -- initiate a space area where all your action will happen
	spaceHandler_init()
	
	effects = {} -- create effects array (mainly used for engine exhaust)
	
	statemachine_loading_finished() -- asset initiation finished
		
	-- initiate the game loading screen
	-- during the loading screen the background is generated
	loadScreen_init()
	
	--set random seed
	math.randomseed(os.time())
end

-- love.update is called as often as possible. all game logic hooks here
-- @param dt the time in seconds since the method was last invoked. 
function love.update(dt)
    
    -- measure the average time between updates (for debug purposes)
	if DT_AVG == nil then DT_AVG = dt end
	DT_AVG = 0.9 * DT_AVG + 0.1 * dt 
	
	-- if we are ingame update all game related entities
	if GAME_STATE == "ingame" then
		gameUpdater_updateEntities(dt)
		gameUpdater_updateCamera(dt)
		gameLogicHandler_collisionDetect()
		inputHandler_update(dt)
		hudDrawer_update(dt)
	end
	
	-- if we are in the loading screen update the loading screen
	if GAME_STATE == "generating" then
		loadScreen_update()
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
		loadScreen_draw()
	end
	
	-- if we are ingame draw the game
	if GAME_STATE == "ingame" then
	
		-- first save the current coordinate system (the default one) by 
		-- pushing it on the transformation stack, adjust for the camera rotation
		-- only, draw the background and restore our original coordinate system
		love.graphics.push()
		drawHandler_applyRotation()
		drawHandler_drawBackground()
		love.graphics.pop()

		-- again, save the coordinate system but now apply all camera transformations
		love.graphics.push()
		drawHandler_applyTransformations()
		
		-- if in command mode, we need to draw all hud elements for the ship
		-- (e.g. waypoints and collision warnings)
		if PLAYER_STATE == "commanding" then hudDrawer_drawHUDElements(main_ship) end
		
		-- draw the quadtree if enabled (debug feature)
		if DRAW_QUADTREE then
			love.graphics.setLineWidth(2/scale)
			for i=1,LAYER_SIZE do
				love.graphics.setColor(0 + i * 40, 255 - i * 40, 100 + i * 20, 255)
				quads[i]:draw() 
			end
		end
		
		-- draw all objects for all layers
		for m=1,LAYER_SIZE do
			for i,entity in pairs(layers[m]) do
				if isinstance(entity, objects.Ship) then
					drawHandler_drawShip(entity)
				else
					drawHandler_drawEntity(entity)
				end
			end
		end
		
		-- draw any effects
		for i,effect in pairs(effects) do
			drawHandler_drawEffect(effect)
		end
		
		-- restore the original coordinate system
		love.graphics.pop()
		
		
		-- now draw the player hud which (of course) should not be influenced
		-- by the camera position and is always drawn at the same screen positions
		if PLAYER_STATE == "moving" then
			hudDrawer_drawPlayerHUD(main_player)
		end
		
		-- if debug mode is enabled draw some debug information
		if DEVELOPER_MODE then
			hudDrawer_drawDevInfo()
		end
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
