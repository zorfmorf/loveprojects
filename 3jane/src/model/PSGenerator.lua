
PSGEN_STATE_CALM = 0
PSGEN_STATE_SUSPISCIOUS = 1
PSGEN_STATE_ACTIVE = 2

PSGEN_TYPE_WATCHER = 0
PSGEN_TYPE_DEFENDER = 1
PSGEN_TYPE_ATTACKER = 3

function psGenerator_generatePS(typus)
	local ps = love.graphics.newParticleSystem(imageSquare, 64)
	ps:setLifetime(-1)
	
	if typus == PSGEN_TYPE_ATTACKER then
		ps:setSizes(0.4, 2)
		ps:setDirection(0)
		ps:setSpread(math.pi * 2)
		ps:setColors( math.random(0, 255), math.random(0, 255), math.random(0, 255), 180, math.random(0, 255), math.random(0, 255), math.random(0, 255), 0)
		ps:setParticleLife(2)
		ps:setEmissionRate(20)
		ps:setSpeed(10, 40)
	end
	
	if typus == PSGEN_TYPE_DEFENDER then
		ps:setSizes(0.4, 2)
		ps:setDirection(0)
		ps:setSpread(math.pi * 2)
		ps:setColors( math.random(0, 255), math.random(0, 255), math.random(0, 255), 180, math.random(0, 255), math.random(0, 255), math.random(0, 255), 0)
		ps:setParticleLife(2)
		ps:setEmissionRate(32)
		ps:setTangentialAcceleration(128)
		ps:setRadialAcceleration(-5)
		ps:setSpeed(10)
	end
	
	if typus == PSGEN_TYPE_WATCHER then
		ps:setBufferSize( 44 )
		ps:setSizes(0.4, 2)
		ps:setDirection(0)
		ps:setSpread(math.pi * 2)
		ps:setColors( 20, 50, 200, 180, 20, 70, 150, 0)
		ps:setParticleLife(3)
		ps:setEmissionRate(128)
		ps:setSpeed(40, 40)
	end
	
	ps:stop()
	return ps
end
