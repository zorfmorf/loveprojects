-- All ai modules


-- generic addon
class "AI_module" {
	
	state = "inactive", -- state of the module

	__init__ = function(self)

    end
}

ais = {}

--------- STEERING MODULES

-- calculates the orientation the ship will have if sidethrusters are used now until the
-- ship has 0 rotation
-- sideThrust has to be a positive value for this to work
local function calculateStopOrientation(angle, rotation, sidethrust)
	if rotation < 0 then
		sidethrust = -sidethrust
	end
	local dt = rotation / sidethrust -- time needed until rotation is zero
	return angle + dt * (rotation - dt * sidethrust / 2)
end

-- calculates where the ship would stop if we engaged the antimatter brakes now
local function calculateStopPosition(xm, ym, x, y, nrOfParts)
	
	local dt = 1 / (nrOfParts * OBJECT_DECELERATION_FACTOR)
	
	-- now calculate the position we would be at
	local xn = x + dt * xm / 2
	local yn = y + dt * ym / 2
	return xn, yn
end

-- dumb steering
class "ais.steering_dumb" (AI_module) {

	core = nil,
	
	__init__ = function(self, core)
		self.core = core
    end,
	
	steer = function(self)
		local ship = self.core.ship
		if ship.target == nil then
			ship.mainActive = false
			ship:setSide(0)
		else
			-- use side engines to align ship to target
			-- TODO: optimize
			
			-- first calculate angle to target
			local angle = math.atan2(ship.y - ship.target[2], ship.x - ship.target[1]) - math.pi / 2 - ship.a
			if angle > math.pi then
				angle = angle - math.pi * 2
			end
			if angle < -math.pi then
				angle = angle + math.pi * 2
			end
			
			local delta = 0.03 -- acceptable orientation difference towards target
			
			-- if we are oriented correctly, stop the sideengine
			if math.abs(angle) < delta and ship.r < delta then
				ship:setSide(0)		
			else
			
				local tmp = calculateStopOrientation(ship.a, ship.r, ship.sideThrust) - (ship.a + angle)
				
				-- steer ship to target
				if tmp > 0 then
					ship:setSide(-1)
				else
					ship:setSide(1)
				end
				
				-- if stopping the ship now will stop us at the correct angle, inverse thrust
				if math.abs(tmp) < delta then
					ship:setSide(ship.sideActive * (-1))
				end
			end
			
			-- handle main engines

			-- if we are really close to the target, try to stop, break if necessary
			local dist = math.sqrt(math.pow(ship.x - ship.target[1], 2) + math.pow(ship.y - ship.target[2], 2))
			if dist < 100 then
				if ship.mainActive then ship.mainActive = false end
				ship.target = nil
			else
				-- if the main engine is active, check where we would be if we would start breaking now
				-- if we were close to the target, start breaking, else leave everything as is
				if ship.mainActive then
					local xn, yn = calculateStopPosition(ship.xm, ship.ym, ship.x, ship.y, ship.partCount)
					local dist2 = math.sqrt(math.pow(xn - ship.x, 2) + math.pow(yn - ship.y, 2))
					if math.abs(dist - dist2) < 200 then 
						ship.mainActive = false
					else
						if math.abs(angle) >= 0.1 then
							ship.mainActive = false
						end
					end
				else -- if the main engine is inactive, check if we are oriented correctly and slowed down enough then start the engine
					if math.abs(ship.xm) + math.abs(ship.ym) < 30 then
						ship.mainActive = math.abs(angle) < 0.1
					end
				end
			end
		end
	end
}