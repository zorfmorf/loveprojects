
STRUCTURE_ID = 1

Structure = class()
Structure.__name = "structure"

function Structure:__init(x, y, layer)
    self.x = x
    self.y = y
    self.xshift = math.random() * 0.5 - 0.25
    self.yshift = math.random() * 0.5 - 0.25
    self.cost = nil -- the cost for this building
    self.sent = {} -- the amount of ressources (might still be on their way) issued to this structure. 
    self.ressources = {} -- the available ressources at this building
    self.selected = false -- selected structures are painted in a reddish hint
    self.layer = layer -- the layer the structure is on. set when added to a layer
    self.selectable = false -- if the structure can be interacted with (hover or click)
    self.amount = 1 -- amount of build phases this building has
    self.time = 30 -- time it takes to build one of its phases
    self.dt = 0 -- time worked on this structure
    self.workersent = false -- whether a worker has been sent to this hut
    self.id = STRUCTURE_ID
    STRUCTURE_ID = STRUCTURE_ID + 1
end

function Structure:generateMesh(image)
    local vertices = {
        {0, tilesize, 0, 1, 255, 255, 255},
        {tilesize, tilesize, 1, 1, 255, 255, 255},
        {tilesize, tilesize, 1, 1, 255, 255, 255},
        {0, tilesize, 0, 1, 255, 255, 255},
    }
    return love.graphics.newMesh(vertices, image, "fan")
end

function Structure:update()
    
    local mesh = self.meshes[#self.meshes]
    
    local dt = 1 - (self.dt /self.time)
    local ts = tilesize * dt
    local vertices = {
        {0, ts, 0, dt, 255, 255, 255},
        {tilesize, ts, 1, dt, 255, 255, 255},
        {tilesize, tilesize, 1, 1, 255, 255, 255},
        {0, tilesize, 0, 1, 255, 255, 255},
    }
    mesh:setVertices(vertices)
end

function Structure:addRessource(res)
    if self.ressources[res] == nil then self.ressources[res] = 0 end
    self.ressources[res] = self.ressources[res] + 1
end

function Structure:removeRessource(res)
    self.ressources[res] = self.ressources[res] - 1
    if self.ressources[res] <= 0 then self.ressources[res] = nil end
end

function Structure:getImages()
    
    local images = {}
    table.insert(images, tileset[self.image.."_ground"])
    if self.amount == 0 then 
        table.insert(images, tileset[self.image])
    else
        for i=1,#self.meshes do
            table.insert(images, self.meshes[i])
        end
    end
    for res,amount in pairs(self.ressources) do
        table.insert(images, tileset["build_"..res..amount])
    end
    return images
end

--[[
    How do structures work?
Structures are everything that can be build.
After a building is placed, the required ressources need to be placed there

Build work can be started, once required ressources of the lowest order are available.

A worker will then go there, take one of that ressource, remove on of the cost and add
time to builddt

Build ressource order:
Planks, Reed, Stone, Iron

Possible build times per ressource
Wood = 5, Reed = 5, Stone = 10, Iron = 20

--]]


Hut = Structure:extends()
Hut.__name = "hut"

function Hut:__init(x, y, layer)
    Hut.super.__init(self, x, y, layer)
    self.cost = { planks = 4, log = 2 } -- the initial build costs. as long as there are costs available
    self.amount = 2
    self.time = 30
    self.image = "hut"
    self.meshes = { self:generateMesh(tileset["hut_frame"]) }
end

-- called whenever a build phase is started
-- needs to be customized for every building
function Hut:nextstate()
    if self.amount == 1 then
        self.meshes[2] = self:generateMesh(tileset["hut"])
        self:removeRessource("log")
    end
    if self.amount == 2 then 
        self:removeRessource("log") 
    end
end

Woodcutter = Structure:extends()
Woodcutter.__name = "woodcutter"

function Woodcutter:__init(x, y, layer)
    Woodcutter.super.__init(self, x, y, layer)
    self.cost = { planks = 2, log = 1 }-- TODO REMOVE
    self.amount = 2
    self.time = 20
    self.image = "woodcutter"
    self.meshes = { self:generateMesh(tileset["woodcutter_frame"]) }
end

function Woodcutter:nextstate()
    if self.amount == 2 then 
        self:removeRessource("log") 
    end
    if self.amount == 1 then
        self.meshes[2] = self:generateMesh(tileset["woodcutter"])
        self:removeRessource("log") 
    end
end
