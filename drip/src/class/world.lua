
require "class.island"

World = Class {}


function World:init(player)
    
    local island = Island(1, 1)
    self.islands = {}
    table.insert(self.islands, island)
    
    self.factions = {}
    table.insert(self.factions, player)
    
end


function World:redraw()
    for i,island in ipairs(self.islands) do
        island:redraw()
    end
end
