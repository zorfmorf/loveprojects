-- the statemachine keeps track over the current gamestate

GAME_STATE = nil -- the state of the game itself (menu, playing, etc)

PLAYER_STATE = nil -- the state of the player (commanding, moving, etc)

-- called on startup
function statemachine_init()
	GAME_STATE = "loading"	
end

-- called when loading is finished
function statemachine_loading_finished()
	GAME_STATE = "generating"
end

-- 
function statemachine_generating_finished()
	GAME_STATE = "ingame"
	PLAYER_STATE = "commanding"
end

-- switch player state between walking around and steering ship
function statemachine_player_state_toggle()
	if PLAYER_STATE == "commanding" then
		PLAYER_STATE = "moving"
	else
		PLAYER_STATE = "commanding"
	end
end

function statemachine_pause()
    GAME_STATE = "paused"
end

function statemachine_unpause()
    GAME_STATE = "ingame"
end
