--[[
    
    A task is something that needs to be done
    
    Tasks are handledl by the task handler

]]--

Task = class()

Task.__name = "task"

function Task:__init(target)
    self.target = target
end


-------- Some work to be done
WorkTask = Task:extends()
WorkTask.__name = "work"

function WorkTask:__init(target)
    WorkTask.super.__init(self, target)
end

------- Build something

CarryTask = Task:extends()
CarryTask.__name = "carry"

function CarryTask:__init(source, target, res)
    self.source = source
    self.target = target
    self.res = res
    self.state = 0 -- 0 -> get res, 1 -> carry to target
end