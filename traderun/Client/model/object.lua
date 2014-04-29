-- An object in terms of this game is every entity in space.
-- All objects have values for position, velocities, orientation and rotation
-- as well as functionality for collision detection

--global var to make sure that no two objects have the same id
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

	__init__ = function(self, x, y, a, r, xm, ym, size)
		self.x = x
		self.y = y
		self.a = a
		self.r = r
		self.xm = xm
		self.ym = ym
		if size ~= nil then self.size = size end
		self:createID()
	end,
	
	-- return the bounding box for this object (necessary for collision detection)
	getBounds = function(self)
		
		if self.bounds == nil then
			
			local s = TILE_SIZE * self.size
			self.bounds = Bounds(self.x - s / 2, self.y - s / 2, s, s)
			
		end
		
		self.bounds.x = self.x - self.bounds.width / 2
		self.bounds.y = self.y - self.bounds.height / 2
		
		return self.bounds 
	end,
	
    -- create a unique id
	createID = function(self)
        self.id = OBJECT_ID
		OBJECT_ID = OBJECT_ID + 1
	end,

    -- update function
    update = function(self, dt)
        
        -- update object position
        self.x = self.x + self.xm * dt
        self.y = self.y + self.ym * dt
        
        -- update object orientation
        self.a = self.a + self.r * dt
        
        -- if an object is too far south, remove it and add it to the list
        -- of encountered objects for scoring
        if self.y > 4000 then
			
			entities[self.id] = nil
			runHandler.traderun.encountered[self.id] = self
			
		end
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
		self.visual = asteroidImages[math.random(1, 2)]
		self:createID()
	end
}
