--[[
    Contains a set of function calculating a new normalized velocity 
    vector depending on the required movement strategy
]]--


-- Seek function. (seek is reserved in lua)
-- try to reach target position as fast as possible
-- will overshoot and circle around target
local function search(caller, target)
    
    -- Get direction to target
    local vec = target.pos:sub(caller.pos)
    
    -- normalize and set to full speed
    vec = vec:norm()
    vec = vec:mult(caller.maxspeed)
    
    return vec
end


-- Like seek but slows down on approach
local function arrive(caller, target)
    
    -- Get direction to target
    local vec = target.pos:sub(caller.pos)
    
    -- If we are in target radius do nothing
    if vec:len() < 1 then return Vector:c(0, 0) end
    
    -- Arrive in exactly 0.25 seconds
    vec = vec:div(0.75)
    
    -- If too fast, reduce to maxspeed
    if vec:len() > caller.maxspeed then
        vec = vec:norm()
        vec = vec:mult(caller.maxspeed)
    end
    
    return vec
end


-- Aimlessly wander arround
local function wander(caller)
    
    -- We want to modify the callers current velocity vector
    local vec = caller.pos
    
    -- calculate random rotation based on current velocity vector
    local a = math.atan2(vec.y, vec.x) -- curent angle
    local rot = math.pi * 0.75 -- potential rotation area pi*2 means will circle on place
    a = rot * math.random() - rot / 2
    
    -- apply rotation
    vec = Vector:c(vec.x * math.cos(a) - vec.y * math.sin(a), 
                   vec.x * math.sin(a) + vec.y * math.cos(a))
    
    -- normalize and set to full speed
    vec = vec:norm()
    vec = vec:mult(caller.maxspeed / 4)
    
    return vec
end


-- Flee function
-- inverse of seek
local function flee(caller, target)
    
    -- Get direction away from target
    local vec = caller.pos:sub(target.pos)
    
    -- normalize and set to full speed
    vec = vec:norm()
    vec = vec:mult(caller.maxspeed)
    
    return vec
end



return {
    search = search,
    flee = flee,
    arrive = arrive,
    wander = wander,
}