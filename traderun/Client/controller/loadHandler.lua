-- The tileset is loaded and all individual images will be extracted, including rotated duplicates
-- This is necessary as the orientation value used for the draw operations is already used to reflect
-- the ship orientation. A different orientation value for a specific tile would rotate the tile around
-- the draw origin of the image (-> out of sync with the rest of the ship). Therefore we need prerotated
-- copies for every tile that looks different when rotated

-- copys an image at the specified location from the src and returns it
-- the offset values describe the position of the tile to be copied in the src
local function copyImage(src, xOffset, yOffset, tSize)
	local imageData = love.image.newImageData( tSize, tSize )
	imageData:paste(src, 0, 0, (xOffset - 1) * tSize, (yOffset - 1) * tSize, tSize, tSize )
	return imageData
end

-- loads all image files 
function loadHandler_loadImages()

	local tileset = love.image.newImageData("res/images/tileset.png")
	tiles = {} -- all tiles are stored in here
	
	local tileIndex = 1 -- loop variable
	for i=1,10 do -- row number
		for j=1,10 do -- column number
			tiles[tileIndex] = copyImage(tileset, j, i, TILE_SIZE)
			tileIndex = tileIndex + 1
		end
	end
    
    doorClosedImage = love.graphics.newImage(tiles[6])
    particleImage = love.graphics.newImage("res/images/particle.png")
	thrusterImage = love.graphics.newImage("res/images/thruster.png")
    
    asteroidImages = {}
    asteroidImages[1] = love.graphics.newImage(tiles[91])
    asteroidImages[2] = love.graphics.newImage(tiles[92])
    

	local charset = love.image.newImageData("res/images/charset.png")
	tilesChar = {}
	
	local tileIndex = 1 -- loop variable
	for i=1,10 do -- row number
		for j=1,10 do -- column number
			tilesChar[tileIndex] = love.graphics.newImage(copyImage(charset, j, i, TILE_SIZE_CHAR))
			tileIndex = tileIndex + 1
		end
	end
end

