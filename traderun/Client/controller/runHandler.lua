-- The runhandler is tasked with handling all aspects of a traderun

class "RunHandler" {

	traderun = nil;
	background = nil;

	
	-- initate
	__init__ = function(self)
		self.traderun = Traderun("Testrun", 1)
		self.background = Background(self.traderun.seed)
	end,
	
	-- update function
	update = function(self, dt)
		if main_ship.enginesActive then
            self.background:update(dt)
			if self.traderun.travelled >= self.traderun.distance then
				statehandler_run_finished()
				endScreen_evaluate("finished")
			end
            self.traderun:update(dt)
		end
	end

}
