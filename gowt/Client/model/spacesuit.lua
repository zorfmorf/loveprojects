-- A space suit can (and should) be worn by a player
-- It provides life support but has a limited energy and oxygen supply
-- Suits may have additional features such as an energy shield,
-- magnetic boots or manouver thrusters for EVA

class "Spacesuit" {
    oxygen = 100, -- current oxygen level
	oxygen_max = 100, -- oxygen level
	
	engery = 100, -- current energy level
	energy_max = 100, -- max energy level
	
	state = 100, -- the current suit state
	state_max = 100, -- the max suit state
	
	
	-- the init function for spacefuits
	__init__ = function(self, o, omax, e, emax, s, smax)
		self.oxygen = o
		self.oxygen_max = omax
		self.energy = e
		self.energy_max = emax
		self.state = s
		self.state_max = smax
	end,
	
	-- the damage function is called when the suit
	-- recieves damge. Necessary to accomodate suits with shields
	takeDamage = function(self, dmg)
		self.state = self.state - dmg
	end
}