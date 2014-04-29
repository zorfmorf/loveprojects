-- The background for a traderun such as nebula, stars, planets, wrecks

class "Background" {

	nebulator = nil; --the nebula generator thread
	stars = nil; -- star background
	seed = nil; -- the seed for the nebula
	nebula = nil; -- the nebula image
	   	
	-- initate a new background
	__init__ = function(self, seed)
		self.seed = seed
		self.stars = {}
		for i=1,3 do
			self.stars[i] = {}
			for k=1,2 do
				local imgData = love.image.newImageData( love.graphics:getWidth(), love.graphics:getHeight())
				local amount = (love.graphics:getWidth() + love.graphics:getHeight()) / 5
				for j=1,amount do
					local c = {math.random(1, love.graphics:getWidth() - 2), math.random(1, love.graphics:getHeight() - 2)}
					imgData:setPixel(c[1], c[2], 255, 255, 255, 255)
					imgData:setPixel(c[1] - 1, c[2], 255, 255, 255, 150)
					imgData:setPixel(c[1] + 1, c[2], 255, 255, 255, 150)
					imgData:setPixel(c[1], c[2] - 1, 255, 255, 255, 150)
					imgData:setPixel(c[1], c[2] + 1, 255, 255, 255, 150)
				end
				self.stars[i][k] = {love.graphics.newImage(imgData), -love.graphics:getHeight() * (k - 1)}
			end
		end
	end,
	
	-- generates all background components
	checkGeneration = function(self)
		
		-- if we don't have a nebulator yet, init one
		if self.nebulator == nil then
		    self.nebulator = love.thread.newThread('thread','misc/nebulator.lua')
			self.nebulator:set('w', love.graphics:getWidth())
			self.nebulator:set('h', love.graphics:getHeight())
			self.nebulator:set('id', self.seed)
			self.nebulator:start()
		end
		
		-- if we are finished, return success, in this case 2
		-- why do we return 2 if 1 means 100%? Well there was the problem
		-- that sometimes the nebulator finished just between this check
		-- and the following return of the percentage in which case the
		-- gamestate was changed but the image not saved.
		if self.nebulator:get('done') then 
			self.nebula = love.graphics.newImage(self.nebulator:get('data'))
			return 2 
		end
		
		-- else return current percentage
		local v = self.nebulator:get('percentage')
		if v == nil then return 0 else return v end
	end,
	
	update = function(self, dt)
		local s = main_ship:getSpeed()
		
		for i=2,table.getn(self.stars) do
			local v = s
			if i == 3 then v = v * 10 end
			for j=1,2 do
				self.stars[i][j][2] = self.stars[i][j][2] + v
				if self.stars[i][j][2] > love.graphics:getHeight() then self.stars[i][j][2] = -love.graphics:getHeight() end
			end
		end
	end,
	
	-- draw the background
	draw = function(self)
		
		love.graphics.setColor(255, 255, 255, 255)
		for i=1,table.getn(self.stars) do
			love.graphics.draw(self.stars[i][1][1], 0, self.stars[i][1][2])
			love.graphics.draw(self.stars[i][2][1], 0, self.stars[i][2][2])
		end
		
		love.graphics.setColor(150, 200, 210, 200)
		love.graphics.draw(self.nebula, 0, 0)
	end
	
}
