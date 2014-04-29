-- The ship factory constructs ship data objects.
-- When it is finished you can get default versions of different ship layouts
-- For example: buildTrader(), buildDestroyer(), etc...


-- a small ship for testing purposes
function shipFactory_buildTestShip()

    -- first init a new ship object of size 5
    local ship = Ship(0, 0, 0, 0, 0, 0, 5)
	

    ship:addPart(1, 3, part.Floor({1, 0}, {false, false, false, 0}, addon.Command({12, 0})))
      
    ship:addPart(2, 2, part.Floor({1, 0}, {false, false, 1, false}))
    ship:addPart(2, 3, part.Floor({1, 0}, {0, 0, 1, 0}))
    ship:addPart(2, 4, part.Destroyed({0, false, false, false}))
    
    ship:addPart(3, 2, part.Cargo({3, 0, 4, 2}))
    ship:addPart(3, 3, part.Floor({1, 0, 4, 0, 4, 2}, {false, 0, false, 0}))
    ship:addPart(3, 4, part.Cargo({3, 0, 4, 0}))
    
    ship:addPart(4, 3, part.Floor({1, 0}, {false, 2, false, false}, addon.Engine({11, 0}, 5)))

    ship:addPart(5, 3, part.Nozzle({21, 0}, 4, 3))
	
	return ship
end
