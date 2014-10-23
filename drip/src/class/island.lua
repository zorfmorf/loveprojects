
require "class.tile"

Island = Class {}


function Island:init(x, y)
    self.x = x
    self.y = y
    self.xmin = 0
    self.xmax = 0
    self.ymin = 0
    self.ymax = 0
    self.h = 1
    self.tiles = {}
    for i=0,5 do
        for j=0,5 do
            self:addTile(i, j, Tile())
        end
    end
    
    self:redraw()
end


function Island:redraw()
    self.canvas = drawHandler.generateIslandCanvas(self)
end


function Island:addTile(x, y, tile)
    if not self.tiles[y] then self.tiles[y] = {} end
    self.tiles[y][x] = tile
    if x > self.xmax then self.xmax = x end
    if x < self.xmin then self.xmin = x end
    if y > self.ymax then self.ymax = y end
    if y < self.ymin then self.ymin = y end
    if #tile.textures > self.h then self.h = #tile.textures end
end


function Island:getTile(x, y)
    if not self.tiles[y] then return nil end
    if not self.tiles[y][x] then return nil end
    return self.tiles[y][x]
end


-- returns center coordinates: x, y
function Island:getCenter()
    return self.x + self.xmax / 2, self.y + self.ymax / 2
end
