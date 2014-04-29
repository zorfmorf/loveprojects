
-- placeholder map grid
local map = nil
local timer = 0


-- setup data representing a map
function core_init()

end


-- update level data
function core_update(dt)
    timer = timer + dt	
end


-- return the map object
function core_getMap()
    return map
end
