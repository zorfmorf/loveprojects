-- The background for a traderun such as nebula, stars, planets, wrecks

class "LoadScreen" {

	-- initate 
	__init__ = function(self)
		self.barHeight = love.graphics:getHeight() * 0.1
		self.barWidth = love.graphics:getWidth() * 0.8
		self.barX = love.graphics:getWidth() * 0.1
		self.barY = love.graphics:getHeight() /  2 - self.barHeight / 2
		self.percentage = 0
	end,
	
	-- draw the loadscreen
	draw = function(self)
		love.graphics.setColor(150, 200, 220, 255)
		love.graphics.rectangle( "line", self.barX, self.barY, self.barWidth, self.barHeight )
		love.graphics.setColor(150, 200, 220, 255 * self.percentage)
		love.graphics.rectangle( "fill", self.barX, self.barY, self.barWidth * self.percentage, self.barHeight )
	end
	
}
