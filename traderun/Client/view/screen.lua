-- Screen to display differnt stuff

local font = nil
local dTime = 0
local message = "N/A"
local pm = "paused"

-- init function
function screen_init()
	font = love.graphics.newFont( "res/fonts/beon/Beon-Regular.otf", 100 )
end


-- evaluate the given traderun
function endScreen_evaluate(state)
	if state == "finished" then message = "YOU WIN" else message = "GAME OVER" end
end


-- update function
function endScreen_update(dt)
	dTime = dTime + dt / 5
end


-- draw end screen
function endScreen_draw(dt)
	
	-- fade screen
	love.graphics.setColor(0, 0, 0, math.floor(255 * math.min(1, dTime)))
	love.graphics.rectangle( "fill", 0, 0, love.graphics:getWidth(), love.graphics:getHeight() )
	
	-- print message
	love.graphics.setColor(192, 232, 239, 255)
	love.graphics.setFont(font)
	love.graphics.print( message, love.graphics:getWidth()  / 2, love.graphics:getHeight() / 2, 0,
								1 + math.sin(dTime * 10) * 0.2, 1 + math.sin(dTime * 10) * 0.2, 
								font:getWidth( message ) / 2, font:getHeight() / 2)
end

-- draw pause screen
function screen_drawPaused()
	-- fade screen
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle( "fill", 0, 0, love.graphics:getWidth(), love.graphics:getHeight() )
		
	-- print message
	love.graphics.setColor(192, 232, 239, 255)
	love.graphics.setFont(font)
	love.graphics.print( pm, love.graphics:getWidth()  / 2, love.graphics:getHeight() / 2, 0,
								1, 1, font:getWidth( pm ) / 2, font:getHeight() / 2)
end
