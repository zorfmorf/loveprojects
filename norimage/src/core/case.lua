--[[
Case

A case to be solved by a player
--]]


Case = class()


-- begin properties
Case.__name = "Case" -- debugging purposes
Case.title = "The missing Case file"
Case.description = "A smith hired me to find a missing case file"
Case.starthints = {}
-- end properties


function Case:__init(hints)
    assert(hints ~= nil)
    self.hints = hints
end
