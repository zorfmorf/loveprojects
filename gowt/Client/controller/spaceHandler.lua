-- Handle a sector of space, the background and all objects it contains
-- example: Space Station, Asteroids, all ships in the area and the background

-- the following vars are global because they are used by the drawHandler
nebula = nil -- the background nebula
bkgStars = nil -- an array containing all the stars in the background

local function addAsteroid(index, tmp)
	local asteroid = objects.Asteroid(math.random(-20000, 20000), math.random(-20000, 20000), 0, math.random(-4, 4), math.random(-500, 500), math.random(-500, 500), 0.5 + math.random(0,6) * 0.5)
	layers[index][asteroid.id] = asteroid
    
    if index == LAYER_SHIP and (tmp == 50 or tmp == 49) then
        asteroid.x = -400
        if tmp == 49 then asteroid.x = -600 end
        asteroid.y = 0
        asteroid.xm = 40
        asteroid.ym = 0
        asteroid.size = 1
    end
end

-- init function
function spaceHandler_init()
	
	-- create and fill entities list for the different layers
	layers = {}
	for m=1,LAYER_SIZE do
		layers[m] = {}
		for i=2,50 do
			addAsteroid(m, i)
		end
	end
	--add ship to central layer
	layers[LAYER_SHIP][main_ship.id] = main_ship
end

-- create all background images (layered on top of each other)
function spaceHandler_createBkg(nebulaData)
	nebula = love.graphics.newImage(nebulaData)
	
	local w = math.max(love.graphics:getWidth(), love.graphics:getHeight()) * 2
	local h = w
	bkgStars = {}
	for j=1,3 do
		local imgData = love.image.newImageData( w, h )
		local amount = w * h / 1000
		for i=1,amount / j do
            if j == 1 then
                local l,e = math.random(0, w - 1), math.random(0, h - 1)
                imgData:setPixel(l, e, 255, 255, 255, 255)
            else
                local l,e = math.random(0, w - 3), math.random(0, h - 3)
                imgData:setPixel(l + 1, e, 255, 255, 255, 255)
                imgData:setPixel(l + 1, e + 1, 255, 255, 255, 255)
                imgData:setPixel(l, e + 1, 255, 255, 255, 255)
                imgData:setPixel(l + 2, e + 1, 255, 255, 255, 255)
                imgData:setPixel(l + 1, e + 2, 255, 255, 255, 255)
            end
		end
		bkgStars[j] = love.graphics.newImage(imgData)
	end
end

-- called whenever an asteroid gets destroyed
function spaceHandler_asteroidDestroyed(index, asteroid)
	-- delete asteroid from layers
	asteroid.leaf:delete(asteroid)
	layers[index][asteroid.id] = nil
	addAsteroid(index)
end
