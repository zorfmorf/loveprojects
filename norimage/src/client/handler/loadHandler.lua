
--[[

Ressource loader

]]--

function load_Music()
    music_credits = love.audio.newSource("res/sound/title.mp3")
end

function load_Images()
    img_logo = love.graphics.newImage("res/logo.png")
end


function load_Fonts()
    font_title = love.graphics.newFont("res/font/OldNewspaperTypes.ttf", 70)
    font_def = love.graphics.newFont("res/font/OldNewspaperTypes.ttf", 20) 
    font_head = love.graphics.newFont("res/font/OldNewspaperTypes.ttf", 30)    
end


function load_Colors()
    color_white = {255, 255, 255, 255}
    color_black = {0, 0, 0, 255}
    color_red = {229, 100, 100, 255}
end
