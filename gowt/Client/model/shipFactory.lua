-- The ship factory constructs ship data objects.
-- When it is finished you can get default versions of different ship layouts
-- For example: buildTrader(), buildDestroyer(), etc...


-- a small ship for testing purposes
function shipFactory_buildTestShip()

    -- first init a new ship object
    local ship = objects.Ship(100, 100, 3, 0, 0, 0)
    
    ship.size = 3 -- gives us a 6x6 field. 
	
	ship:addPart(1, 1, parts.Bkg({12, 0}))
	ship:addPart(1, 2, parts.Bkg({11, 1}))
    ship:addPart(1, 3, parts.Bkg({11, 1}))
    ship:addPart(1, 4, parts.Bkg({11, 1}))
    ship:addPart(1, 5, parts.Bkg({11, 1}))
    ship:addPart(1, 6, parts.Bkg({12, 1}))
    
    ship:addPart(2, 1, parts.Bkg({11, 0}))    
    ship:addPart(2, 2, parts.Floor({6, 0, 1, 0, 1, 1, 2, 2}))
    ship:addPart(2, 3, parts.Floor({6, 0, 1, 1, 1, 3}))
    ship:addPart(2, 4, parts.Floor({6, 0, 1, 1, 1, 3}))
    ship:addPart(2, 5, parts.Floor({6, 0, 1, 2, 1, 1, 2, 3}))
    ship:addPart(2, 6, parts.Bkg({11, 2}))   
    
    ship:addPart(3, 1, parts.Bkg({11, 0})) 
    ship:addPart(3, 2, parts.Floor({6, 0, 1, 0, 1, 2}))
    ship:addPart(3, 3, parts.Bkg({13, 0})) 
    ship:addPart(3, 4, parts.Bkg({13, 0})) 
    ship:addPart(3, 5, parts.Floor({6, 0, 1, 0, 1, 2}))
    ship:addPart(3, 6, parts.Bkg({11, 2})) 
    
    ship:addPart(4, 1, parts.Bkg({11, 0}))
    ship:addPart(4, 2, parts.Floor({6, 0, 1, 0, 2, 1, 2, 2}))
    ship:addPart(4, 3, parts.Floor({6, 0, 1, 1, 1, 3}))
    ship:addPart(4, 4, parts.Floor({6, 0, 1, 1, 1, 3}))
    ship:addPart(4, 5, parts.Floor({6, 0, 1, 2, 2, 0, 2, 3}))
    ship:addPart(4, 6, parts.Bkg({11, 2})) 
    
    ship:addPart(5, 1, parts.Bkg({11, 0}))
    ship:addPart(5, 2, parts.Floor({6, 0, 1, 0, 1, 2}))
    ship:addPart(5, 3, parts.Bkg({11, 2})) 
    ship:addPart(5, 4, parts.Bkg({11, 0})) 
    ship:addPart(5, 5, parts.Floor({6, 0, 1, 0, 1, 2}))
    ship:addPart(5, 6, parts.Bkg({11, 2})) 
    
    ship:addPart(6, 1, parts.Bkg({12, 3}))
    ship:addPart(6, 2, parts.Bkg({11, 3}))
    ship:addPart(6, 3, parts.Bkg({12, 2}))
    ship:addPart(6, 4, parts.Bkg({12, 3}))
    ship:addPart(6, 5, parts.Bkg({11, 3}))
    ship:addPart(6, 6, parts.Bkg({12, 2}))
	
	return ship
end
