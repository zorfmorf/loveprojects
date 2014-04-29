-- the addon class contains different addons that can be appended to a ship

-- generic addon
class "Addon" {

	graphic = {0, 0}, -- the graphical representation of the addon
	
	drawBelow = false, -- whether the addon should be drawn below the ship part
	
	state = {100, 100}, -- currentState, maxState

	__init__ = function(self, graphic)
		self.graphic = graphic
    end,
	
	isFunctioning = function(self)
		return self.state[1] == self.state[2]
	end
}

addons = {}

-- Engine
class "addons.Engine" (Addon) {

	force = 20, -- thrust supplied by engine
	drawBelow = false,

	__init__ = function(self, graphic, force)
		self.graphic = graphic
		self.force = force
		self.drawBelow = false
        
        self.particles = love.graphics.newParticleSystem(particleImage, 1000)
        self.particles:setLifetime(0.1)
        self.particles:setSizes(2, 1)
		self.particles:setSpread(1)
        self.particles:stop()
        drawHandler_addParticles(self.particles)
    end,
    
    setModus = function(self, mode)
        if mode == "thrust" then
            self.particles:setColors(220, 105, 20, 255, 194, 30, 18, 0)
            self.particles:setParticleLife(0.18)
            self.particles:setEmissionRate(1000)
            self.particles:setSpeed(300, 400)
            self.particles:stop()
        end
    end
}


-- the muzzle of the engine
class "addons.EngineMuzzle" (Addon) {
	__init__ = function(self, graphic, x, y)
		self.graphic = graphic
		self.x = x -- x coordinate of corresponding engine
		self.y = y -- y coordinate of corresponding engine
		self.drawBelow = true
    end
}

-- SideNozzle used for modifying the rotation of the ship
class "addons.SideThruster" (Addon) {
    
    thrust = 0.1,
	
	cooldown = 0,
    
	__init__ = function(self, graphic, thrust)
		self.graphic = graphic
        self.thrust = thrust
		self.drawBelow = true
    end
}

-- AI Core. Necessary to handle all automated functions of the ship
-- if the value for a module is nil, it is not installed and the player must
-- handle all related tasks manually
class "addons.AICore" (Addon) {
    
	MODULE_ENERGY = nil, -- energy management (redistribute energy dynamically when shortage)
	MODULE_STEERING = nil, -- ship steering
	MODULE_WEAPONS = nil, -- aiming and firing weapons
	MODULE_BOTS = nil, -- handling of all bots
	MODULE_SCANNING = nil, -- scanning
	MODULE_EWARFARE = nil, -- electronic warfare
	
	animation_cycle = 0,
	
	ship = nil, -- ship the AI belongs to
	
	graphic2 = {14, 0}, -- the terminal grphic. doesnt rotate
    
	__init__ = function(self, graphic)
		self.graphic = graphic
		self.graphic2[2] = graphic[2]
		self.drawBelow = false
		self.MODULE_STEERING = ais.steering_dumb(self)
    end,
	
	update = function(self, dt)
		self.animation_cycle = math.random() * math.pi * 2
		if self.MODULE_STEERING ~= nil then self.MODULE_STEERING:steer(ship) end
	end
}
