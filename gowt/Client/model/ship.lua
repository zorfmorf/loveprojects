-- This class defines a space ship

-- class definition
class "objects.Ship" (Object) {
	
	mainThrust = 0, -- the amount of main thrust supplyable by main engines.
	
	sideThrust = 0, -- the amount of side thrust supplyable by side engines. Always positive

	mainActive = false, -- main engine active?
	sideActive = 0, -- side engine active? 0 = off, 1 = circular, -1 = acircular
	
	sideCD = 0, -- the cooldown until the side engines can be activated again

	size = 5, --needs to be half of maximum size
    parts = nil, -- double array of all ship parts
	target = nil, -- the current move target
	partCount = 0, -- the amount of parts the ship has
	
	aiCore = nil, -- direct link to ai core if available on ship
	
	players = nil, -- the list of players on the ship. a players ID marks the index
	
	-- the init function is called when initializing an object of the type 
	-- ship
	-- @param x the x value of the position
	-- @param y the y value of the position
	-- @param a the angle the ship is pointing to
	-- @param r the rotation of the ship (in rotations/second)
	__init__ = function(self, x, y, a, r, xm, ym)
		self.x = x
		self.y = y
		self.a = a
		self.r = r
		self.xm = xm
		self.ym = ym
		self.players = {}
		self.parts = {}
		self.id =  self:createID()
	end,
	
	-- resets the ship body to all zeros (center piece is one)
	-- @param size The size of the ship body (NxN)
	resetParts = function(self)
		self.parts = {}
	end,
	
	-- add a player withe the player's id as index
	addPlayer = function(self, player)
		self.players[player.id] = player
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
			if isinstance(part.addon, addons.Engine) then
				self.mainThrust = self.mainThrust + part.addon.force
			end
			
			if isinstance(part.addon, addons.SideThruster) then
				self.sideThrust = self.sideThrust + part.addon.thrust
			end
			
			if isinstance(part.addon, addons.AICore) then
				self.aiCore = part.addon
				self.aiCore.ship = self
			end
		end
	end,
	
	-- add a target the ship is supposed to drive to
	setTarget = function(self, x, y)
		self.target = {x, y}
		self.mainActive = false
	end,
	
	setSide = function(self, value)
		if value == 0 then
			self.sideActive = value
		else
			if self.sideCD == 0 then
				self.sideActive = value
				if value ~= 0 then
					self.sideCD = SHIP_SIDETHRUSTER_CD
				end
			end
		end
	end,
    
	-- the update function of the ship
    update = function(self, dt)
		if self.aiCore ~= nil then self.aiCore:update(dt) end
        
        for i,row in pairs(self.parts) do
            for j,part in pairs(row) do
                if isinstance(part, parts.Floor) then
                    if part.closed then
                        --if self.parts[i - 1][j] ~= nil
                    else
                        part.oxygen = math.max(part.oxygen - 20 * dt, 0)
                    end
                end
            end
        end
    end
}



