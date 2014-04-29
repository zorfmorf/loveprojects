-- all draw methods go here. simply for convenience

function draw_System()
	love.graphics.setColor(230 * system.state, 50, 145 - system.state * 140, 50 * math.abs(math.sin(timer / (2 - system.state * 1.5))))
	love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth(), love.graphics.getHeight())
end
