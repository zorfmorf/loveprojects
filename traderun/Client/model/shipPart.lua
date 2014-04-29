-- This class defines a ship part. 

-- copy helper function
-- why would we copy pixel by pixel and not just simply display the layers
-- on top of each other during draw operations? Because there were problems
-- with unwanted graphical artifacts. Besides, the preprocessing in this 
-- step will make the actual draw operations faster. May be useful
local function copy(target, source, rotation, force)
	
	for i=0,TILE_SIZE - 1 do
		for j=0,TILE_SIZE - 1 do
			
			local r, g, b, a = source:getPixel(i, j)
			
		
			if force or a > 0 then
			
				if rotation == 0 then
					target:setPixel(i, j, r, g, b, a)
				end
				
				if rotation == 1 then
					target:setPixel(TILE_SIZE - 1 - j, i, r, g, b, a)
				end
				
				if rotation == 2 then
					target:setPixel(TILE_SIZE - 1 - i, TILE_SIZE - 1 - j, r, g, b, a)
				end
				
				if rotation == 3 then
					target:setPixel(j, TILE_SIZE - 1 - i, r, g, b, a)
				end
			end
		end
	end
end

-- generic ship part class definition
-- Every ship part is either walkable or not. in addition it has a stack of layers that are drawn
-- from the bottom up. The layers represent the part itself
-- Decals are optional and are used to display temporary modifications to the representation such as 
-- bloodsplatter or cracks
-- 
class "ShipPart" {

	isWalkable = false;
	layers = {}; -- graphical representation. Two numbers represent a layer. graphic ID and rotation.
	decals = nil; -- temporary modifications. may be null. structure same as layers
	addon = nil; -- the addon of the part
	state = 100; -- the current state of the part
	maxstate = 100; -- the max state of the part. if state == maxstate no repairs are necessary
	armor = 0; -- damage absorption
	image = nil; -- image generated from layers
	
	-- the init function is called when creating a new Ship Part
	__init__ = function(self, layers, addon, maxstate)
		self.layers = layers
		if addon ~= nil then self.addon = addon end
		if maxstate ~= nil then self.state, self.maxstate = maxstate end
		self:generate()
    end,
	
	-- applies damage and updates visualization
	-- returns true if part is destroyed completely
	takeDmg = function(self, value)

	end,
	
	generate = function(self)
		local imgData = love.image.newImageData( TILE_SIZE, TILE_SIZE )
		for i=1,table.getn(self.layers)/2 do
			local force = (i == 1)
			copy(imgData, tiles[self.layers[i * 2 - 1]], self.layers[i * 2], force)
		end
		self.image = love.graphics.newImage(imgData)
	end
	
}

part = {}

-- Floor
class "part.Floor" (ShipPart) {

	isWalkable = true; -- you should be able to walk over the floor
	temperature = 22; -- temperature in degree. currently unused
	oxygen = 100; -- oxygen level in percent
	gravity = 1.0; -- gravity currently not implemented
	breached = false; -- if this tile has an opening 
    door = {false, false, false, false}, -- wether there is a opening in any direction, 0 yes, 1 open door, 2 closed door
    
    -- the init function is called when creating a new Ship Part
	__init__ = function(self, layers, door, addon, maxstate)
	
		local currentIndex = table.getn(layers) + 1
		for i=1,table.getn(door) do
		
			-- generate floor connectors
			if door[i] then
				layers[currentIndex] = 2
				layers[currentIndex + 1] = i - 1
				currentIndex = currentIndex + 2
			end
			
			-- generate door markings
			if door[i] == 1 or door[i] == 2 then
				layers[currentIndex] = 5
				layers[currentIndex + 1] = i - 1
				currentIndex = currentIndex + 2
			end
		end
		self.layers = layers
		self.door = door
		
		if addon ~= nil then self.addon = addon end
		if maxstate ~= nil then self.state, self.maxstate = maxstate end
		self:generate()
    end,

}

-- Nozzle. Necessary because engine fire needs to be drawn TODO: move to addons??
class "part.Nozzle" (ShipPart) {
	__init__ = function(self, layers, x, y)
		self.layers = layers
		self.x = x -- x coordinate of corresponding engine
		self.y = y -- y coordinate of corresponding engine
		self:generate()
    end
}

-- Cargo. Valuable.
class "part.Cargo" (ShipPart) {
	
}

-- Destroyed part. Just for looks
class "part.Destroyed" (ShipPart) {
	
	door = {false, false, false, false};
	isWalkable = true;
	breached = true;
	oxygen = 0; --for correct part display
	
	__init__ = function(self, door)
		self.door = door
		local layers = {}
		
		local currentIndex = 1
		for i=1,table.getn(door) do
		
			-- generate floor connectors
			if door[i] then
				layers[currentIndex] = 7
				layers[currentIndex + 1] = i - 1
				currentIndex = currentIndex + 2
			end

		end
		self.layers = layers
		self:generate()
    end
    
}


