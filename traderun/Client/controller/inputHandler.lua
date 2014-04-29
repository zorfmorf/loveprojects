-- Handles player input


-- Called when a mouse button is pressed
-- @param x coordinate
-- @param y coordinate
-- @param button can be "l" "r" "m" "wd" "wu" "x1" "x2"
function inputHandler_mousePressed(x, y, button)

	if button == "l" then

	end
	
end

-- Called when a mouse button is released
-- @param x coordinate
-- @param y coordinate
-- @param button can be "l" "r" "m" "wd" "wu" "x1" "x2"
function inputHandler_mouseReleased(x, y, button)
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

-- Calleda once, whenever a keyboard key is pressed down
-- @param key ASCII value of key pressed
-- @param unicode Unicode value of key pressed
function inputHandler_keyPressed(key, unicode)
	
	if key == KEY_EXIT then
        love.event.quit()
	end
	
	if GAME_STATE == "ingame" then
	
		if key == KEY_C_ZOOM_IN then
			drawHandler_zoomIn()
		end
		if key == KEY_C_ZOOM_OUT then
			drawHandler_zoomOut()
		end
		
		-- player movement
		if key == KEY_M_USE then
			
		end
		if key == KEY_M_FORWARD then
			main_player.speed = HUMAN_SPEED_FORWARD
		end
		if key == KEY_M_BACKWARD then
			main_player.speed = HUMAN_SPEED_BACKWARD
		end
		if key == KEY_M_STRAFE_LEFT then
			main_player.strafe = -1
		end
		if key == KEY_M_STRAFE_RIGHT then
			main_player.strafe = 1
		end
	end
	
	if key == KEY_C_PAUSE then
		if GAME_STATE == "paused" then statehandler_unpause() return end
		if GAME_STATE == "ingame" then statehandler_pause() return end
	end
	
end

-- Called, whenever a keyboard key is released
-- @param key ASCII value of key released
-- @param unicode Unicode value of key released
function inputHandler_keyReleased(key, unicode)
		
		if GAME_STATE == "ingame" then
		
			-- player movement
			if key == KEY_M_USE then
				
			end
			if key == KEY_M_FORWARD or key == KEY_M_BACKWARD then
				main_player.speed = 0
				if love.keyboard.isDown( KEY_M_FORWARD ) then main_player.speed = HUMAN_SPEED_FORWARD end
				if love.keyboard.isDown( KEY_M_BACKWARD ) then main_player.speed = HUMAN_SPEED_BACKWARD end
			end
			if key == KEY_M_STRAFE_LEFT or key == KEY_M_STRAFE_RIGHT then
				main_player.strafe = 0
				if love.keyboard.isDown( KEY_M_STRAFE_LEFT ) then main_player.speed = -1 end
				if love.keyboard.isDown( KEY_M_STRAFE_RIGHT ) then main_player.speed = 1 end
			end
			
		end
end

-- Called as often as possible. Input related checks belong here
-- @param dt time in seconds since last time called
function inputHandler_update(dt)
    
    
end
