
function parseTilesetByXML(path, name)
    
    local result = {}
    
    local file = love.filesystem.newFile(path .. name)
    if file then
        local iterator = file:lines()
        
        local line = iterator()
        while line do
            
            if line:find("TextureAtlas") and not result.tiles then
                local imgname = string.match(line, "%a+.png")
                if imgname then
                    result.tiles = love.graphics.newImage(path .. imgname)
                    result.quads = {}
                end
            end
            
            if line:find("SubTexture") then
                local cand = {}
                for word in string.gmatch(line, "%a+=\"%a*_-%a*%d*.-%a*\"") do
                    local center = word:find("=")
                    local key = word:sub(1, center - 1)
                    local value = word:sub(center + 2, word:len() - 1)
                    cand[key] = value
                end
                result.quads[cand.name:sub(1, -5)] = love.graphics.newQuad(cand.x, cand.y, cand.width, cand.height, result.tiles:getDimensions())
            end
            
            line = iterator()
        end
    end
    
    return result
end
