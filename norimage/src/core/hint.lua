--[[
Hint

A hint represents a piece of information which unlocks new
actors and/or locations.
If a hint is activated, it activates its target set.
A target can be 
 * a location
 * an actor
 * a hintcombinator ->
--]]


Hint = class()


-- begin properties
Hint.__name = "Hint" -- debugging purposes
Hint.title = "Hint"
Hint.description = "Where did we get that hint? What does it say?"
Hint.active = false
Hint.targets = {} -- a hint can have one or more targets
-- end properties


function Hint:activate()
    if not self.active then
        for i,target in pairs(self.targets) do
            target:activate()
        end
    end
end