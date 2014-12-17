--[[
    
    A station represents anything stationary in the system.
    Could be a space station or a planet. Sizes do not matter as everyhting
    is comparatively tiny

  ]]--

Station = Class{
    init = function(self, pos)
        self.pos = pos
        self.dt = 0 -- time alive
    end
}

function Station:update(dt)
    self.dt = self.dt + dt
    self.pos = Vector:c(love.mouse.getPosition())
end

function Station:draw()
    love.graphics.setColor(style.station.c)
    love.graphics.circle("line", math.floor(self.pos.x), math.floor(self.pos.y), style.station.r, 32)
end
