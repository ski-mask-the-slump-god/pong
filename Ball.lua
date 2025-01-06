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
	    local closestX = math.max(paddle.x, math.min(self.x + self.radius, paddle.x + paddle.width))
	    local closestY = math.max(paddle.y, math.min(self.y + self.radius, paddle.y + paddle.height))
	    
	    -- Calculate the distance between the ball's center and this closest point
	    local distanceX = (self.x + self.radius) - closestX
	    local distanceY = (self.y + self.radius) - closestY
	    
	    -- Check if the distance is less than or equal to the ball's radius
	    return (distanceX ^ 2 + distanceY ^ 2) <= (self.radius ^ 2)
end
function Ball: render()
	love.graphics.circle('fill', self.x, self.y, self.radius, self.sections)
end
