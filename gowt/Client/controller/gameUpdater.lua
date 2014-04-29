-- The GameUpdater updates game assets periodically
-- mainly tasked with keeping everything moving 

-- update position and orientation for all ships
function gameUpdater_updateEntities(dt)

	-- update particle effect
	for i,effect in pairs(effects) do
		effect.dt = effect.dt - dt
		if effect.dt <= 0 then
			effects[i] = nil
		end
	end
	

	-- update particle effect
	for i,vi in pairs(particles) do
		vi:start()
		vi:update(dt)
	end

	-- update ship movement and rotation values and allow ship to update itself
	for m=1,LAYER_SIZE do
		for i,entity in pairs(layers[m]) do
			entity.collisionsChecked = false
			entity.collision = false
		
			-- if the current entity is a ship we do need to make a lot of ship specific calculations
			if isinstance(entity, objects.Ship) then
				-- main Engine
				local speed = math.abs(entity.xm) + math.abs(entity.ym)
				
				if entity.mainActive then -- if engines are active
					local force = entity.mainThrust / entity.partCount
					
					local speedfactor = 1 - speed / SHIP_MAXSPEED
					local factor = math.sin(entity.a)
					
					entity.xm = entity.xm + math.sin(entity.a) * force * speedfactor * dt
					entity.ym = entity.ym - math.cos(entity.a) * force * speedfactor * dt
				end
					-- decelerrate naturally
				entity.xm = entity.xm * (1 - dt * entity.partCount * OBJECT_DECELERATION_FACTOR)
				entity.ym = entity.ym * (1 - dt * entity.partCount * OBJECT_DECELERATION_FACTOR)

				
				-- side Engine
				if  entity.sideActive ~= 0 then
					entity.r = entity.sideActive * entity.sideThrust * dt + entity.r
				end
				entity.r = entity.r * (1 - dt * entity.partCount * OBJECT_DECELERATION_FACTOR)
				
				entity.sideCD = math.max(entity.sideCD - dt, 0)

				-- now let the entity update any internal stuff
				entity:update(dt)
				
				
				-- now update all players on that entity
				for k,player in pairs(entity.players) do
					-- if walking mode update the player model to look into the direction of the mouse pointer 
					if PLAYER_STATE == "moving" then
						local px, py = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
						local x, y = love.mouse.getPosition()
						player.orientation = -math.atan2(px - x, py - y)
					end
				
					-- now update position if he is moving
					if player.isMovingHorizontal ~= 0 or player.isMovingVertical ~= 0 then
						local t1 = player.speed * player.isMovingVertical * dt
						local t2 = player.speed * player.isMovingHorizontal * dt
						
						local xCollision = PLAYER_COLLISION_SLOW -- 1 means no collision
						local yCollision = PLAYER_COLLISION_SLOW -- 1 means no collision
						
						-- calculate collision
						local index1 = round(player.position[1] + t1 + player.isMovingVertical * PLAYER_COLLISION_THRESHOLD, 0)
						local index2 = round(player.position[2], 0)
						if entity.parts[index1] ~= nil and entity.parts[index1][index2] ~= nil then
							if entity.parts[index1][index2].isWalkable then
								yCollision = 1
							end
						end
						
						index1 = round(player.position[1], 0)
						index2 = round(player.position[2] + t2 + player.isMovingHorizontal * PLAYER_COLLISION_THRESHOLD, 0)
						if entity.parts[index1] ~= nil and entity.parts[index1][index2] ~= nil then
							if entity.parts[index1][index2].isWalkable then
								xCollision = 1
							end
						end
						
						-- finally apply the movement. No movement in collision direction, half movement if other direction collides
						if yCollision == 1 then player.position[1] = player.position[1] + t1 * xCollision end
						if xCollision == 1 then player.position[2] = player.position[2] + t2 * yCollision end
					end
				end
			end
			
			-- now update entity position
			entity.a = entity.a + entity.r * dt
			if entity.a > math.pi then
				entity.a = entity.a - math.pi * 2
			end
			if entity.a < -math.pi then
				entity.a = entity.a + math.pi * 2
			end
			entity.x = entity.x + entity.xm * dt
			entity.y = entity.y + entity.ym * dt
			
			-- now if it is an asteroid check if it too far away from the ship
			-- in this case we put it at the opposite end of the universe :D
			if isinstance(entity, objects.Ship) == false then
				local width = love.graphics:getWidth() / SCALE_MIN
				local height = love.graphics:getHeight() / SCALE_MIN
				
				if entity.x > main_ship.x + width then
					entity.x = entity.x - width * 2
				end
				
				if entity.x < main_ship.x - width then
					entity.x = entity.x + width * 2
				end
				
				if entity.y > main_ship.y + height then
					entity.y = entity.y - height * 2
				end 
				
				if entity.y < main_ship.y - height then
					entity.y = entity.y + height * 2
				end 
			end
			
			-- Let the entity update itself in the quadtree
			if entity.leaf ~= nil then
				entity.leaf:check(entity)
			else
				quads[m]:insert(entity)
			end
		end
	end
end

-- returns the value between value1 and value2 depending on factor
-- factor <= 0 returns value1
-- factor >= 1 returns value2
-- factor 0.3 returns value1 + 0.3 * math.diff(value1, value2)
local function getValueBetween(value1, value2, factor)
	if factor <= 0 then return value1 end
	if factor >= 1 then return value2 end
	
	local diff = math.abs(value2 - value1)
	if value1 > value2 then 
		return value1 - diff * factor
	else
		return value1 + diff * factor
	end
end


-- update the camera.
-- basically we want to move the camera to the coordinates/scale/rotation
-- defined in the target parameters (see drawHandler)
function gameUpdater_updateCamera(dt)
	
	-- update target information if necessary
	if PLAYER_STATE == "moving" then
		local x, y = drawHandler_calculateDrawPosition(main_ship, main_player.position[1], main_player.position[2])
		scale_target = CAMERA_PLAYER_MOVING_SCALE
		camera_angle_target = -main_ship.a
		offset_target = {x, y}
	end
			
	local dt_to_use = camera_switch_dt * 2
	if dt_to_use >= 1 then dt_to_use = dt_to_use - 1 end
	local factor = (math.sin((dt_to_use - 0.5) * math.pi) * 0.5 + 0.5)
	
	if camera_switch_dt < CAMERA_SWITCH_TIME / 2 then
		if PLAYER_STATE == "moving" then
			offset[1] = getValueBetween(offset_backup[1], offset_target[1], factor)
			offset[2] = getValueBetween(offset_backup[2], offset_target[2], factor)
		else
			scale = getValueBetween(scale_backup, scale_target, math.max(factor - 0.5, 0) * 2)
			camera_angle = getValueBetween(camera_angle_backup, camera_angle_target, factor)
		end
	else
		if PLAYER_STATE == "moving" then
			offset[1] = offset_target[1]
			offset[2] = offset_target[2]
			scale = getValueBetween(scale_backup, scale_target, math.max(factor - 0.5, 0) * 2)
			camera_angle = getValueBetween(camera_angle_backup, camera_angle_target, factor)
		else
			scale = scale_target
			camera_angle = camera_angle_target
			offset[1] = getValueBetween(offset_backup[1], offset_target[1], factor)
			offset[2] = getValueBetween(offset_backup[2], offset_target[2], factor)
		end
	end
	
	if camera_switch_dt < CAMERA_SWITCH_TIME then
		camera_switch_dt = math.min(camera_switch_dt + dt, CAMERA_SWITCH_TIME)
	end
end
