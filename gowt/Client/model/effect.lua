
class "Effect" {
	
	x, -- x position
	y, -- y position
	dt, -- alive time left in seconds

	__init__ = function(self, x, y)
		self.x = x
		self.y = y
		self.dt = 3
	end


}

class "Explosion" (Effect) {

	__init__ = function(self, x, y)
		self.x = x
		self.y = y
		self.visual = {81, 0}
		self.dt = 1
	end
}