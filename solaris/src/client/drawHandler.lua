-- the draw handler contains all camera handling
-- and draw related code


local scale = 1.0           -- the current scaling 
local tileWidth = 32        -- default texture width
local tileHeight = 32       -- default texture height
local xtrans = 0            -- default camera x-transposition
local ytrans = 0         -- default camera y-transposition
local scales = {0.5, 1, 2}  -- all possible scale levels
local timer = 0             -- time the game is running. can be used for all sorts of calculations


local function applyFloorTransformations()
	love.graphics.origin()
	love.graphics.translate(love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
    love.graphics.scale(scale * 2, scale)
    love.graphics.rotate(-math.pi / 4)
    love.graphics.translate(-love.graphics:getWidth() / 2, -love.graphics:getHeight() / 2)
    love.graphics.translate(-xtrans, -ytrans)
end

local function applyObjectTransformations()
	love.graphics.origin()
	love.graphics.translate(love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
    love.graphics.scale(scale, scale)
    love.graphics.rotate(-math.pi / 4)
    love.graphics.translate(-love.graphics:getWidth() / 2, -love.graphics:getHeight() / 2)
    love.graphics.translate(-xtrans * 2, -ytrans)
end

-- converts the given screen coordinates to world coordinates
function drawHandler_screenToTiles(x, y)
    
    local xs = love.graphics:getWidth() / 2
    local ys = love.graphics:getHeight() / 2
    
    -- screen center to origin and scale
    local xt = (x - xs) / (2 * scale)
    local yt = (y - ys) / scale
    
    -- rotate 
    local xn = xt * math.cos(math.pi / 4) - yt * math.sin(math.pi / 4)
    local yn = xt * math.sin(math.pi / 4) + yt * math.cos(math.pi / 4)
    
    -- origin to screen center and shift
    xn = xn + xs + xtrans
    yn = yn + ytrans + ys
    
    return math.floor(xn / tileWidth) + 1, math.floor(yn / tileWidth) + 1
end

-- converts the given world coordinates to screen coordinates
function drawHandler_tilesToScreen(x, y)
    
    local xs = love.graphics:getWidth() / 2
    local ys = love.graphics:getHeight() / 2
    
    
    local xt = (x - 1) * tileWidth - xtrans - xs
    local yt = (y - 1) * tileHeight - ytrans - ys
    
    local xn = xt * math.cos(-math.pi / 4) - yt * math.sin(-math.pi / 4)
    local yn = xt * math.sin(-math.pi / 4) + yt * math.cos(-math.pi / 4)
    
    xn = xn * 2 * scale
    yn = yn * scale
    
    return xn + xs, yn + ys
end


-- load all textures
-- TODO: overwrite default values by reading from file
function drawHandler_init()
    local tiles = love.image.newImageData( "res/tileset.png" )
    tileset = {}
	local tempData = love.image.newImageData(tileWidth, tileHeight)
	tempData:paste(tiles, 0, 0, tileWidth, 0, tileWidth, tileHeight)
    tileset["floor"] = love.graphics.newImage( tempData )
    tempData:paste(tiles, 0, 0, tileWidth * 2, 0, tileWidth, tileHeight)
    tileset["wall"] = love.graphics.newImage( tempData )
    tempData:paste(tiles, 0, 0, tileWidth * 3, 0, tileWidth, tileHeight)
    tileset["barrel"] = love.graphics.newImage( tempData )
    
    local tiles = love.image.newImageData( "res/charset.png" )
    charset = {}
    tempData = love.image.newImageData(64, 64)
    tempData:paste(tiles, 0, 0, 0, 0, 64, 64)
    charset["standing"] = love.graphics.newImage( tempData )
end


function drawHandler_zoomIn()
    
    if scale == scales[2] then
        scale = scales[3]
    end
    
    if scale == scales[1] then
        scale = scales[2]
    end
    
end

function drawHandler_update(dt)
    timer = timer + dt
end


function drawHandler_zoomOut()

    if scale == scales[2] then
        scale = scales[1]
    end
    
    if scale == scales[3] then
        scale = scales[2]
    end
    
end


-- move the camera into the Direction specified
function drawHandler_shift(dir)

    if dir == "up" then
        ytrans = ytrans - 50
        xtrans = xtrans + 50
    end
    
    if dir == "left" then
        ytrans = ytrans - 50
        xtrans = xtrans - 50
    end
    
    if dir == "down" then
        ytrans = ytrans + 50
        xtrans = xtrans - 50
    end
    
    if dir == "right" then
        ytrans = ytrans + 50
        xtrans = xtrans + 50
    end
    
end


-- main draw function
function drawHandler_draw()
    
    -- setup colors
    love.graphics.setBackgroundColor(10, 50, 130, 255) -- * (math.sin(timer / 5) + 1), 30 * (math.cos(timer / 4) + 1), 10 + 30 * (math.sin( timer / 3) + 1), 255)
    love.graphics.setColor(255, 255, 255, 255)
    
    -- draw sea
    local tiles = core_getSea()
    
    local objects = core_getObjects()
    
    local x0 = drawHandler_screenToTiles(0, love.graphics:getHeight())
    local xt = drawHandler_screenToTiles(love.graphics:getWidth(), 0)
    local xtrash, y0 = drawHandler_screenToTiles(0, 0)
    local xtrash2, yt = drawHandler_screenToTiles(love.graphics:getWidth(), love.graphics:getHeight())
    
	yt = yt + 2
	x0 = x0 - 1
    
    for i = xt,x0,-1 do
        
        for j = y0,yt do
        
			if tiles[i] ~= nil and tiles[i][j] ~= nil then
        
				applyFloorTransformations()
				
				local level = tiles[i][j].level
				
				if tiles[i][j].__name == nil then
				
					love.graphics.rectangle('line', (i - 1) * tileWidth, (j - 1) * tileHeight, tileWidth, tileHeight)
				
				elseif tiles[i][j].__name == 'Tile'then
				
					love.graphics.draw(tileset["floor"], (i - 1) * tileWidth, (j - 1) * tileHeight)
					
				elseif tiles[i][j].__name == 'Box' then
					
					if tiles[i - 1] == nil or tiles[i - 1][j].level < level then
						love.graphics.draw(tileset["wall"], (i - 2.5 + level) * tileWidth, (j + 0.5 - level) * tileHeight, 0, 1.5, 1, 0, 0, 0, -1.5)
					end
					
					if tiles[i][j + 1] == nil or tiles[i][j + 1].level < level then
						love.graphics.draw(tileset["wall"], (i - 1 + level) * tileWidth, (j - 0 - level) * tileHeight, 0, 1, 1.5, 0, 0, -1.5, 0)
					end
					
					love.graphics.draw(tileset["wall"], (i - 1 + level) * tileWidth, (j - 1 - level) * tileHeight)
					
				end
				
				-- if objects are located at tile daw them as well
				love.graphics.origin()
					
				for k,thing in pairs(objects[i][j]) do

					local x, y = drawHandler_tilesToScreen(thing.x + thing.level, thing.y - thing.level)
					
					if thing.__name == 'Spaceman' then
						love.graphics.draw(charset["standing"], x, y, 0, scale, scale, 64 / 2, 64 * 0.9)
					end
					
				end

			end
            
        end
                
    end
    
    -- reset coordinate grid
    love.graphics.origin()
      
    -- draw debug info box
    if DEBUG then
    
		love.graphics.setColor(10, 50, 130, 255)
		love.graphics.rectangle('fill', 0, 0, 120, 30)
		love.graphics.setColor(230, 230, 230, 220)
		love.graphics.rectangle('line', 0, 0, 120, 30)
		local delta = love.timer.getAverageDelta()
		love.graphics.print(string.format("Avg f/s: %.2f ms", 1000 / (1000 * delta)), 10, 10)
		
    end
    
end
