-- An object in terms of this game is every entity in space.
-- All objects have values for position, velocities, orientation and rotation
-- as well as functionality for collision detection

OBJECT_ID = 1

class "Object" {
	x = 0, -- current x position
    y = 0, -- current y position
    a = 0, -- orientation
    r = 0, -- rotation
    xm = 0, -- current movement per second on x axis
    ym = 0, -- current movement per second on y axis
	id = 0,
	size = 1, -- multiplyer for object size. 1 is normal
	collisionsChecked, -- if all collisions where checked for this object in the current update phase
	collision, -- tmp test var

	__init__ = function(self, x, y, a, r, xm, ym, size)
		self.x = x
		self.y = y
		self.a = a
		self.r = r
		self.xm = xm
		self.ym = ym
		if size ~= nil then self.size = size end
		self.id =  self:createID()
		self.collisionsChecked = false
		self.collision = false
	end,
	
	-- return the bounding box for this object (necessary for collision detection)
	getBounds = function(self)
		if self.bounds == nil then
			local s = tileSize * self.size
			self.bounds = Bounds(self.x - s / 2, self.y - s / 2, s, s)
		end
		return self.bounds 
	end,
	
	createID = function(self)
		OBJECT_ID = OBJECT_ID + 1
		return OBJECT_ID - 1
	end
}

objects = {} -- a list of all classes inheriting from object

class "objects.Asteroid" (Object) {

	__init__ = function(self, x, y, a, r, xm, ym, size)
		self.x = x
		self.y = y
		self.a = a
		self.r = r
		self.xm = xm
		self.ym = ym
		if size ~= nil then self.size = size end
		self.visual = {90 + math.random(1, 2), math.random(0, 3)}
		self.id =  self:createID()
	end
}