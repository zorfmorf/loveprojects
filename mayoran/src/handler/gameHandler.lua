
world = nil -- the world
currentLayer = 1

buildings = nil -- the buildable structures

mouseState = "free" -- the state of the mouse pointer

local clicked = false

gameHandler = {}

function gameHandler.init(size)
    
    world = World:new(size)
    currentLayer = size
    
    ressources = {}
    
    buildings = {}
    buildings[1] = "hut"
    buildings[2] = "woodcutter"
    
end


function gameHandler.update(dt)
    
    for i,layer in pairs(world.layers) do
        
        for j,villager in pairs(layer.villagers) do
            
            villager:update(dt)
            
        end
        
    end
    
end

function gameHandler.isLowestLevel()
    return currentLayer == 1
end

function gameHandler.isHighestLevel()
    return currentLayer == #world.layers
end

-- if possible increase the active layer by one
function gameHandler.moveUp()
    if world.layers[currentLayer + 1] ~= nil then currentLayer = currentLayer + 1 end
end

-- if possible decrease the active layer by one
function gameHandler.moveDown()
    if world.layers[currentLayer - 1] ~= nil then currentLayer = currentLayer - 1 end
end

function gameHandler.click()
    clicked = true
end

function gameHandler.buildIconClicked(item)
    
    if clicked then
        
        clicked = false
        love.mouse.setVisible(false)
        mouseState = item
        
    end
    
end

function gameHandler.structClicked(struct)
    
    if clicked then
        clicked = false
        
        if mouseState == "free" then
            if not struct.selected then
                if struct.__name == "tree" then
                    taskHandler.addRessourceTask(struct)
                end
            end
        end
    end
end

function gameHandler.tileClicked(x, y, tile)
    
    if clicked then 
        clicked = false
        
        if mouseState ~= "free" and tile.structure == nil and tile.buildable then
            
            local struct = nil
            if mouseState == "hut" then struct = Hut:new(x, y, currentLayer) end
            if mouseState == "woodcutter" then struct = Woodcutter:new(x, y, currentLayer) end
            world.layers[currentLayer]:addStructure(struct)
            taskHandler.addBuildTask(struct)
            mouseState = "free"
            love.mouse.setVisible(true)
            
        end
    end
end

-- when the user clicks on a queued task in the taskbar
function gameHandler.taskClicked(index)
    
    if clicked then
        clicked = false
        
        if mouseState == "free" then
            local task = tasklist[index]
            taskHandler.removeQueuedTask(index)
            task.target.selected = false
        end
        
    end
end

function gameHandler.deselect()
    if clicked then clicked = false end
    love.mouse.setVisible(true)
    mouseState = "free" 
end