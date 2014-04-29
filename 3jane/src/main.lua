
require 'misc/slither'

require 'model/PSGenerator'
require 'model/program'
require 'model/system'

require 'view/drawMethods'

require 'controller/ressourceLoader'
require 'controller/stateHandler'

function love.load()

	math.randomseed(1)
	
	ressourceLoader_load()
	
	system = System()
	
	player = psGenerator_generatePS(PSGEN_TYPE_ATTACKER )
	player:start()
	
	timer = 0
	
	state_init()
		
	love.mouse.setVisible(false)
end



function love.draw()

	if state == STATE_INGAME then
	
		draw_System(system)
		
		love.graphics.setBlendMode("additive")
		
		for i,p in pairs(system.programs) do
			love.graphics.draw(p.ps)
		end
		
		love.graphics.draw(player)
	
	end
    
end



function love.mousepressed( x, y, button )
	
	if button == "l" then
		
		
				
	end
	
end



function love.mousereleased( x, y, button )
	
	if button == "l" then
		
		
				
	end
	
end



function love.update(dt)
	
	if state == STATE_INGAME then
	
		timer = timer + dt
		
		for i,p in pairs(system.programs) do 
			p:update(dt)
		end
		
		player:setPosition(love.mouse.getX(), love.mouse.getY())
		player:update(dt)
	
	end
	
end
