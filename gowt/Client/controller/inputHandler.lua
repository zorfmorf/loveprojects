-- Handles player input

-- nil = key not currently pressed
-- !nil = coordinates of mouse last time position was updated
local leftMousePressed = false
local lastMousePosition = nil

-- Called when a mouse button is pressed
-- @param x coordinate
-- @param y coordinate
-- @param button can be "l" "r" "m" "wd" "wu" "x1" "x2"
function inputHandler_mousePressed(x, y, button)
	if PLAYER_STATE == "commanding" then
		if button == "l" and leftMousePressed == false then
			leftMousePressed = true
			lastMousePosition = { x, y }
		end
		
		if button == "r" then
			local xn, yn = drawHandler_convertScreenToWorld(x, y)
			gameLogicHandler_steerShip(main_ship, xn, yn)
		end
	end
end

-- Called when a mouse button is released
-- @param x coordinate
-- @param y coordinate
-- @param button can be "l" "r" "m" "wd" "wu" "x1" "x2"
function inputHandler_mouseReleased(x, y, button)
	if PLAYER_STATE == "commanding" then
		if button == "l" then
			leftMousePressed = false
			lastMousePosition = nil
		end
		if button == "wu" then
			drawHandler_zoomIn()
		end
		if button == "wd" then
			drawHandler_zoomOut()
		end
	end
end

-- Calleda once, whenever a keyboard key is pressed down
-- @param key ASCII value of key pressed
-- @param unicode Unicode value of key pressed
function inputHandler_keyPressed(key, unicode)
	
	if key == KEY_EXIT then
        love.event.quit()
	end
	
	if key == KEY_SWITCH_COMMAND then
		gameLogicHandler_switchCommand()
	end
    
    if key == KEY_DEVELOPER_MODE then
        DEVELOPER_MODE = (DEVELOPER_MODE ~= true)
    end
	
	if key == KEY_DRAW_QUADTREE then
		DRAW_QUADTREE = (DRAW_QUADTREE ~= true)
	end

	if PLAYER_STATE == "commanding" then
		if key == KEY_C_ZOOM_IN then
			drawHandler_zoomIn()
		end
		if key == KEY_C_ZOOM_OUT then
			drawHandler_zoomOut()
		end
		if key == KEY_C_ROT_LEFT then
			drawHandler_rotate(-0.2)
		end
		if key == KEY_C_ROT_RIGHT then
			drawHandler_rotate(0.2)
		end
		if key == KEY_C_UP then
			drawHandler_updateOffset(0, 100)
		end
		if key == KEY_C_DOWN then
			drawHandler_updateOffset(0, -100)
		end
		if key == KEY_C_RIGHT then
			drawHandler_updateOffset(-100, 0)
		end
		if key == KEY_C_LEFT then
			drawHandler_updateOffset(100, 0)
		end
		if key == KEY_C_PAUSE then
			if GAME_STATE == "ingame" then stateHandler_pause() else stateHandler_unpause() end
		end
		if key == KEY_C_TARGET_DELETE then
			ships[1].target = nil
		end

	end
	
	if PLAYER_STATE == "moving" then
		if key == KEY_M_UP and main_player.isMovingVertical == 0 then
			main_player.isMovingVertical = -1
			return
		end
		
		if key == KEY_M_DOWN and main_player.isMovingVertical == 0 then
			main_player.isMovingVertical = 1
			return
		end
		
		if key == KEY_M_LEFT and main_player.isMovingHorizontal == 0 then
			main_player.isMovingHorizontal = -1
			return
		end
		
		if key == KEY_M_RIGHT and main_player.isMovingHorizontal == 0 then
			main_player.isMovingHorizontal = 1
			return
		end
	end
end

-- Called, whenever a keyboard key is released
-- @param key ASCII value of key released
-- @param unicode Unicode value of key released
function inputHandler_keyReleased(key, unicode)
	if PLAYER_STATE == "moving" then
		if key == KEY_M_UP or key == KEY_M_DOWN then
			if love.keyboard.isDown(KEY_M_DOWN) then main_player.isMovingVertical = 1 return end
			if love.keyboard.isDown(KEY_M_UP) then main_player.isMovingVertical = -1 return end
			main_player.isMovingVertical = 0
		end
		if key == KEY_M_LEFT or key == KEY_M_RIGHT then
			if love.keyboard.isDown(KEY_M_LEFT) then main_player.isMovingHorizontal = -1 return end
			if love.keyboard.isDown(KEY_M_RIGHT) then main_player.isMovingHorizontal = 1 return end
			main_player.isMovingHorizontal = 0
		end
	end
end

-- Called as often as possible. Input related checks belong here
-- @param dt time in seconds since last time called
function inputHandler_update(dt)

    -- if the left mouse button is currently pressed, this means that
    -- the screen is currently dragged. Handle the event
    if leftMousePressed ~= nil and lastMousePosition ~= nil then
        drawHandler_updateOffset(love.mouse.getX() - lastMousePosition[1], 
                                love.mouse.getY() - lastMousePosition[2])
        lastMousePosition[1] = love.mouse.getX()
        lastMousePosition[2] = love.mouse.getY()
    end
end
