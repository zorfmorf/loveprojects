-- The tileset is loaded and all individual images will be extracted, including rotated duplicates
-- This is necessary as the orientation value used for the draw operations is already used to reflect
-- the ship orientation. A different orientation value for a specific tile would rotate the tile around
-- the draw origin of the image (-> out of sync with the rest of the ship). Therefore we need prerotated
-- copies for every tile that looks different when rotated
function loader_loadImages()
	local tileset = love.image.newImageData("res/images/tileset.png")
	tileSize = 64 -- important, global -- size of an individual square ship tile
	tiles = {} -- all tiles are stored in here
	
	local tileIndex = 1 -- loop variable
	for i=1,10 do -- row number
		for j=1,10 do -- column number
			tiles[tileIndex] = loader_copyImage(tileset, j, i, tileSize)
			tiles[tileIndex]:setFilter("linear", "linear")
			tileIndex = tileIndex + 1
		end
	end
    
    particleImage = love.graphics.newImage("res/images/particle.png")
	thrusterImage = love.graphics.newImage("res/images/thruster.png")
	
	local charset = love.image.newImageData("res/images/charset.png")
	tileSizeChar = 32
	tilesChar = {}
	
	local tileIndex = 1 -- loop variable
	for i=1,10 do -- row number
		for j=1,10 do -- column number
			tilesChar[tileIndex] = loader_copyImage(charset, j, i, tileSizeChar)
			tilesChar[tileIndex]:setFilter("linear", "linear")
			tileIndex = tileIndex + 1
		end
	end
end

-- copys an image at the specified location from the src and returns it
-- the offset values describe the position of the tile to be copied in the src
function loader_copyImage(src, xOffset, yOffset, tSize)
	local imageData = love.image.newImageData( tSize, tSize )
	imageData:paste(src, 0, 0, (xOffset - 1) * tSize, (yOffset - 1) * tSize, tSize, tSize )
	return love.graphics.newImage( imageData )
end
