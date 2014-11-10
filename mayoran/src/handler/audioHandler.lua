
audioHandler = {}

local sounds = {}

function audioHandler.init()
    for i=1,9 do
        sounds["chop"..i] = love.audio.newSource("audio/chop"..i..".ogg", "static")
    end
    sounds["tree_down"] = love.audio.newSource("audio/tree_down.ogg", "static")
end

function audioHandler.playChop()
    local rnd = math.random(1,9)
    if sounds["chop"..rnd]:isPlaying() then sounds["chop"..rnd]:stop() end
    sounds["chop"..rnd]:play()
end

function audioHandler.playTreeDown()
    sounds["tree_down"]:play()
end