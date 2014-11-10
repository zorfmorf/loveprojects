
local xshift = 0 -- center of screen
local yshift = 0 -- center of screen
local scale = 1
local scaleV = {1.0, 1.25, 1.5, 1.75, 2, 2.25}

tilesize = 32

local startupTime = 5

local stars = nil
local bkg = nil
local bkgrotation = 0

local brightness = 255 -- if < 255 it dimms the whole world down

worldDrawer = {}

function worldDrawer.init()
    
    xshift = 0
    yshift = 600
        
    local size = math.max(love.graphics:getWidth(), love.graphics:getHeight())
    local imgData = love.image.newImageData(size, size)
    for i=1,size*2 do
        
        local x, y = math.random(1, size - 2), math.random(1, size - 2)
       
        imgData:setPixel(x, y, 255, 255, 255, 255)
        imgData:setPixel(x + 1, y,  255, 255, 255, 100)
        imgData:setPixel(x, y + 1, 255, 255, 255, 100)
        imgData:setPixel(x - 1, y, 255, 255, 255, 100)
        imgData:setPixel(x, y - 1, 255, 255, 255, 100)
        
    end
    stars = love.graphics.newImage(imgData)
    
end

function worldDrawer.update(dt)
    
    bkgrotation = bkgrotation - dt * 0.01
   
end

function worldDrawer.generateBackground(imgData)
    
    for i = 0,imgData:getHeight() - 1 do
       
        local factor = math.max(0, i - love.graphics:getHeight() / 2.9) / (imgData:getHeight() - 1) 
       
        for j= 0,imgData:getWidth() - 1 do
            

            local r, g, b, a = imgData:getPixel(j, i)
            
            imgData:setPixel(j, i, r, g, b, math.floor(a * factor))
           
        end
        
    end
    
    bkg = love.graphics.newImage(imgData)
end

function worldDrawer.convertCoordinates(x, y)
    
    local nx = (x - love.graphics.getWidth() / 2) / scaleV[scale] - xshift
    local ny = (y - love.graphics.getHeight() / 2) / scaleV[scale] - yshift
    
    return nx, ny
    
end

