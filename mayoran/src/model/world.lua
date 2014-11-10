
World = class()

World.__name = "World"

function World:__init(size)
    
    self.x = 0
    self.y = 0
    
    self.layers = {}
    
    for i=1,size do
        self.layers[i] = Layer:new(i)
        self.layers[i]:generateRim()
        if i == size then
            self.layers[i]:generateTerrain("grass")
        else
            self.layers[i]:generateTerrain("rock")
        end
    end
    
    -- TODO: remove following placeholder code    
    for i=1,3 do
        local villy = Villager:new(4 + i, 5, size)
        self.layers[size].villagers[villy.id] = villy
    end
    
end