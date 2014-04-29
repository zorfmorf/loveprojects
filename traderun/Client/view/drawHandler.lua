-- This classed is tasked with drawing objects onto the screen
-- and handling the coordinate system


-- the next variables are used for keeping track of the current camera targets


scale = 1
camera_angle = 0 -- only used when player is steering pilot
offset = {0, 0} -- coordinates displayed at center of screen


-- calculates the draw position for a given ship and the index of the ship part.
-- used for both drawing of party and players
function drawHandler_calculateDrawPosition(ship, i, j) 
	local x = ship.x - TILE_SIZE * ship.size / 2 + (i-1) * TILE_SIZE + TILE_SIZE / 2
	local y = ship.y - TILE_SIZE * ship.size / 2 + (j-1) * TILE_SIZE + TILE_SIZE / 2
	
	local nx, ny = helper_rotatePointAroundPoint(x, y, ship.x, ship.y, ship.a)

	return nx, ny
end


-- Draw a ship. Take into account screen offset, zoom, position and orientation
-- @ship ship the ship to be drawn
function drawHandler_drawShip(ship)

	--local bounds = ship:getBounds()
	--love.graphics.rectangle("fill", bounds.x, bounds.y, bounds.width, bounds.height)
    
    --iterate over all ship parts
    for i,vi in pairs(ship.parts) do
        for j,currentPart in pairs(vi) do
		
			love.graphics.setColor(255, 255, 255, 255)
			
			local nx, ny = drawHandler_calculateDrawPosition(ship, j, i)
			
			-- first draw any thruster particles
			if ship.enginesActive 
				and isinstance(currentPart, part.Nozzle) 
				and ship.parts[currentPart.x][currentPart.y] ~= nil then
				
				
				local engine = ship.parts[currentPart.x][currentPart.y].addon
				engine.particles:setPosition(nx, ny - TILE_SIZE / 3)
				engine.particles:setDirection(ship.a + math.pi / 2)
				
				if engine:isFunctioning() then
					love.graphics.setBlendMode("additive")
					love.graphics.draw(engine.particles)	
				end
			end

			
			love.graphics.setBlendMode("alpha")	
			love.graphics.setDefaultImageFilter( "nearest", "nearest" )
			
			
			if currentPart.oxygen ~= nil then
				love.graphics.setColor(255, 155 + currentPart.oxygen, 155 + currentPart.oxygen, 255)
			end
			

			love.graphics.draw(currentPart.image, nx, ny, 
                                ship.a, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)
			
			if isinstance(currentPart, part.Floor) then
				
				for i=1,4 do
									
					if currentPart.door[i] == 2 then
						love.graphics.draw(doorClosedImage, nx, ny, 
                                ship.a + (math.pi / 2) * (i - 1), nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)
					end
					
				end
				
			end
			
			-- now draw the addons that have to be drawn on top
			if currentPart.addon ~= nil then
				love.graphics.draw(currentPart.addon.image, nx, ny, 
                                ship.a, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)
			end

        end
    end
    
    -- now draw all lifeforms
    love.graphics.setColor(255, 255, 255, 255)
    for i,lifeform in pairs(ship.lifeforms) do
			
			local x, y = drawHandler_calculateDrawPosition(ship, lifeform.x, lifeform.y)
			
			
			love.graphics.draw(tilesChar[lifeform.animCycle[math.floor(lifeform.animDT)]], x, y, lifeform.o, 1, 1, TILE_SIZE_CHAR / 2, TILE_SIZE_CHAR / 2)
			
			love.graphics.draw(tilesChar[1], x, y, lifeform.o, 1, 1, TILE_SIZE_CHAR / 2, TILE_SIZE_CHAR / 2)
    end
end

-- draw a generic entity
function drawHandler_drawEntity(entity)
	
	--if entity.collision then
	--love.graphics.setColor(255, 100, 100, 255)
	--end
	--local bounds = entity:getBounds()
	--love.graphics.rectangle("fill", bounds.x, bounds.y, bounds.width, bounds.height)
    
    love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(entity.visual, entity.x, entity.y, entity.a, 
															entity.size, entity.size, TILE_SIZE / 2, TILE_SIZE / 2)
	
	--print("Drew Asteroid at "..entity.x.."/"..entity.y.." with ID "..entity.id)
end

-- draw the listed effect
function drawHandler_drawEffect(effect)
	love.graphics.draw(effect.visual, effect.x, effect.y, 0, math.sin(effect.dt * math.pi), math.sin(effect.dt * math.pi), TILE_SIZE / 2, TILE_SIZE / 2)
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
function drawHandler_shiftOffset(x, y)
	-- adjust offset target
	offset[1] = offset[1] - x / scale
    offset[2] = offset[2] - y / scale
end


-- move camera to center on player
function drawHandler_updateOffset()
	
	local x, y = drawHandler_calculateDrawPosition(main_ship, main_player.x, main_player.y)
	
	offset[1] = x
	offset[2] = y
	
end

function drawHandler_rotate(value)
	camera_angle = camera_angle + value
end

-- zoom the visible screen in by one step
function drawHandler_zoomIn()
	scale = math.min(scale * 1.1, SCALE_MAX)
end

-- zoom the visible screen out by one step
function drawHandler_zoomOut()
	scale = math.max(scale * 0.9, SCALE_MIN)
end

-- convert on-screen coordinates to world coordinates
-- TODO: currently only works with camera_angle == 0
function drawHandler_convertScreenToWorld(x, y)
    return (x - love.graphics:getWidth() / 2) / scale + offset[1], (y - love.graphics:getHeight() / 2) / scale + offset[2]
end
