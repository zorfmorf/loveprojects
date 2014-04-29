-- handles all music and soundeffects

local loop = nil -- the default background loop

function soundHandler_init()
    loop = love.audio.newSource( "res/sound/ambient.ogg")
    loop:setLooping(true)
    loop:play()
end
