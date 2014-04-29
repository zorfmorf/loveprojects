-- A challenge is something encountered during a traderun
-- Challenges can be asteroids, pirates or events such as a spacehulk

class "Challenge" {
    
    name = "Generic"; -- name of the challenge. used to warn the player
    delay = 0; -- delay time for challenge event after challenge start
    duration = 0; -- how long the actual challenge lasts.
    difficulty = 1; -- the difficulty of the challenge
    elapsed = 0; -- the time the challenge is active
    state = CHALLENGE_STATE_INACTIVE; -- needs to be set to true when challenge is finished
    
    -- init a new challenge with a given difficulty
    __init__ = function(self, difficulty)
        self.difficulty = difficulty
    end,
    
    -- update the challenge. only used when challenge is active
    update = function(self, dt)
        
        if self.state == CHALLENGE_STATE_INACTIVE then
            self.state = CHALLENGE_STATE_ACTIVE
        end
        
        self.elapsed = self.elapsed + dt
        
        if self.elapsed > self.delay and self:isFinished() ~= true then
        
            self:trigger()
        
        end
        
        
        if self.elapsed > self.duration + self.delay then
        
            self.state = CHALLENGE_STATE_FINISHED
            
        end
    end,
    
    -- triggers the challenge event
    trigger = function(self)
  
    end,
    
    -- returns overall time needed
    getDuration = function(self)
        return self.delay + self.duration
    end,
    
    -- returns true when everything relevant to this challenge
    -- was triggered
    -- only used internally
    isFinished = function(self)
        return self.state == CHALLENGE_STATE_FINISHED
    end
    
}

--list of all challenge types
challenge = {}

-- asteroids come in swarms and "attack" the ship from
-- one or more directions.
-- spawns a set of asteroids and hurls them in the
-- general direction of the ship. Is finished when
-- all waves of asteroids are launched
class "challenge.Asteroids" (Challenge) {
    
    name = "Asteroids";
    waves = nil;        -- list of inidividual waves
    current = 1; -- index of next wave to be triggered

    -- init a new asteroid challenge
    __init__ = function(self, difficulty)
        
        self.difficulty = difficulty
        
        self.delay = CHALLENGE_ASTEROID_DELAY
        self.duration = CHALLENGE_ASTEROID_DURATION
        
        -- define asteroid waves
        self.waves = {}
        for i=1,difficulty do 
            -- now add a number of asteroids to the wave
            self.waves[i] = 3 + difficulty * 5
        end
    end,
    
    -- launch a wave of asteroids
    trigger = function(self, dt)
    
        
        local side = math.random(0, 3) -- the side the asteroids are coming from
        if side == 0 then side = 2 end -- front is more likely this way
        
        for i=1,self.waves[self.current] do
            
            -- define an asteroid that arrives from  the front
            local asteroid = objects.Asteroid(math.random(-1500, 1500), 
                                              -2000, 
                                              0, 
                                              math.random(-2, 2), 
                                              math.random(-3, 3), 
                                              math.random(300, 900),
                                              math.random(1, self.difficulty))

            -- now add the asteroid to the entities list
            entities[asteroid.id] = asteroid

        end
        
        self.current = self.current + 1
        
    end,
    
    -- if all waves are launched, this challenge is finished
    isFinished = function(self)
        return self.waves[self.current] == nil
    end
}


-- a "Nothing" is used as a buffer between challenges where nothing happens
class "Nothing" {
    
    elapsed = 0;
    duration = 0;
    
    __init__ = function(self, value)
        self.duration = value
        self.elapsed = 0
    end,
    
    update = function(self, dt)
        self.elapsed = self.elapsed + dt
    end,
    
    getDuration = function(self)
        return self.duration
    end
    
}
