
Entity = Class{
    init = function(self, pos, vel)
        self.pos = pos -- position vector
        self.vel = vel -- velocity vector
        self.dt = 0 -- time alive
        self.maxspeed = 50
        self.flee = false
    end
}

function Entity:update(dt)
    self.dt = self.dt + dt
    
    -- update position
    self.pos = self.pos:add(self.vel:mult(dt))
    
    -- calculate new velocity vector
    if self.target then
        if self.flee then
            self.vel = steering.flee(self, self.target)
        else
            self.vel = steering.wander(self)
        end
    else
        self.vel = Vector:c(0, 0)
    end
end

function Entity:draw()
    local x = math.floor(self.pos.x - style.contact.w / 2)
    local y = math.floor(self.pos.y - style.contact.w / 2)
    local c = style.contact.c
    local opacity = math.floor(30 + (c[4] - 30) * (math.sin(self.dt * 3) + 1) * 0.5)
    love.graphics.setColor(c[1], c[2], c[3], opacity)
    love.graphics.rectangle("line", x, y, style.contact.w, style.contact.w)
    
    x = math.floor(x + style.contact.w / 2)
    y = math.floor(y + style.contact.w / 2)
    love.graphics.print("Unidentified contact", x + style.contact.w, y, 0, 1, 1, -5, math.floor(style.contact.w / 2))
end


function Entity:switchTactic()
    self.flee = not self.flee
end
