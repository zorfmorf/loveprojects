-- awareness

WAVE_HEIGHT_MIN = 0
WAVE_HEIGHT_MAX = 2

WAVE_SHIFT_FACTOR_MIN = 10
WAVE_SHIFT_FACTOR_MAX = 0.1

AWARENESS_STATE_CALM = 1
AWARENESS_STATE_WAVE = 2
AWARENESS_STATE_CHASMS = 3
AWARENESS_STATE_LABYRINTH = 4


function awareness_init()
	
	shift_current = 2 -- 0.1 to 10, the higher the more smooth transitions are
	wave_current = 0 -- 0 to 2, but 1 is the heighest wave height were no holes are guaranteed
	awareness_state = AWARENESS_STATE_WAVE
	
end


function awareness_updateBox(tile, i, j)

	if awareness_state == AWARENESS_STATE_WAVE then

		tile.level = (math.sin(timer + tile.shift + (i + j / 3) / 2)) * 0.75 * wave_current + 0.75
		
	end
	
	if awareness_state == AWARENESS_STATE_CHASMS then

		tile.level = (math.sin(timer + tile.shift + (i + j / 3) / 2)) * 0.75 * wave_current + 0.75
		
	end
	
end

-- update to change behaviour
function awareness_update(dt)

	wave_current = math.min(timer / 10, 2)

end


function awareness_newState(state)
	
	if state == AWARENESS_STATE_CALM then
	
	end
	
	awareness_state = state
	
end
