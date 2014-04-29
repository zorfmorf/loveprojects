-- the hud handles all hud elements

local pBarX, pBarY, pBarW, pBarH = 0

local devFont, hudFont, specialFont = nil

local devInfo = nil

local dangertimer = 0 -- used to modify danger warner text dynamically (size, color)

-- simple init function
function hud_init()
	pBarW = math.floor(love.graphics:getWidth() / 6)
	pBarH = math.floor(love.graphics:getHeight() / 30)
	pBarX = math.floor(love.graphics:getWidth() - pBarW - pBarH / 2)
	pBarY = math.floor(pBarH / 2)
	
	devFont = love.graphics.newFont(15)
    specialFont = love.graphics.newFont( "res/fonts/beon/Beon-Regular.otf", 30 )
    
    devInfo = {}
end


-- draw Hud
function hud_draw()

    -- the run progress bar
	local perc = runHandler.traderun.travelled / runHandler.traderun.distance
	love.graphics.setColor(192, 232, 239, 255)
	love.graphics.rectangle( "fill", pBarX, pBarY, pBarW * perc, pBarH )
	love.graphics.rectangle( "line", pBarX, pBarY, pBarW, pBarH )
    
    -- run warning
    
    local c = runHandler.traderun:getCurrentChallenge()
    if c ~= nil then
		local message = "Danger: "..c.name
		love.graphics.setFont(specialFont)
		local v = math.abs(math.sin(dangertimer * 2))
		local s = 1 + v / 5
		love.graphics.setColor(160 + v * 90, 160, 160, 255)
        love.graphics.print(message, love.graphics:getWidth() / 2, 30, 0, s, s, specialFont:getWidth(message) / 2, specialFont:getHeight() / 2)
    else
		dangertimer = 0
    end
    
    -- draw developer information
    if DEVELOPER_MODE then
		
		love.graphics.setFont(devFont)
		love.graphics.setColor(255, 255, 255, 255)
		
		local shift = 20
		
		for i,element in pairs(devInfo) do
		
			love.graphics.print(i..": "..element, 20, shift)
			shift = shift + 20
		
		end
		
	end
end


-- update Hud elements
function hud_update(dt)

	dangertimer = dangertimer + dt
	
	-- update developer information
	if DEVELOPER_MODE then
		devInfo["FPS"] = love.timer.getFPS()
		devInfo["Delta"] = love.timer.getFPS()
		devInfo["scale"] = scale
		devInfo["ent act"] = table.getn(entities)
		devInfo["ent sur"] = table.getn(runHandler.traderun.encountered)
	end
	
end
