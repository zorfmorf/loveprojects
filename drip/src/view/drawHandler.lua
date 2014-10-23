
Camera = require "libraries.hump.camera"

drawHandler = {}

tileset = nil
local camera = nil
local cShift = 100 -- default camera shift value

-- hex grid modifiers
local xm = 32
local ym = 50
local zm = 22

-- saved graphics
local bkg = nil

function drawHandler.init()
    tileset = {}
    tileset.base = parseTilesetByXML("assets/", "base.xml")
    tileset.buildings = parseTilesetByXML("assets/", "buildings.xml")
    
    camera = Camera()
    camera:zoomTo(1)
end


function drawHandler.generateIslandCanvas(island)
    
    local baseH = (island.h-1) * zm
    
    local canvas = love.graphics.newCanvas(2 * xm * (island.xmax + 1) + xm, ym * (island.ymax + 2) + baseH)
    love.graphics.setCanvas(canvas)
    
    love.graphics.setColor(255, 255, 255, 255)
    
    -- draw debug information
    if state_ingame:isDebug() then love.graphics.rectangle("line", 0, 0, canvas:getWidth(), canvas:getHeight()) end
    
    -- draw island tiles
    for y=island.ymin,island.ymax do
        local evenrow = y % 2 -- y row even
        for x=island.xmax,island.xmin,-1 do
            local tile = island:getTile(x, y)
            if tile then
                for h=1,#tile.textures do
                    -- TODO CONTINUE THIS DRAW FROM TILE ITSELF
                    love.graphics.draw(tileset.base.tiles, tileset.base.quads[tile.textures[h]], 
                        x * xm * 2 + evenrow * xm, 
                        y * ym - (h-1) * zm + baseH)
                end
            end
        end
    end
    
    love.graphics.setCanvas()
    return canvas
end


function drawHandler.drawBkg()
    if not bkg then
        bkg = gradient {
            direction = 'horizontal';
            {173, 232, 239};
            {213, 252, 249};
        }
    end
    love.graphics.setColor(255, 255, 255, 255)
    drawinrect(bkg, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end


function drawHandler.drawIslands(islands)
    
    camera:attach()
    
    love.graphics.setColor(255, 255, 255, 255)
    for i,island in pairs(islands) do
        love.graphics.draw(island.canvas, island.x * xm, island.y * ym - (island.h - 1) * zm)
    end
    
    camera:detach()
    
end


function drawHandler.focusCamera(x, y)
    camera:lookAt(x * xm, y * ym)
end


function drawHandler.moveCamera(x, y)
    camera:move(x * cShift, y * cShift)
end
