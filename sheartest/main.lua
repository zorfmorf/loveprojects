x = 700
y = 700
width = 50
height = 50

circle = { x=0, y=0}
angle = -0.3

function love.draw()

    --love.graphics.rectangle('line', x, y, width, height)
    
    love.graphics.shear(angle, angle)
    love.graphics.rectangle('line', x, y, width, height)
    --[[
    love.graphics.origin()
    love.graphics.shear(0, angle)
    love.graphics.shear(angle, 0)
    love.graphics.setColor(255, 200, 200)
    love.graphics.rectangle('line', x, y, width, height)
    love.graphics.setColor(255, 255, 255) ]]--
    
    love.graphics.circle("fill", circle.x, circle.y, 5, 20)
end

function love.mousepressed(x, y, button)
    if button == "l" then
        circle.y = y - math.sin(angle) * x
        circle.x = x - math.sin(angle) * y
    end
end