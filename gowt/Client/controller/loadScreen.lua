-- The LoadScreen is tasked with loading specific game assets
-- that take a while to load (mainly generating backgrounds). 
-- Because this takes a while the loadscreen therefore displays
-- a loading bar until the operations are finished

local barPercentage = 0
local barWidth = 0
local barHeight = 0
local barX = 0
local barY = 0
local nebulator = love.thread.newThread('thread','misc/nebulator.lua')
local self_state = "idle"


-- init vars and start the nebulator thread
function loadScreen_init()
	self_state = "running"
	
	barHeight = love.graphics:getHeight() * 0.1
	barWidth = love.graphics:getWidth() * 0.8
	barX = love.graphics:getWidth() * 0.1
	barY = love.graphics:getHeight() /  2 - barHeight / 2
	
	local t = math.max(love.graphics:getWidth(), love.graphics:getHeight()) * 2
	nebulator:set('w', love.graphics:getWidth())
	nebulator:set('h', love.graphics:getHeight())
	nebulator:set('id', math.random(1, 1000000))
	nebulator:start()
end

-- update the progress bar depending on the thread progress
-- if thread is finished initate actual game start
function loadScreen_update()
	if self_state == "running" then
		if nebulator:get('done') then
			self_state = "idle"
			barPercentage = 1
			spaceHandler_createBkg(nebulator:get('data'))
			gameLogicHandler_init()
			soundHandler_init()
			statemachine_generating_finished()
		else
			local p = nebulator:get('percentage')
			if p ~= nil then
				barPercentage = p
			end
		end
	end
end

-- draw the progress bar
function loadScreen_draw()
	love.graphics.setColor(150, 200, 220, 255)
	love.graphics.rectangle( "line", barX, barY, barWidth, barHeight )
    love.graphics.setColor(150, 200, 220, 255 * barPercentage)
	love.graphics.rectangle( "fill", barX, barY, barWidth * barPercentage, barHeight )
end
