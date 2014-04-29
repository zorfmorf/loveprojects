class = require 'core/misc/30logclean'

MOV_SPEED = 1
OBJECT_ID = 1 -- sequence


-- the game area is divided into a grid form. every grip is occupied by
-- a tile
Tile = class {
	
	level = 0, -- the height level the tile is on
	objects = nil

}
Tile.__name = 'Tile'


-- a box is a tile. boxes are the default tiles used for displaying sea
Box = Tile:extends {

	shift = 0, -- the amount by which the boxes is shifted in time (sinus movement)
	speedup = 0 -- the amount the box is faster in relation to time dependent sinus movement
	
}
Box.__name = 'Box'


-- objects are things that can move and interact with the world and are
-- not constricted to a tile
Object = class {
	
	-- x and y coordinates defining the objects world position
	x = 0,
	y = 0,
	level = 0,
	id = 0 --unique identifier

}
Object.__name = 'Object'
function Object:__init()
	self.id = OBJECT_ID
	OBJECT_ID = OBJECT_ID + 1
end
function Object:updateLevel(sea)
	
	self.level = sea[math.floor(self.x)][math.floor(self.y)].level	
	
end
function Object:update(dt, objects)

end


-- a barrel is an object. Barrels float and do not much more
Spaceman = Object:extends {

	waypoint = nil,
	mov = nil -- the current movement, can be +x, -x, +y, -y

}
Spaceman.__name = 'Spaceman'
function Spaceman:update(dt, objects)
	
	if self.waypoint == nil then
		
		self.waypoint = Waypoint:new( math.min( math.max(MAP_MIN + 0.5, self.x + math.random(-5, 5)), MAP_MAX + 0.5), 
									  math.min( math.max(MAP_MIN + 0.5, self.y + math.random(-5, 5)), MAP_MAX + 0.5))
	
	end
	
	if self.mov ~= nil then
	
		-- remember old tile
		local oldX = math.floor(self.x)
		local oldY = math.floor(self.y)
	
		if self.mov == "+x" then
			
			local targetX = math.floor(self.x + 0.5) + 0.5
			self.x = self.x + MOV_SPEED * dt
			
			if self.x >= targetX then
				self.x = targetX
				self.mov = nil
			end
			
		end
		
		if self.mov == "-x" then
			
			local targetX = math.floor(self.x - 0.51) + 0.5
			self.x = self.x - MOV_SPEED * dt
			
			if self.x <= targetX then
				self.x = targetX
				self.mov = nil
			end
			
		end
		
		if self.mov == "+y" then
			
			local targetY = math.floor(self.y + 0.5) + 0.5
			self.y = self.y + MOV_SPEED * dt
			
			if self.y >= targetY then
				self.y = targetY
				self.mov = nil
			end
			
		end
		
		if self.mov == "-y" then
			
			local targetY = math.floor(self.y - 0.51) + 0.5
			self.y = math.max(1.5, self.y - MOV_SPEED * dt)
			
			if self.y <= targetY then
				self.y = targetY
				self.mov = nil
			end
			
		end
		
		-- check if new tile ~= old tile
		local newX = math.floor(self.x)
		local newY = math.floor(self.y)
		if newX ~= oldX or newY ~= oldY then
		
			print(newX, newY, oldX, oldY)
			
			objects[newX][newY][self.id] = self
			objects[oldX][oldY][self.id] = nil
			
		end
	
	else
		
		-- self.x self.y
		if self.x < self.waypoint.x then
			self.mov = "+x"
		elseif self.x > self.waypoint.x then
			self.mov = "-x"
		elseif self.y < self.waypoint.y then
			self.mov = "+y"
		elseif self.y > self.waypoint.y then
			self.mov = "-y"
		else
			self.mov = nil
			self.waypoint = nil
		end
	
	end
	
end


--------------- Misc classes
Waypoint = class {
	x = 0,
	y = 0
}
function Waypoint:__init(x, y)
	self.x = x
	self.y = y
end
