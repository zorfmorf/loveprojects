-- A lifeform is something that can move around on its own, usually found
-- in a ship. the player is also a lifeform

LIFEFORM_ID = 1 -- every lifeform has it's unique id. needed?



class "Lifeform" {

	name = "NPC"; -- lifeform name. May be displayed?
    hp = {100, 100}; -- current and max hitpoints. chp == 0? DIES
    oxygen = 100; -- the oxygen of this lifeform. zero? DIES
    id = nil; -- the unique ID of this object
    animCycle = {2, 3, 2, 4};
    animDT = 1;
    layers = {1};
    
    speed = 0; -- movement speed into direction looked
    strafe = 0; -- strafe directions. -1 = left, 1 = right
    x = 0; -- the x position (presumably on the ship. nothing to do with game coords)
    y = 0; -- the y to the x
    o = 0; -- the orientation. has everything to do with game coords
   	
	-- initate a new lifeform
	__init__ = function(self, name, maxhp)
		if name ~= nil then self.name = name end
		if maxhp ~= nil then self.hp = {maxhp, maxhp} end
		self:createID()
	end,
	
	-- take dmg. Returns true if dead
	takeDmg = function(self, value)
		self.hp[1] = math.max(0, self.hp[1] - value)
		return self.hp[1] == 0
	end,
	
	-- get self a unique id
	createID = function(self)
		self.id = LIFEFORM_ID
		LIFEFORM_ID = LIFEFORM_ID + 1
	end,
	
	-- update animation cycle
	update = function(self, dt)
		
		
		self.animDT = self.animDT + dt * 7
		if self.animDT >= 5 or (self.speed == 0) then self.animDT = 1 end
		
		-- position updating? can be found in the corresponding ships update function
		-- why? because the ship knows where the floor and the doors are

		-- if this lifeform is the player, then (quite dirtly) adjust his orientation, so that he
		-- faces the mouse cursor)
		if self.id == main_player.id then
			
			-- adjust player orientation
			local px, py = drawHandler_calculateDrawPosition(main_ship, self.x, self.y) 
			local mx, my = drawHandler_convertScreenToWorld(love.mouse.getX(), love.mouse.getY())
			
			-- oh glorious atan2 function
			-- what is it I do you ask? I calculate the angle from the player 
			-- position to the mouse position in radians
			self.o = math.atan2(mx - px, py - my)

		end
			
	end
	
}
