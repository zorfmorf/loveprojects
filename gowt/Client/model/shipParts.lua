-- This class defines a ship part. 

-- generic ship part class definition
-- Every ship part is either walkable or not. in addition it has a stack of layers that are drawn
-- from the bottom up. The layers represent the part itself
-- Decals are optional and are used to display temporary modifications to the representation such as 
-- bloodsplatter or cracks
-- 
class "ShipPart" {
	isWalkable = false,
	layers = {}, -- graphical representation. Two numbers represent a layer. graphic ID and rotation.
	decals = nil, -- temporary modifications. may be null. structure same as layers
	addon = nil, -- the addon of the part
	state = 100, -- the current state of the part
	maxstate = 100, -- the max state of the part. if state == maxstate no repairs are necessary
	armor = 0,
	
	-- the init function is called when creating a new Ship Part
	__init__ = function(self, layers, addon, maxstate)
		self.layers = layers
		if addon ~= nil then self.addon = addon self.isWalkable = false end
		if maxstate ~= nil then self.state, self.maxstate = maxstate end
    end,
	
	-- applies damage and updates visualization
	-- returns true if part is destroyed completely
	takeDmg = function(self, value)
	
		self.state = self.state - math.max(0, value - self.armor)
		
		if self.state <= 0 then
			return true
		end
		
		if self.state < 70 then
			self.layers = {self.layers[1], self.layers[2], 41, self.layers[2]}
		end
		
		if self.state < 50 then
			self.layers = {self.layers[1], self.layers[2], 42, self.layers[2]}
		end
		
		if self.state < 30 then
			self.layers = {self.layers[1], self.layers[2], 43, self.layers[2]}
		end
	
		return false
	end
}

parts = {}

-- Floor
class "parts.Floor" (ShipPart) {
	isWalkable = true, -- you should be able to walk over the floor
	temperature = 22, -- temperature in degree. currently unused
	oxygen = 100, -- oxygen level in percent
	gravity = 1.0, -- gravity currently not implemented
	closed = true, -- if the air on this tile can leave the ship
    walls = {false, false, false, false}, -- wether there is a wall in any direction
    
    -- the init function is called when creating a new Ship Part
	__init__ = function(self, layers, walls, addon, maxstate)
		self.layers = layers
        if walls ~= nil then self.walls = walls end
		if addon ~= nil then self.addon = addon self.isWalkable = false end
		if maxstate ~= nil then self.state, self.maxstate = maxstate end
    end,
    
    -- can be called to assess whether the floor has a wall into the specified
    -- direction
    hasWall = function(self, direction)
        if direction == "n" then return self.walls[0] end
        if direction == "e" then return self.walls[1] end
        if direction == "s" then return self.walls[2] end
        if direction == "w" then return self.walls[3] end
    end
}

class "parts.Bkg" (ShipPart) {
	
}

-- Door. TODO: Flesh out what happens when the door is not covering the whole field (decompression etc)
class "parts.Door" (ShipPart) {
	isWalkable = true,
	oxygen = 100, -- oxygen level in percent
	gravity = 1.0 -- gravity currently not implemented
}

-- Nozzle. Necessary because engine fire needs to be drawn TODO: move to addons??
class "parts.Nozzle" (ShipPart) {
	__init__ = function(self, layers, x, y)
		self.layers = layers
		self.x = x -- x coordinate of corresponding engine
		self.y = y -- y coordinate of corresponding engine
    end
}


