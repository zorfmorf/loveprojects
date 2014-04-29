-- this file represents the quadtree used to reduce the number of
-- collision checks needed. 
-- implementation based on the following blog entry
-- http://gamedev.tutsplus.com/tutorials/implementation/quick-tip-use-quadtrees-to-detect-likely-collisions-in-2d-space/

local QT_MAX_LEVELS = 10
local QT_MAX_OBJECTS = 3

-- the bounds define an area
class "Bounds" {

	__init__ = function(self, x, y, width, height)
		self.x = x
		self.y = y
		self.width = width
		self.height = height
	end
	
}

-- the quadtree object itself contains a number of objects. if the
-- number of objects becomes larger than MAX_OBJECTS, it splits itself
-- into four subtrees
class "Quadtree" {
	
	level, -- the level of this quadtree (5 lowest, 0 topmost)
	objects, -- the objects contained in this quadtree
	bounds, -- the area defined by this quadtree
	nodes, -- a list of sub quadtrees
	count, -- amount of elements in this layer
	parent, -- the parent quadtree if available

	-- init the quadtree
	__init__ = function(self, level, bounds, parent)
		self.level = level
		self.objects = {}
		self.bounds = bounds
		self.nodes = {}
		self.count = 0
		if parent ~= nil then self.parent = parent end
	end,
	
	-- clear the quadtree
	clear = function(self)
		self.objects = {}
		for i,subtree in pairs(self.nodes) do
			subtree:clear()
		end
		self.nodes = {}
	end,
	
	-- split the node into four subnodes
	split = function(self)
		local subWidth = self.bounds.width / 2
		local subHeight = self.bounds.height / 2
		local x = self.bounds.x
		local y = self.bounds.y
		
		self.nodes[1] = Quadtree(self.level + 1, Bounds(x + subWidth, y, subWidth, subHeight), self)
		self.nodes[2] = Quadtree(self.level + 1, Bounds(x, y, subWidth, subHeight), self)
		self.nodes[3] = Quadtree(self.level + 1, Bounds(x, y + subHeight, subWidth, subHeight), self)
		self.nodes[4] = Quadtree(self.level + 1, Bounds(x + subWidth, y + subHeight, subWidth, subHeight), self)
	end,
	
	-- check if the given bounds fit into this quadtree or its child nodes
	getIndex = function(self, bounds)
		local index = 0
		local midX = self.bounds.x + self.bounds.width / 2
		local midY = self.bounds.y + self.bounds.height / 2
		
		-- calculate if object can fit into the top quadrant
		local fitTop = bounds.y + bounds.height < midY
		-- calculate if object can fit into the bottom quadrant
		local fitBottom = bounds.y > midY
		
		-- calculate if object fits into left or right quadrant
		if bounds.x + bounds.width < midX then
			if fitTop then 
				index = 2
			elseif fitBottom then
				index = 3
			end
		elseif bounds.x > midX then
			if fitTop then
				index = 1
			elseif fitBottom then
				index = 4
			end
		end
		return index
	end,
	
	-- insert object into tree. if possible it will split into subtrees
	insert = function(self, object)
		
		if self.nodes[1] ~= nil then
			local index = self:getIndex(object:getBounds())
			if index ~= 0 then
				self.nodes[index]:insert(object)
				return
			end
		end
		
		self.objects[object.id] = object
		object.leaf = self
		self.count = self.count + 1
		
		if self.count > QT_MAX_OBJECTS and self.level < QT_MAX_LEVELS then
			
			if self.nodes[1] == nil then
				self:split()
			end
			
			for i,candidate in pairs(self.objects) do
				local index = self:getIndex(candidate:getBounds())
				if index ~= 0 then
					self.nodes[index]:insert(candidate)
					self.count = self.count - 1
					self.objects[candidate.id] = nil
				end
			end
		end
		
	end,
	
	-- return all objects that could collide with the given object
	retrieve = function(self, returnObjects, object)
		local index = self:getIndex(object:getBounds())
		if index ~= 0 and self.nodes[1] ~= nil then
			self.nodes[index]:retrieve(returnObjects, object)
		end
	
		for i,candidate in pairs(self.objects) do
			if candidate.id ~= object.id and candidate.collisionsChecked == false then
				returnObjects[i] = candidate
			end
		end
	end,
	
	-- checks whether the object still fits into this quadtree
	-- (may not be true anymore due to object moving away)
	check = function(self, object)
		local b = object:getBounds()		
		if b.x >= self.bounds.x and b.x + b.width <= self.bounds.x + self.bounds.width and 
			b.y >= self.bounds.y and b.y + b.height <= self.bounds.y + self.bounds.height then
			if self.objects[object.id] == nil then
				self:insert(object)
			end
		else
			if self.objects[object.id] ~= nil then
				self:delete(object)
			end
			
			if self.parent ~= nil then
				self.parent:check(object)
			end
		end
	end,
	
	-- remove the element
	delete = function(self, object)
		if self.objects[object.id] ~= nil then
			self.objects[object.id] = nil
			object.leaf = nil
			self.count = self.count - 1
		end
	end,
		
	-- draws the bounds of this quadtree and all its childs
	draw = function(self)
		if self.nodes[1] ~= nil then
			self.nodes[1]:draw()
			self.nodes[2]:draw()
			self.nodes[3]:draw()
			self.nodes[4]:draw()
		end
		love.graphics.rectangle("line", self.bounds.x, self.bounds.y, self.bounds.width, self.bounds.height)
	end
}

