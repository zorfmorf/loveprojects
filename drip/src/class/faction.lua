--[[
    
    A faction
    
]]--

Faction = Class {}

function Faction:init(name)
    self.name = name
    self.buildings = {}
end
