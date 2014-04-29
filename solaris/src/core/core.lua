
MAP_MAX = 50
MAP_MIN = 1

local sea = nil -- placeholder map grid
local objects = nil -- hashed object list for priority drawing
local globalobjects = nil -- simple object list for updates
timer = 0


-- setup data
function core_init()

	awareness_init()
	
    sea = {}
    objects = {}
    for i=MAP_MIN,MAP_MAX do
        sea[i] = {}
        objects[i] = {}
        for j=MAP_MIN,MAP_MAX do
			
			objects[i][j] = {}
        
            sea[i][j] = Box:new()
            sea[i][j].speedup = (math.random() - 0.5) * 5
			sea[i][j].level = math.random(0, 15) * 0.1
			sea[i][j].shift = (math.random() - 0.5) / shift_current
			
        end
    end
    
    globalObjects = {}
    for i=1,10 do
		local spaceman = Spaceman:new()
		spaceman.x = math.random(MAP_MIN,MAP_MAX) + 0.5
		spaceman.y = math.random(MAP_MIN,MAP_MAX) + 0.5
		
		objects[math.floor(spaceman.x)][math.floor(spaceman.y)][spaceman.id] = spaceman
		globalObjects[spaceman.id] = spaceman
    end
    
end


-- update level data
function core_update(dt)

	timer = timer + dt
	
	-- update sea tiles
	for i,xl in pairs(sea) do
	
		for j,tile in pairs(xl) do
		
			if tile.__name == 'Box' then
			
				awareness_updateBox(tile, i, j)
			
			end
		
		end
		
	end
	
	-- update objects
	for i,object in pairs(globalObjects) do

		object:update(dt, objects)
		object:updateLevel(sea)
		
	end
	
	-- update awareness
	awareness_update(dt)
	
end


-- return the map object
function core_getSea()
    return sea
end


-- return objects
function core_getObjects()
	return objects
end


-- test method that inverts map tile defined
-- by the two indices (if valid)
-- returns true if successful
function core_switchTiles(i, j)
    if sea[i] ~= nil and sea[i][j] ~= nil then
            sea[i][j].level = 0
            return true
    end
    return false
end
