-- This classed is tasked with drawing objects onto the screen
-- and handling the coordinate system

-- list of all particles that need to be updated
particles = {}


-- the next variables are used for keeping track of the current camera targets

camera_switch_dt = CAMERA_SWITCH_TIME -- used to keep track of time elapsed since camera switched

scale = 1
scale_backup = scale
scale_target = scale

camera_angle = 0 -- only used when player is steering pilot
camera_angle_backup = camera_angle
camera_angle_target = camera_angle

offset = {0, 0} -- coordinates displayed at center of screen
offset_backup = {0, 0}
offset_target = {0, 0}


function drawHandler_addParticles(p)
	assert(p ~= nil)
	local i = 1
	while particles[i] ~= nil do
		i = i + 1
	end
	particles[i] = p
end

-- calculates the draw position for a given ship and the index of the ship part.
-- used for both drawing of party and players
function drawHandler_calculateDrawPosition(ship, i, j) 
	local x = ship.x + tileSize * (j - ship.size)
	local y = ship.y + tileSize * (i - ship.size)
	
	local nx, ny = helper_rotatePointAroundPoint(x, y, ship.x, ship.y, ship.a)

	return nx, ny
end

-- draw all the background action
function drawHandler_drawBackground()
    local wa = -math.max(love.graphics:getWidth(), love.graphics:getHeight()) / 2
    local ha = wa
    
    -- draw the nebula into the background first
	love.graphics.setColor(150, 200, 210, 200)
	love.graphics.draw(nebula, 0, 0)
	
	-- draw all the star layers, the one furthest is fixed, the others
	-- move with the camera in order to create a feeling of depth
	-- (although it makes no sense from a phsyics standpoint)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw( bkgStars[1], wa, ha)
	--love.graphics.draw( bkgStars[2], -offset[1] / 50 + wa, -offset[2] / 50 + ha)
	--love.graphics.draw( bkgStars[3], -offset[1] / 300 + wa, -offset[2] / 300 + ha)
end

-- Draw a ship. Take into account screen offset, zoom, position and orientation
-- @ship ship the ship to be drawn
function drawHandler_drawShip(ship)

	--local bounds = ship:getBounds()
	--love.graphics.rectangle("fill", bounds.x, bounds.y, bounds.width, bounds.height)
    
    --iterate over all ship parts
    for i,vi in pairs(ship.parts) do
        for j,part in pairs(vi) do
		
			love.graphics.setColor(255, 255, 255, 255)
			
			local nx, ny = drawHandler_calculateDrawPosition(ship, i, j)
			
			-- first draw any thruster particles
			if isinstance(part, parts.Nozzle) and ship.parts[part.x][part.y] ~= nil then
				local engine = ship.parts[part.x][part.y].addon
				engine.particles:setPosition(nx, ny)
				engine.particles:setDirection(ship.a + math.pi / 2)
				
				if ship.mainActive and engine:isFunctioning() then
					engine:setModus("thrust")
					love.graphics.setBlendMode("additive")
					love.graphics.draw(engine.particles)	
				end
			end
			
			-- if this is a side thruster and the ship has activated sidethrusters
			-- and this particular sidethruster is working and active, draw it's exhaust
			if part.addon ~= nil and isinstance(part.addon, addons.SideThruster) and ship.sideActive ~= 0 and part.addon:isFunctioning() then

				-- the angle by which to rotate the thruster exhaust. 
				-- 0 - centered
				-- 1 - rotated 90° clockwise
				-- -1 - rotated 90° counter-clockwise
				-- other values for angle are valid as well and lead to corresponding rotations
				local angle = -1 * ship.sideActive -- TODO: make more realistic
				love.graphics.draw(thrusterImage, nx, ny, ship.a + math.pi / 4 * (2 + angle + 2 * part.addon.graphic[2]), nil, nil, thrusterImage:getWidth() / 2, -tileSize / 5)
			end
			
			love.graphics.setBlendMode("alpha")	
			
			
			if part.oxygen ~= nil then
				love.graphics.setColor(255, 155 + part.oxygen, 155 + part.oxygen, 255)
			end
			
			-- first draw the addons that have to be drawn below
			if part.addon ~= nil and part.addon.drawBelow then
				love.graphics.draw(tiles[part.addon.graphic[1]], nx, ny, 
                                ship.a + part.addon.graphic[2] * math.pi / 2, nil, nil, tileSize / 2, tileSize / 2)
			end
			
			-- now draw all layers of the part
			for k = 1,table.getn(part.layers) / 2 do
				love.graphics.draw(tiles[part.layers[k * 2 - 1]], nx, ny, 
                                ship.a + part.layers[k * 2] * math.pi / 2, nil, nil, tileSize / 2, tileSize / 2)
			end
			
			-- now draw the addons that have to be drawn on top
			if part.addon ~= nil and part.addon.drawBelow == false then
			
				-- when it is an ai core
				if isinstance(part.addon, addons.AICore) then
					love.graphics.draw(tiles[part.addon.graphic[1]], nx, ny, 
                                ship.a + part.addon.graphic[2] * math.pi / 2 + part.addon.animation_cycle, nil, nil, tileSize / 2, tileSize / 2)
					love.graphics.draw(tiles[part.addon.graphic2[1]], nx, ny, 
                                ship.a + part.addon.graphic2[2] * math.pi / 2, nil, nil, tileSize / 2, tileSize / 2)
				
				else -- generic draw
					love.graphics.draw(tiles[part.addon.graphic[1]], nx, ny, 
                                ship.a + part.addon.graphic[2] * math.pi / 2, nil, nil, tileSize / 2, tileSize / 2)
				end
			end
			
			-- now draw all decals
			if part.decals ~= nil then
				-- TODO: implement
			end
        end
    end
	
	-- now that we have drawn the ship, we need to draw all the players
	love.graphics.setColor(255, 255, 255, 255)
	for i,player in pairs(ship.players) do
		local nx, ny = drawHandler_calculateDrawPosition(ship, player.position[1], player.position[2]) 		
		love.graphics.draw(tilesChar[1], nx, ny, ship.a + player.orientation, 1, 1, tileSizeChar / 2, tileSizeChar / 2)
	end
