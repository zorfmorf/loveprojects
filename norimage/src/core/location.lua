--[[
Location

A location can be visited by a player
--]]


Location = class()


-- begin properties
Location.__name = "Location" -- debugging purposes
Location.name = "Location"
Location.description = "This is a location"
Location.active = false
Location.actors = {} -- a location has a set of actors
Location.image = nil
-- end properties


function Location:__init()
    
end

function Location:activate()
    self.active = true
end
