-- the addon class contains different addons that can be appended to a ship

-- generic addon
class "Addon" {
	
	image = nil;
	
	state = {100, 100}; -- currentState, maxState

	__init__ = function(self, graphic)
		self.image = love.graphics.newImage(tiles[graphic[1]])
    end,
	
	isFunctioning = function(self)
		return self.state[1] == self.state[2]
	end
}

addon = {}

-- Engine
class "addon.Engine" (Addon) {

	__init__ = function(self, graphic, force)
		self.image = love.graphics.newImage(tiles[graphic[1]])
		self.force = force
        
        self.particles = love.graphics.newParticleSystem(particleImage, 1600)
        self.particles:setLifetime(-1)
        self.particles:setSizes(0.4, 0.8)
		self.particles:setSpread(1.4)
        self.particles:setColors(220, 105, 20, 255, 194, 30, 18, 0)
		self.particles:setParticleLife(0.07)
		self.particles:setEmissionRate(2000)
		self.particles:setSpeed(300, 400)
		self.particles:stop()
		self.particles:start()
    end
}

-- Command Center
class "addon.Command" (Addon) {

	__init__ = function(self, graphic)
		self.image = love.graphics.newImage(tiles[graphic[1]])
    end
}
