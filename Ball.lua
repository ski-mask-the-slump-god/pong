Ball = Class{}

function Ball:init(x, y, radius, sections)
	self.x = x
	self.y = y
	self.radius = radius
	self.sections = sections

	self.dy = math.random(2) == 1 and -100 or 100
	self.dx = math.random(-50, 50)
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	self.dy = math.random(2) == 1 and -100 or 100
	self.dx = math.random(-50, 50)
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt 
end

function Ball:collides(paddle)
	if self.x + 2*self.radius > paddle.x + paddle.width or paddle.x > self.x + 2*self.radius then
		return false
	end
	if self.y > paddle.y + paddle.width or paddle.y > self.y + 2*self.radius then
		return false
	end
	return true
end
function Ball: render()
	love.graphics.circle('fill', self.x, self.y, self.radius, self.sections)
end
