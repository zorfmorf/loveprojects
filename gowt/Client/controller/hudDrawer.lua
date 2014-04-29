-- All draw methods regarding the HUD belong here

-- the font used for displaying developer information (FPS, coordinates, etc)
local devFont = nil
local hudFont = nil

devInfo = {}
local playerInfo = {}

-- initialize stuff needed for the hudDrawer to function (such as fonts)
function hudDrawer_init()
    devFont = love.graphics.newFont(15)
	hudFont = love.graphics.newFont( "res/fonts/beon/Beon-Regular.otf", 25 )
	hud_marker = {}
end



-- add a new marker to the HUD
-- @param type, x, y	string, world coordinates
-- "move" -- the point the ship currently moves to
function hudDrawer_addMarker(markerType, x, y) 
	hud_marker[markerType] = {"generic", x, y, 10}
end


function hudDrawer_update(dt)
	
	if hud_marker["move"] ~= nil then
        if main_ship.target ==  nil then
            hud_marker["move"] = nil
            return
        end
		local value = hud_marker["move"][4] + dt * 15
		if value > 25 then
			value = 1
		end
		hud_marker["move"][4] = value
	end
	
	if PLAYER_STATE == "moving" then
		playerInfo[1] = {"Health", (main_player.health / main_player.max_health) * 100}
		if main_player.suit ~= nil then
			playerInfo[3] = {"State", (main_player.suit.oxygen / 100 ) * main_player.suit.oxygen_max}
			playerInfo[4] = {"Energy", (main_player.suit.energy / 100) * main_player.suit.energy_max}
			playerInfo[5] = {"Oxygen", (main_player.suit.state / 100) * main_player.suit.state_max}
		end
	end
	
    if DEVELOPER_MODE then
        devInfo["FPS"] = love.timer:getFPS()
        devInfo["AVG DT"] = round(DT_AVG, 4)
        devInfo["Scale"] = round(scale_target, 3)
        devInfo["Orientation"] = round(main_ship.a, 2)
        devInfo["Rotation"] = round(main_ship.r, 2)
		devInfo["PlayerPos"] = round(main_player.position[1], 1).."/"..round(main_player.position[2], 1)
        devInfo["Velocities"] = round(main_ship.xm, 2).."/"..round(main_ship.ym, 2)
        if main_ship.target == nil then 
            devInfo["Target distance"] = "N/A"
        else
            devInfo["Target distance"] = math.floor(math.sqrt(math.pow(main_ship.x - main_ship.target[1], 2) + math.pow(main_ship.y - main_ship.target[2], 2)))
        end
    end
end

-- draw the hud elements that belong to the given ship (atm the target)
function hudDrawer_drawHUDElements(ship)
	for i,element in pairs(hud_marker) do
		if element[1] == "generic" then
			love.graphics.setColor(107, 157, 250, 255)
            love.graphics.setLineWidth(2/scale)
			love.graphics.circle("line", element[2], element[3], element[4] / scale)
			love.graphics.circle("line", element[2], element[3], 4 / scale)
			love.graphics.line(ship.x, ship.y, element[2], ship.y)
			love.graphics.line(element[2], ship.y, element[2], element[3])
		end
	end
	
	--now draw a line to all objects in the same layer (collision warnings)
	love.graphics.setColor(250, 157, 100, 255)
    love.graphics.setLineWidth(2/scale)
	for i,element in pairs(layers[LAYER_SHIP]) do
		if element.id ~= ship.id then
			local dist = math.sqrt(math.pow(ship.x - element.x, 2) + math.pow(ship.y - element.y, 2))
			if dist < 5000 then
				love.graphics.line(ship.x, ship.y, element.x, element.y)
			end
			love.graphics.circle("line", element.x, element.y, math.max(element.size * tileSize, 60))
		end
	end
end

function hudDrawer_drawPlayerHUD(player)
	love.graphics.setFont(hudFont)
	local barlength = love.graphics:getWidth() / 8
	local barstart = love.graphics:getWidth() - barlength
	local barheight = hudFont:getHeight( )
	for i,element in pairs(playerInfo) do
		love.graphics.setColor(200 - element[2], 63 + element[2] , 100 + element[2], 100 + element[2])
		love.graphics.rectangle( "fill", barstart, 5 + (i - 1) * (barheight + 5), ((barlength - 5) / 100) * element[2], barheight )
		love.graphics.setColor(100, 163, 227, 255)
		love.graphics.print(element[1], (barstart - 10) - hudFont:getWidth(element[1]), 5 + (i - 1) * (barheight + 5))
		--love.graphics.rectangle( "line", barstart, 5 + (i - 1) * (barheight + 5), barlength - 5, barheight )
	end
end


-- draw developer information onto the screen
function hudDrawer_drawDevInfo()
    love.graphics.setFont(devFont)
    love.graphics.setColor(255, 255, 255, 255)
    local thresh = 10
    for i,element in pairs(devInfo) do
        love.graphics.print(i..": "..element, 10, thresh)
        thresh = thresh + 20
    end
end
