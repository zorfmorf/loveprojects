-- decals are temporary visual modifications to a ship part such as blood, crumbs, oil, burn marks, etc.
-- they can be cleaned by the player or vanish over time. Therefore it is necessary to identify
-- individual decals, which is why they are not combined with the layers attribute of a ship part

-- generic decal. Can be used basically for anything
class "Decal" {
	decalID = 0,
	rotation = 0, 
	
	__init__ = function(self, id, rot)
		self.decalID = id
		self.rotation = rot
    end
}

decal = {}

-- Blood
class "decal.Blood" (Decal) {
	-- TODO: on init get a random blood ID, and random rotation
}

-- Floor stripes used for orientation
class "decal.Stripe" (Decal) {
	-- TODO: flesh out
}

-- Burn marks
class "decal.Burn" (Decal) {
	-- TODO: flesh out
}

-- Trash
class "decal.Trash" (Decal) {
	-- TODO: flesh out
}

-- Frost
class "decal.Frost" (Decal) {
	-- TODO: flesh out
}