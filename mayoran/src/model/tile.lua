
Tile = class()

Tile.__name = "Tile"

function Tile:__init(terrainType)
    
    self.structure = nil -- if a structure is built, it can be found here
    
    if terrainType == "grass" then
        self.image = "grass"..math.random(1,5)
    end
    
    if terrainType == "cliff" then
        self.image = "cliff"..math.min(4, math.random(1,8))
    end
    
    if terrainType == "rock" then
        self.image = "rock"
    end
    
    self.buildable = true
    
end