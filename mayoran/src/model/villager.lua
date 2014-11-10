VILLAGER_ID = 1
VILLAGER_SPEED = 2

Villager = class()

Villager.__name = "villager"

function Villager:__init(x, y, layer)
    self.x = x
    self.y = y
    self.layer = layer
    self.id = VILLAGER_ID
    VILLAGER_ID = VILLAGER_ID + 1
    self.state = "idle"
    self.animdirection = "left"
    self.cycle = 0
    self.backback = nil -- villagers can carry one ressource
end

function Villager:addTask(task)
    self.task = task
    self.state = "walking"
    print("Villager "..self.id..": Got Task assigned: "..task.__name)
end


function Villager:generatePath()
    
    
    local task = nil
    
    if self.task:is(CarryTask) and self.task.state == 0 then
        task = { x=self.task.source.x, y=self.task.source.y}
    else
        task = { x=self.task.target.x, y=self.task.target.y}
    end
    local current = { x=math.floor(self.x + 0.5), y=math.floor(self.y + 0.5) }
    
    if self.layer ~= self.task.layer then
        -- TODO: add shaft as target
    end
    
    self.path = {}
    
    local i = 0
    while math.abs(current.x - task.x) >= 1 
        or math.abs(current.y - task.y) >= 1 do
        
        local directions = {} -- possible valid walking directions
        
        if current.x < task.x and
           world.layers[self.layer].terrain[current.y][current.x + 1] ~= nil then 
            table.insert(directions, "right")
        end
        
        if current.x > task.x and
           world.layers[self.layer].terrain[current.y][current.x - 1] ~= nil then 
            table.insert(directions, "left")
        end
        
        if current.y < task.y and
           world.layers[self.layer].terrain[current.y + 1] ~= nil and 
           world.layers[self.layer].terrain[current.y + 1][current.x] ~= nil then 
            table.insert(directions, "down")
        end
        
        if current.y > task.y and
           world.layers[self.layer].terrain[current.y - 1] ~= nil and 
           world.layers[self.layer].terrain[current.y - 1][current.x] ~= nil then 
            table.insert(directions, "up")
        end
        
        -- no direct route to target possible, we need to go another direction
        if #directions == 0 then
            if world.layers[self.layer].terrain[current.y][current.x + 1] ~= nil then 
                table.insert(directions, "right")
            end
            
            if world.layers[self.layer].terrain[current.y][current.x - 1] ~= nil then 
                table.insert(directions, "left")
            end
            
            if world.layers[self.layer].terrain[current.y + 1] ~= nil and 
               world.layers[self.layer].terrain[current.y + 1][current.x] ~= nil then 
                table.insert(directions, "up")
            end
            
            if world.layers[self.layer].terrain[current.y - 1] ~= nil and 
               world.layers[self.layer].terrain[current.y - 1][current.x] ~= nil then 
                table.insert(directions, "down")
            end
        end
        
        local dir = directions[math.random(1, #directions)]
        print("Villager "..self.id..": added "..dir.." to path")
        table.insert(self.path, {dir, 0})
        
        if dir == "down" then current.y = current.y + 1 end
        if dir == "up" then current.y = current.y - 1 end
        if dir == "left" then current.x = current.x - 1 end
        if dir == "right" then current.x = current.x + 1 end
        
        i = i + 1
        if i > 1000 then print("Villager: Error in path calculation. Infinite loop") break end
    end
    
    print("Villager "..self.id..": generated Path to "..self.task.target.__name.." at "..self.task.target.x.."/"..self.task.target.y)
    
end

function Villager:update(dt)
    
    if self.task ~= nil then
      
        if self.state == "working" then
            
            -- carry tasks
            if self.task:is(CarryTask) then
                
                local source = self.task.source
                local target = self.task.target
                
                if self.task.state == 1 then
                    target:addRessource(self.backpack)
                    self.backpack = nil
                    self.task = nil
                    self.path = nil
                    self.state = "idle"
                else
                    self.state = "walking"
                    self.task.state = 1
                    self.backpack = self.task.res
                    source:removeRessource(self.task.res)
                end
            
            else
                -- other tasks
                local task = self.task.target
                
                local debugmod = 1
                if DEBUG then debugmod = 5 end
                
                task.dt = task.dt + dt * debugmod
                
                task:update()
                
                if task.dt >= task.time then
                    
                    task.dt = 0
                    task.amount = task.amount - 1
                    task:nextstate()
                    
                    if task.amount <= 0 then
                        self.task = nil
                        self.path = nil
                        self.state = "idle"
                    end
                    
                end
            end
            
        end
        
        if self.state == "walking" then
            
            if self.path == nil then self:generatePath() end
            
            -- if arrived
            if #self.path == 0 then 
                self.state = "working"
                print("Villager "..self.id..": arrived at task "..self.task.__name.." at "..self.x.."/"..self.y)
                if self.task:is(WorkTask) then self.task.target:nextstate() end
                self.path = nil
            else
            
                local dir = self.path[1]
                
                local amount = dt * VILLAGER_SPEED
                dir[2] = dir[2] + amount
                
                if dir[2] >= 1 then
                    amount = amount - (dir[2] - 1)
                    table.remove(self.path, 1)
                    print("Villager "..self.id..": finished "..dir[1])

                end
                
                if dir[1] == "left" then self.x = self.x - amount self.animdirection = "left" end
                if dir[1] == "right" then self.x = self.x + amount self.animdirection = "right" end
                if dir[1] == "up" then self.y = self.y - amount end
                if dir[1] == "down" then self.y = self.y + amount end
                
            end
        
        end
    end
    
    if self.state == "idle" then self.cycle = self.cycle + dt * 0.6 end
    if self.state == "walking" then self.cycle = self.cycle + dt * 12 end
    if self.state == "working" then
        local old = self.cycle
        self.cycle = self.cycle + dt * 3
        if old < 3 and self.cycle >= 3 then
            if self.task.target.__name == "tree" then audioHandler.playChop() end
        end
    end
    
    if self.cycle >= 4 then self.cycle = 0 end
    
end

function Villager:getImage()
    if self.state == "idle" then 
        return "idle"..math.floor(math.max(self.cycle - 3, 0) * 4) + 1 end
    if self.state == "working" then
        return "work"..math.floor(self.cycle) + 1
    end
    if self.state == "walking" then return self.animdirection..math.floor(self.cycle) + 1 end
    print("animation not found for state "..self.state)
    return nil
end

