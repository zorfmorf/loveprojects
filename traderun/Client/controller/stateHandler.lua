-- the statehandler keeps track over the current gamestate

GAME_STATE = nil -- the state of the game itself (menu, playing, etc)

PLAYER_STATE = nil -- the state of the player (moving, firing, steering)

-- called on startup
function statehandler_init()
	GAME_STATE = "loading"	
end

-- called when loading is finished
function statehandler_loading_finished()
	GAME_STATE = "generating"
end

-- called when backgrounds are generated
function statehandler_generating_finished()
	GAME_STATE = "ingame"
	PLAYER_STATE = "moving"
end

-- called when game paused
function statehandler_pause()
    GAME_STATE = "paused"
end

-- called when unpaused
function statehandler_unpause()
    GAME_STATE = "ingame"
end

-- called when current traderun is finished
function statehandler_run_finished()
	GAME_STATE = "end"
end
