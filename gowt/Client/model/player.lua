-- A player is represented by a character either inside a ship or floating in space

class "Player" {
	name = "Player", -- the name of the player. not unique.
	id = 0, -- the unique ID of the player
	speed = 1.2, -- walking speed
	suit = nil, -- spacesuit worn
	health = 100, -- current life
	max_health = 100, -- maximum life
	
	--movement related
	isMovingVertical = 0, -- 0 is no, 1 is down, -1 is up
	isMovingHorizontal = 0, -- 0 is no, 1 is right, -1 is left
	
	-- the position in space (same as ship coordinates) OR 
	-- the position inside ship, where it corresponds to a shippart.
	-- 5.0,5.0 would be the exact center of shippart 5,5
	-- 5.5,5.0 would be directly between shipparts 5,5 and 6,5
	-- this makes it easy to validate movement and interact with the ship
	position = {1, 1},
	orientation = 2, -- the direction the player is oriented to
	insideShip = true, -- whether player is inside ship or in space
	
	__init__ = function(self, x, y)
		self.position = {x, y}
	end
}
