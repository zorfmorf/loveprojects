-- The Traderun class serves as a container for the specific attribute
-- of this traderun and tracks the progress in this run

class "Traderun" {

	name = "generic"; -- the name of the traderun
	level = 0; -- the level of the traderun
    distance = 0; -- the overall distance needed to travel until reaching end
    travelled = 0; -- the currently travelled distance
    current = 1; -- the index of the current sequence element
    seed = 0; -- seed for random generator. a specifc seed always creates the same traderun
    encountered = nil; -- list of objects successfully encountered this run
    
    sequence = nil; -- sequence of all events
   	
	-- initate a new traderun
	__init__ = function(self, name, level)
		self.name = name
		self.level = level
        self.current = 1
        self.encountered = {}
		self.seed = math.random(0, 1000000)
        
        -- first generate the sequences
        self.sequence = {}
        self.sequence[1] = Nothing(5)
        for i = 1,level+1 do
            self.sequence[i * 2] = challenge.Asteroids(level)
            self.sequence[i * 2 + 1] = Nothing(10)
        end 
        
        -- now calculate the overall distance
        for i,element in pairs(self.sequence) do
            
            self.distance = self.distance + element:getDuration()
            
        end
	end,
    
    -- update the travelled distance and sequences
    update = function(self, dt)
    
        self.travelled = self.travelled + dt
        
        if self.sequence[self.current] ~= nil then
            
            self.sequence[self.current]:update(dt)
        
            if self.sequence[self.current].elapsed > 
                    self.sequence[self.current]:getDuration() then
                self.current = self.current + 1
            end
        
        end
        
    end,
    
    -- get current challenge if any
    getCurrentChallenge = function(self, dt)
		
		if self.sequence[self.current] ~= nil and self.sequence[self.current].name ~= nil then
			return self.sequence[self.current]
		end
		return nil

    end 
	
}
