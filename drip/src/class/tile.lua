-- The world consists of a tile grid. Every tile has a texture and a type

Tile = Class {}

function Tile:init(height, tileType)
    self.textures = {}
    for i=1,height-1 do
        table.insert(self.textures, "tileDirt_full") 
    end
    table.insert(self.textures, tileType)
    self.building = nil
end

-- draw the tile to the specified coordinates
function Tile:draw(x, y)
    love.graphics.draw(tileset.base.tiles, tileset.base.quads[tile.textures[self.h]], 
end


-- Grass tile
TGrass = Class{ __includes = Tile,
    init = function(self, height)
        Class.init(self, height, "tileGrass")
    end
}

-- Grass tile
TGrass = Class{ __includes = Tile,
    init = function(self, height)
        Class.init(self, height, "tileGrass")
    end
}

