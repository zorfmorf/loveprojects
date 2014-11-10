LAYER_HEIGHT = 4

Layer = class()
Layer.__name = "Layer"

function Layer:__init(level)
    
    self.structures = {}
    self.villagers = {}
    self.level = level
    
end


function Layer:generateRim()
    
    self.rim = {}
    
    for i=1,LAYER_HEIGHT do
        
        self.rim[i] = {}
        
        local mod = 0
        
        if i > 2 then mod = 1 end
        
        for j=1,(self.level * 4 - 2 * mod) do
            
            self.rim[i][j] = Tile:new("cliff")
            
        end
                
    end
    
    -- fix edges
    for i,row in pairs(self.rim) do
        
        for j,entry in pairs(self.rim[i]) do
            
            if self.rim[i][j-1] == nil then
                
                if i % 2 == 0 then
                    
                    self.rim[i][j].image = "cliff_edge_l2"
                    
                else
                    
                    self.rim[i][j].image = "cliff_edge_l1"
                    
                end
                
            end
            
            if self.rim[i][j+1] == nil then
                
                if i % 2 == 0 then
                    
                    self.rim[i][j].image = "cliff_edge_r2"
                    
                else
                    
                    self.rim[i][j].image = "cliff_edge_r1"
                    
                end
                
            end
        
        end
        
    end
    
end

function Layer:generateTerrain(sort)
    
    self.terrain = {}
    
    local height = self.level * 2
    
    for i=1,height+1 do
        
        self.terrain[i] = {}
        
        local mod = math.floor(height / 2) - i
        if mod < 0 then mod = math.min(0, mod + 2) end
        mod = math.abs(mod)
      
        for j=1 + mod,self.level * 4 - mod + 2 do

                self.terrain[i][j] = Tile:new(sort)
        
        end
               
    end
    
    local waterfallindex = math.floor(#self.terrain[height+1] / 2 + 1)
    --self:addStructure(Waterfall:new(waterfallindex, height, self.level, "l"))
    --self:addStructure(Waterfall:new(waterfallindex + 1, height, self.level, "r"))
    
    if sort == "grass" then
        
        for i,row in pairs(self.terrain) do
            
            for j,tile in pairs(row) do
               
                if i <= 1 or self.terrain[i - 1][j] == nil then 
                    if self.terrain[i][j - 1] == nil and self.terrain[i][j + 1] ~= nil then
                        tile.image = "grass_edge_lu"
                        tile.buildable = false
                    elseif self.terrain[i][j - 1] ~= nil and self.terrain[i][j + 1] == nil then
                        tile.image = "grass_edge_ru"
                        tile.buildable = false
                    else 
                        tile.image = "grass_edge_u"
                        tile.buildable = false
                    end
                end
                
                if i > 1 and self.terrain[i - 1][j] ~= nil and self.terrain[i - 1][j - 1] == nil and
                    self.terrain[i][j - 1] ~= nil then
                    tile.image = "grass_inner_rd"
                    tile.buildable = false
                end
                
                if i > 1 and self.terrain[i - 1][j] ~= nil and self.terrain[i - 1][j + 1] == nil and
                    self.terrain[i][j + 1] ~= nil then
                    tile.image = "grass_inner_ld"
                    tile.buildable = false
                end
                
                if self.terrain[i][j - 1] == nil and self.terrain[i-1] ~= nil and self.terrain[i+1] ~= nil and
                    self.terrain[i-1][j] ~= nil and self.terrain[i+1][j] ~= nil then
                    tile.image = "grass_edge_l"
                    tile.buildable = false
                end
                
                if self.terrain[i][j + 1] == nil and self.terrain[i-1] ~= nil and self.terrain[i+1] ~= nil and
                    self.terrain[i-1][j] ~= nil and self.terrain[i+1][j] ~= nil then
                    tile.image = "grass_edge_r"
                    tile.buildable = false
                end
                
                if i >= height+1 or self.terrain[i + 1][j] == nil then 
                    if self.terrain[i][j - 1] == nil and self.terrain[i][j + 1] ~= nil then
                        tile.image = "grass_edge_ld"
                        tile.buildable = false
                    elseif self.terrain[i][j - 1] ~= nil and self.terrain[i][j + 1] == nil then
                        tile.image = "grass_edge_rd"
                        tile.buildable = false
                    else 
                        tile.image = "grass_edge_d"
                        tile.buildable = false
                    end
                end
                
                if i < height+1 and self.terrain[i + 1][j] ~= nil and self.terrain[i + 1][j - 1] == nil and
                    self.terrain[i][j - 1] ~= nil then
                    tile.image = "grass_inner_ru"
                    tile.buildable = false
                end
                
                if i < height+1 and self.terrain[i + 1][j] ~= nil and self.terrain[i + 1][j + 1] == nil and
                    self.terrain[i][j + 1] ~= nil then
                    tile.image = "grass_inner_lu"
                    tile.buildable = false
                end
                
                if i > 2 and self.terrain[i - 1][j] ~= nil and self.terrain[i - 1][j].structure ~= nil and
                    self.terrain[i - 1][j].structure:is(Waterfall) then
                    local ori = "r"
                    if self.terrain[i - 1][j].structure.orientation == ori then ori = "l" end
                    tile.image = "grass_edge_"..ori.."d"
                end
                
                if tile.buildable and math.random(1,2) == 1 then
                    self:addStructure(Tree:new(j, i, self.level))
                end
                
            end
            
        end
        
    end
    
end

function Layer:addStructure(struct)
   
    if self.terrain[struct.y][struct.x].structure == nil then
        self.terrain[struct.y][struct.x].structure = struct
        self.structures[struct.id] = struct
    else
        print("Error: Structure can't be build here: "..struct.__name.." "..struct.x.." "..struct.y)
    end
    
end