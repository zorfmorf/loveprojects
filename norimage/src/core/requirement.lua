--[[
Requirement

A requirement can be fulfilled by the player. Possibilites:
 * an item
 * skill level
 * a hint
 * ...
--]]


Requirement = class()


-- begin properties
Requirement.__name = "Requirement" -- debugging purposes
Requirement.description = "Skill: level" -- possibly used in conversations?
-- end properties


-- Check this requirement for specified player
function Requirement:isMet(player)
    -- TODO: implement
    return true
end