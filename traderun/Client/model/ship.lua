-- This class defines a space ship

-- class definition
class "Ship" (Object) {
	
	size = 5, --maximum size, size/2,size/2 is center position
    parts = nil, -- double array of all ship parts
    partCount = 0;
    enginesActive = false,
    force = 0; -- the power of all engines combined
    lifeforms = nil; -- a list of lifeforms on this ship
	
	-- the init function is called when initializing an object of the type 
	-- ship
	-- @param x the x value of the position
	-- @param y the y value of the position
	-- @param a the angle the ship is pointing to
	-- @param r the rotation of the ship (in rotations/second)
	__init__ = function(self, x, y, a, r, xm, ym, size)
		self.x = x
		self.y = y
		self.a = a
		self.r = r
		self.xm = xm
		self.ym = ym
		self.players = {}
		self.parts = {}
		self.size = size
		self:createID()
		self.partCount = 0
		self.lifeforms = {}
	end,
	
	-- resets the ship body to all zeros (center piece is one)
	-- @param size The size of the ship body (NxN)
	resetParts = function(self)
		self.parts = {}
	end,
	
	-- returns the speed of the ship  (when engines running)
	getSpeed = function(self)
		return self.force / self.partCount
	end,
	
	-- add a lifeform
	addLifeform = function(self, lifeform)
		self.lifeforms[lifeform.id] = lifeform
	end,
	
	-- overrides the 
	getBounds = function(self)
		local tSize = self.size * 2 * tileSize
		return Bounds(self.x - tSize / 2, self.y - tSize / 2, tSize, tSize)
	end,
	
	-- add a part to the ship. It is important to use this function
	-- as ist is used by the ship to keep track on it's capabilities
	-- @param x, y, part 	where to add the part and the part itself
	addPart = function(self, x, y, part)
		if self.parts[x] == nil then
			self.parts[x] = {}
		end
		self.parts[x][y] = part
		self.partCount = self.partCount + 1
		
		-- if the part has any addons
		if part.addon ~= nil then
			if isinstance(part.addon, addon.Engine) then
				self.force = self.force + part.addon.force
			end
		end
	end,
	
	-- returns part if valid, otherwise nil
	getPart = function(self, x, y)
		if self.parts[x] ~= nil and self.parts[x][y] ~= nil then
			return self.parts[x][y]
		end
		return nil
	end,
    
	-- the update function of the ship
    update = function(self, dt)
        
        -- update every individual ship part
        for i,row in pairs(self.parts) do
            for j,cpart in pairs(row) do
				
				
				-- if ship part is breached, suck out oxygen
				if cpart.breached then
					cpart.oxygen = math.max(0, cpart.oxygen - 50 * dt)
				end
				
				-- handle floor tiles
				if isinstance(cpart, part.Floor) then
				
					
					-- check for openings to other parts and (if applicable), adjust
					-- oxgen levels
					local partner = nil
					for m=1,4 do
						
						if cpart.door[m] and cpart.door[m] ~= 2 then
							local tmp = nil
							if m == 1 then tmp = self:getPart(i, j - 1) end
							if m == 2 then tmp = self:getPart(i - 1, j) end
							if m == 3 then tmp = self:getPart(i, j + 1) end
							if m == 4 then tmp = self:getPart(i + 1, j) end	

							-- close door if applicable
							if tmp ~= nil then
							
								if tmp.oxygen ~= cpart.oxygen then
									if cpart.door[m] == 1 then
										cpart.door[m] = 2
									end
								end
								
								-- calculate other door direction
								local tempmod = (m + 2) % 4
								if tempmod == 0 then tempmod = 1 end
								
								if tmp.oxygen < cpart.oxygen and cpart.door[m] ~= 2 
									and (isinstance(tmp, part.Destroyed) or tmp.door[tempmod] ~= 2) then
	
									if partner == nil or tmp.oxygen < partner.oxygen then
										partner = tmp
									end

								end
							end
						end
					end
					
					if partner ~= nil and partner.oxygen < cpart.oxygen then
						cpart.oxygen = cpart.oxygen - (cpart.oxygen - partner.oxygen) * dt
					end
					
				end
				
				-- if ship part is engine, update particle effects
				if cpart.addon ~= nil and isinstance(cpart.addon, addon.Engine) then
					cpart.addon.particles:update(dt)
				end
                
            end
        end
        
        -- update every lifeform
		for i,lifeform in pairs(self.lifeforms) do
			lifeform:update(dt)
			
			-- update lifeform's position
			-- needs to be done here, because of collision checks
			-- could still be done in the lifeforms update method
			-- but is way more convenient here
			
			local cpart = self.parts[round(lifeform.y)][round(lifeform.x)]
			
			local xa = math.sin(lifeform.o) * lifeform.speed
			local ya = math.cos(lifeform.o) * lifeform.speed
			
			if lifeform.strafe ~= 0 then
			
				xa = xa + math.sin(lifeform.o + lifeform.strafe * (math.pi / 2)) * HUMAN_STRAFE_SPEED
				ya = ya + math.cos(lifeform.o + lifeform.strafe * (math.pi / 2)) * HUMAN_STRAFE_SPEED
				
			end
			
			local nx = lifeform.x + xa * dt
			local ny = lifeform.y - ya * dt
			
			if self:validatePosition(nx, ny) then
				lifeform.x = nx
				lifeform.y = ny
			else
				if self:validatePosition(lifeform.x, ny) then lifeform.y = ny end
				if self:validatePosition(nx, lifeform.y) then lifeform.x = nx end
			end
		end
		
    end,
    
    -- check if a specific lifeform position in this ship is valid
    -- returns boolean
    validatePosition = function(self, x, y)
    
		-- calculate the part we will be in if we make the move
		local npart = self.parts[round(y)][round(x)]
			
		-- is the new part valid for walking there?
		if npart ~= nil and npart.isWalkable then
			
			-- okay so we need to check for both coordinates if they are legit
			local mx = math.abs(x - round(x))
			local my = math.abs(y - round(y))
			
			if (mx < 0.3 and my < 0.3) or 
			   (npart.door[1] and npart.door[1] < 2 and my < 0.2 and x - round(x) < 0) or
			   (npart.door[3] and npart.door[3] < 2 and my < 0.2 and x - round(x) > 0) or 
			   (npart.door[2] and npart.door[2] < 2 and mx < 0.2 and y - round(y) < 0) or
			   (npart.door[4] and npart.door[4] < 2 and mx < 0.2 and y - round(y) > 0) then
				
				return true
				
			end
			

		end
		
		return false
		
    end
}



