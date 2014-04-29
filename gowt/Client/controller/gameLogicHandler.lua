-- this file contains callbacks that handle all game logic used for specific events
-- This can be player actions, object collisions, timer events, etc

local tc = 0 -- the amount of time needed to calculate collisions

-- collision between ship and entity
local function resolveShipCollision(m, ship, entity)

	local bounds = entity:getBounds()
	
	-- first we rotate the entity around the ship
	local x,y = helper_rotatePointAroundPoint(entity.x, entity.y, ship.x, ship.y, -ship.a)
	
	for i=-1,1 do
		for j=-1,1 do
			-- now check which part we hit
			local iy = round((y - ship.y) / tileSize + ship.size + i * SHIP_COLLISION_FACTOR, 0)
			local ix = round((x - ship.x) / tileSize + ship.size + j * SHIP_COLLISION_FACTOR, 0)
			
			-- if the index of the part is valid
			if iy >= 1 and iy <= ship.size * 2 and ix >= 1 and ix <= ship.size * 2 then
				
				-- if the part is not empty we have a collision
				if ship.parts[iy] ~= nil and ship.parts[iy][ix] ~= nil then
				
					local destroyed = ship.parts[iy][ix]:takeDmg(100)
					if destroyed then
					
						-- check if the part is walkable
						local walkable = ship.parts[iy][ix].isWalkable
						
                        -- destroy the specific shippart
						ship.parts[iy][ix] = nil
						
						-- if it is a walkable part we need to handle additional shit
						if walkable then
						 
							-- index modifiers for accessing adjacent parts
							local array = { {-1, 0, "s"}, {1, 0, "n"}, {0, -1, "w"}, {1, 0, "e"}}
							
							-- now check if adjacent parts have an opening to this position
							for m=1,4 do
								
								if ship.parts[iy + array[m][1]] ~= nil and ship.parts[iy + array[m][1]][ix + array[m][2]] ~= nil then
									if ship.parts[iy + array[m][1]][ix + array[m][2]].isWalkable and
										ship.parts[iy + array[m][1]][ix + array[m][2]]:hasWall(array[m][3]) == false then
										ship.parts[iy + array[m][1]][ix + array[m][2]].closed = false
									end
								end
								
							end
						end
						
					end

					table.insert(effects, Explosion(entity.x, entity.y))
					
					spaceHandler_asteroidDestroyed(m, entity)
					return
				end
			end
		end
	end
end

-- if the quadtree detects a possible collision, this method reviews it
local function resolveCollision(m, entityA, entityB)
	
	-- check involved ships
	local aIsShip = isinstance(entityA, objects.Ship)
	local bIsShip = isinstance(entityB, objects.Ship)
	
	-- if one entity is a ship and the other one is, resolve the ship collision
	if  aIsShip and bIsShip == false then
		resolveShipCollision(m, entityA, entityB)
	elseif bIsShip and aIsShip == false then
		resolveShipCollision(m, entityB, entityA)
	else
		-- atm both entities are asteroids. and atm asteroids explode on collision.
		-- so there is that
		
		-- first retrieve the bounds for convenience
		local boundsA = entityA:getBounds()
		local boundsB = entityB:getBounds()
		
		-- calculate x collision
		if boundsA.x <= boundsB.x + boundsB.width * COLLISION_THRESHOLD and boundsA.x + boundsA.width * COLLISION_THRESHOLD >= boundsB.x then
			-- calculate y collision
			if boundsA.y <= boundsB.y + boundsB.height * COLLISION_THRESHOLD and boundsA.y + boundsA.height * COLLISION_THRESHOLD >= boundsB.y then
			
				-- okay this is definitely a collision. add an explosion between the asteroids
				local x = boundsA.x + tileSize / 2 + ((boundsB.x + tileSize / 2) - (boundsA.x + tileSize / 2)) / 2
				local y = boundsA.y + tileSize / 2 + ((boundsB.y + tileSize / 2) - (boundsA.y + tileSize / 2)) / 2
				table.insert(effects, Explosion(x, y))
				
				spaceHandler_asteroidDestroyed(m, entityA)
				spaceHandler_asteroidDestroyed(m, entityB)
			end
		end
	end
end

function gameLogicHandler_init()
	-- we have one quadtree for every ship layer
	quads = {}
	for m=1,LAYER_SIZE do
		quads[m] = Quadtree(0, Bounds(-1000000, -1000000, 2000000, 2000000))
		for i,element in pairs(layers[m]) do
			quads[m]:insert(element)
		end
	end
end


-- called whenever a ship gets a new move order
-- @param x, y 	the target coordinates in world coordinates
function gameLogicHandler_steerShip(ship, x, y)
	hudDrawer_addMarker("move", x, y)
	ship:setTarget(x, y)
end

-- player leaves pilot seat, can now move around ship
function gameLogicHandler_switchCommand()
	-- if no camera switch is active at the moment
	if camera_switch_dt == CAMERA_SWITCH_TIME then
		drawHandler_switchCamera()
		if PLAYER_STATE ~= "commanding" then
			-- delete movement tags for player
			main_player.isMovingHorizontal = 0
			main_player.isMovingVertical = 0
		end
		
		statemachine_player_state_toggle() -- toggle state
		camera_switch_dt = 0 -- reset camera value. (
	end
end

-- iterate over all layers and all entities for collision checks
-- this is done using the quadtrees defined for each layer
function gameLogicHandler_collisionDetect()

	for m=1,LAYER_SIZE do
		
		local t = love.timer.getTime( )
		for i,element in pairs(layers[m]) do
			local returnObjects = {}
			quads[m]:retrieve(returnObjects, element)
			for j,collider in pairs(returnObjects) do
				if collider.id ~= element.id then
					resolveCollision(m, collider, element)
				end
			end
		end
		
	end
	
	devInfo["# of Collision checks"] = "N/A"
end
