
class "Program" {
	
	ps = nil;
	id = nil;
	typus = 0;
	state= 0;
	
	__init__ = function(self, typus)
		self.ps = psGenerator_generatePS(typus)			
	end,
	
	
	update = function(self, dt)
		self.ps:update(dt)
	end

}
