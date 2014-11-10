
Ressource = class()

Ressource.__name = "ressource"

function Ressource:__init(x, y, layer)
    self.x = x
    self.y = y
    self.layer = layer
    self.selected = false -- selected structures are painted in a reddish hint
    self.selectable = true -- if the ressource can be interacted with (hover or click)
    self.layer = layer -- the layer the ressource is on. set when added to a layer
    self.ressources = {} -- the available ressources at this building
    self.yield = "log" -- ressource type yielded
    self.amount = 1 -- amount of mining stages this ressource has
    self.time = 30 -- time it takes to mine on of this ressource
    self.dt = 0 -- time worked on this ressource
    self.id = STRUCTURE_ID
    STRUCTURE_ID = STRUCTURE_ID + 1
end

-- update meshes or other stuff
function Ressource:update()
    
end

function Ressource:getImages()
    local images = {tileset[self.image]}
    for res,amount in pairs(self.ressources) do
        table.insert(images, tileset["build_"..res..amount])
    end
    return images
end

function Ressource:addRessource(res)
    if self.ressources[res] == nil then self.ressources[res] = 0 end
    self.ressources[res] = self.ressources[res] + 1
end

function Ressource:removeRessource(res)
    self.ressources[res] = self.ressources[res] - 1
    if self.ressources[res] <= 0 then self.ressources[res] = nil end
end



-- Tree
Tree = Ressource:extends()
Tree.__name = "tree"

function Tree:__init(x, y, layer)
    Tree.super.__init(self, x, y, layer)
    self.image = "tree"..math.random(1, 2)
    self.yield = "log"
    self.amount = 2
    self.time = 15
end

-- called whenever a mining stage is started
function Tree:nextstate()
    
    if self.amount == 1 then
        self.image = "tree_down"
        audioHandler.playTreeDown()
    end
    
    if self.amount == 0 then
        self.image = "stump"
        self.selected = false
        self.selectable = false
        self:addRessource(self.yield)
        taskHandler.addRessource(self.yield, self)
    end
end


-- Waterfall
Waterfall = Ressource:extends()
Waterfall.__name = "waterfall"

function Waterfall:__init(x, y, layer, orientation)
    Waterfall.super.__init(self, x, y, layer)
    self.orientation = orientation
    self.selectable = false
    self.images = { tileset["waterfall_base"..orientation], tileset["waterfall_"..orientation.."1"], tileset["waterfall_"..orientation.."2"], tileset["waterfall_"..orientation.."3"] }
end

function Waterfall:getImages()
    return self.images
end