function worldDrawer.draw()

    love.graphics.setBackgroundColor(10, 15, 15, 15)
    
    love.graphics.setColor(150, 200, 210, 200)
    
    love.graphics.draw(stars, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, bkgrotation, 
        1, 1, stars:getWidth() / 2, stars:getWidth() / 2)
    love.graphics.draw(bkg, 0, 0)
    
    
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.scale(scaleV[scale], scaleV[scale])
    love.graphics.translate(xshift, yshift)
    

    love.graphics.setColor(brightness, brightness, brightness, 255)
    
    local x, y = worldDrawer.convertCoordinates(love.mouse.getPosition()) -- get mouse position to handle mouse over highlighting
    
    local lineHeight = 0
    
    for i,layer in pairs(world.layers) do
        
        
        lineHeight = lineHeight + 1
        local baseHeight = (i - 1) * LAYER_HEIGHT
        local centerXIndex = math.floor(#layer.rim[1] / 2)
        local centerYIndex = math.floor(#layer.rim / 2)
        
        -- draw outline down
        if i <= currentLayer then     
            
            for j,row in pairs(layer.rim) do
                
                local mod = 0
                if j > 2 then mod = 1 end
                
                for k,entry in pairs(row) do
                    if entry ~= nil then
                        love.graphics.draw(tileset[entry.image], 
                                            world.x + (k - centerXIndex) * tilesize + mod * tilesize, 
                                            world.y + (j - centerYIndex  - baseHeight) * tilesize,
                                            0, 1, 1, tilesize / 2, tilesize / 2)
                    end
                end
            end
        end
        
        if i == currentLayer then
            
            -- definition line
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.line(world.x + tilesize / 2, world.y + tilesize * 2.5, world.x + tilesize / 2, world.y - lineHeight * tilesize * 4)   

            local heightm = #layer.terrain / 2
            
            -- draw tiles
            for j,row in pairs(layer.terrain) do                
                
                for k,entry in pairs(row) do
                    
                    love.graphics.setColor(brightness, brightness, brightness, 255)
                    
                    love.graphics.draw(tileset[entry.image], 
                                        world.x + (k - centerXIndex - 1) * tilesize, 
                                        world.y + (j - centerYIndex  - baseHeight) * tilesize - (heightm + 1) * tilesize,
                                        0, 1, 1, tilesize / 2, tilesize / 2)
                                    
                     if mouseState ~= "free" and 
                        math.abs(x - (world.x + (k - centerXIndex - 1) * tilesize)) < tilesize / 2 and
                        math.abs(y - (world.y + (j - centerYIndex  - baseHeight) * tilesize - (heightm + 1) * tilesize)) < tilesize / 2 then
                        
                        if entry.buildable then 
                            local img = mouseState
                            if entry.structure == nil then
                                love.graphics.setColor(brightness - 150, brightness - 75, brightness - 150, 255)
                                if love.mouse.isDown("l") then gameHandler.tileClicked(k, j, entry) end
                            else
                                love.graphics.setColor(brightness, brightness - 150, brightness - 150, 255)
                            end
                            love.graphics.draw(tileset[img],
                                        world.x + (k - centerXIndex - 1) * tilesize, 
                                        world.y + (j - centerYIndex  - baseHeight) * tilesize - (heightm + 1) * tilesize,
                                        0, 1, 1, tilesize / 2, tilesize / 2)
                        end
                        
                    end
                    
                    
                end 
            end
            
            -- draw structure on tile
            for i,struct in pairs(layer.structures) do
                
                love.graphics.setColor(brightness, brightness, brightness, 255)
                
                if struct.selectable and mouseState == "free" and
                    math.abs(x - (world.x + (struct.x - centerXIndex - 1) * tilesize)) < tilesize / 2 and
                    math.abs(y - (world.y + (struct.y - centerYIndex  - baseHeight) * tilesize - (heightm + 1) * tilesize)) < tilesize / 2 then
                    love.graphics.setColor(250, 150, 150, 255)
                    if love.mouse.isDown("l") then gameHandler.structClicked(struct) end
                end
                
                if struct.selected then love.graphics.setColor(250, 150, 150, 255) end
                
                for i,img in pairs(struct:getImages()) do
                    local ymod = 0
                    if struct:is(Waterfall) then ymod = i - 1 end
                    love.graphics.draw(img, 
                                world.x + (struct.x - centerXIndex - 1) * tilesize, 
                                world.y + (struct.y - centerYIndex  - baseHeight) * tilesize - (heightm + 1) * tilesize + ymod * tilesize,
                                0, 1, 1, tilesize / 2, tilesize / 2)
                end
                
            end
            
            -- draw all villagers
            love.graphics.setColor(brightness, brightness, brightness, 255)
            for i,villager in pairs(layer.villagers) do
                
                love.graphics.draw(charset[villager:getImage()], 
                                        world.x + (villager.x - centerXIndex - 1) * tilesize, 
                                        world.y + (villager.y - centerYIndex  - baseHeight) * tilesize - (heightm + 0.5) * tilesize,
                                        0, 1, 1, 16, 12)
                
            end
        end
    end
end


function worldDrawer.camera_shift(x , y)
   
   xshift = xshift + x / scaleV[scale]
   yshift = yshift + y / scaleV[scale]
    
end

function worldDrawer.camera_left()
    xshift = xshift + 100
end

function worldDrawer.camera_right()
    xshift = xshift - 100
end

function worldDrawer.camera_up()
    yshift = yshift + 100
end

function worldDrawer.camera_down()
    yshift = yshift - 100
end

function worldDrawer.camera_zoomOut()
    scale = math.min(scale + 1, #scaleV)
end

function worldDrawer.camera_zoomIn()
    scale = math.max(scale - 1, 1)
end