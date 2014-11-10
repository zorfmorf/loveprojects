
tasklist = nil -- list of all available tasks

local timeSinceLastUpdate = 0
local timeBetweenUpdates = 0.5 -- we don't want to do expensive task assignment calculations too often

taskHandler = {}


-- record of available ressources
availableRessources = nil

local buildQueue = nil -- buildings that are currently built

function taskHandler.init()
    tasklist = {}
    buildQueue = {} 
    availableRessources = {}
    availableRessources["log"] = {}
    availableRessources["planks"] = {}
    availableRessources["stone"] = {}
    availableRessources["iron"] = {}
    availableRessources["gold"] = {}
end

-- add a log to the list of available logs
function taskHandler.addRessource(res, source)
    table.insert(availableRessources[res], source)
end

function taskHandler.update(dt)
    
    timeSinceLastUpdate = timeSinceLastUpdate + dt
    
    if timeSinceLastUpdate > timeBetweenUpdates then
        
        -- create carry and build tasks for buildings
        local removalQueue = {} -- list of all build tasks that can be removed
        if #buildQueue > 0 then
            for i=1,#buildQueue do
                
                local build = buildQueue[i]
                local ready = true -- whether the building can be completed
                
                for res,amount in pairs(build.cost) do 
                    if build.sent[res] < amount then
                        if #availableRessources[res] > 0 then
                            
                            local source = table.remove(availableRessources[res], 1)
                            local carryTask = CarryTask:new(source, build, res)
                            table.insert(tasklist, carryTask)
                            build.sent[res] = build.sent[res] + 1
                            
                        end
                    end
                    if build.ressources[res] == nil or build.ressources[res] < amount then
                        ready = false
                    end
                end
                
                if ready then
                    table.insert(removalQueue, i)
                    table.insert(tasklist, WorkTask:new(build))
                end
            end
        end
        
        -- remove all buildQueue elements that have been handled to completion
        if #removalQueue > 0 then
            for i=#removalQueue,1,-1 do
                table.remove(buildQueue, removalQueue[i])
            end
        end
        
        -- assign tasks to villagers
        local nextTask = nil
        if #tasklist > 0 then
            nextTask = tasklist[1]        
        end
        if nextTask ~= nil then
            
            if #world.layers[nextTask.target.layer].villagers > 0 then
                
                local candidates = {}
            
                for i,villager in pairs(world.layers[nextTask.target.layer].villagers) do
                    
                    if villager.task == nil then table.insert(candidates, villager) end
                    
                end
                
                -- TODO: check other layers for untasked villagers as well
                if #candidates > 0 then
                        
                        local chosenOne = candidates[math.random(1, #candidates)]
                        chosenOne:addTask(nextTask)
                        table.remove(tasklist, 1)
                        
                end
                
            end
            
        end
        
        timeSinceLastUpdate = 0
    end
    
end

function taskHandler.addRessourceTask(ressource)
    
    if ressource:is(Ressource) and not ressource.selected then
        ressource.selected = true
        local task = WorkTask:new(ressource)
        table.insert(tasklist, task)
        print("Added task "..task.__name.." for "..ressource.__name)
    else
        print("Error: Trying to add ressource "..ressource.__name)
    end
    
end

-- a build task is
function taskHandler.addBuildTask(target)
    for res,amount in pairs(target.cost) do
        target.sent[res] = 0
    end
    table.insert(buildQueue, target)
end

function taskHandler.removeQueuedTask(index)
    table.remove(tasklist, index)
end