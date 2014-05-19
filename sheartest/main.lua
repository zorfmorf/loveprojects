circle = { x=0, y=0}
k = math.random() * math.pi

function love.draw()
    love.graphics.shear(k, k)
    love.graphics.circle("fill", circle.x, circle.y, 2, 20)
end

function love.mousepressed(nx, ny, button)
    if button == "l" then
        circle.y = (ny - nx * k) / (1 - k * k)
        circle.x = (nx - ny * k) / (1 - k * k)
    end
end