end

-- draw a generic entity
function drawHandler_drawEntity(entity)
	love.graphics.setColor(255, 255, 255, 255)
	--if entity.collision then
	--	love.graphics.setColor(255, 100, 100, 255)
	--end
	--local bounds = entity:getBounds()
	--love.graphics.rectangle("fill", bounds.x, bounds.y, bounds.width, bounds.height)
	love.graphics.draw(tiles[entity.visual[1]], entity.x, entity.y, entity.a + entity.visual[2] * math.pi / 2, 
															entity.size, entity.size, tileSize / 2, tileSize / 2)
end

-- draw the listed effect
function drawHandler_drawEffect(effect)
	love.graphics.draw(tiles[effect.visual[1]], effect.x, effect.y, 0, math.sin(effect.dt * math.pi), math.sin(effect.dt * math.pi), tileSize / 2, tileSize / 2)
end

-- apply camera position, zoom and rotation to the coordinate system
-- Now I only ever have to draw the ship at its actual position, the 
-- changes I made to the coordinate system here will adjust for the 
-- camera position
-- all changes to the coordinate system are lost when the current 
-- draw cycle has ended (which is good)
function drawHandler_applyTransformations()
	
	love.graphics.translate(love.graphics:getWidth() / 2, love.graphics:getHeight() / 2) -- move offset to center
	love.graphics.rotate(camera_angle)
	love.graphics.translate(-love.graphics:getWidth() / 2, -love.graphics:getHeight() / 2)
	love.graphics.translate(love.graphics:getWidth() / 2 - offset[1] * scale, 
                            love.graphics:getHeight() / 2 - offset[2] * scale)
	love.graphics.scale(scale, scale)
	
end

-- same as applyTransformation, but we only apply the camera rotation.
-- we need this in order to rotate the background without shifting or 
-- zooming it no matter where or how fast the player is moving
-- (because space is vast) 
function drawHandler_applyRotation()
    love.graphics.translate(love.graphics:getWidth() / 2, love.graphics:getHeight() / 2) -- move offset to center
    love.graphics.rotate(camera_angle)
    love.graphics.translate(-love.graphics:getWidth() / 2, -love.graphics:getHeight() / 2)
end


-- used to update the offset by which the displayed screen is shifted
-- (on startup, the 0,0 - coordinates are displayed on the screen center)
function drawHandler_updateOffset(x, y)
	-- adjust offset target
	offset_target[1] = offset_target[1] - x / scale
    offset_target[2] = offset_target[2] - y / scale
    
    -- make sure it's not too far away from the ship
    offset_target[1] = math.max(offset_target[1], main_ship.x - love.graphics:getWidth() / SCALE_MIN / 2)
    offset_target[1] = math.min(offset_target[1], main_ship.x + love.graphics:getWidth() / SCALE_MIN / 2)
    offset_target[2] = math.max(offset_target[2], main_ship.y - love.graphics:getHeight() / SCALE_MIN / 2)
    offset_target[2] = math.min(offset_target[2], main_ship.y + love.graphics:getHeight() / SCALE_MIN / 2)
end

-- saves the current camera settings
function drawHandler_switchCamera()
	local tmp = offset_backup
	offset_backup = offset_target
	offset_target = tmp
	
	tmp = scale_backup
	scale_backup = scale_target
	scale_target = tmp
	
	tmp = camera_angle_backup
	camera_angle_backup = camera_angle_target
	camera_angle_target = tmp
end

function drawHandler_rotate(value)
	camera_angle = camera_angle + value
end

-- zoom the visible screen in by one step
function drawHandler_zoomIn()
	scale_target = math.min(scale_target * 1.1, SCALE_MAX)
end

-- zoom the visible screen out by one step
function drawHandler_zoomOut()
	scale_target = math.max(scale_target * 0.9, SCALE_MIN)
end

-- convert on-screen coordinates to world coordinates
-- TODO: currently only works with camera_angle == 0
function drawHandler_convertScreenToWorld(x, y)
    return (x - love.graphics:getWidth() / 2) / scale + offset[1], (y - love.graphics:getHeight() / 2) / scale + offset[2]
end
