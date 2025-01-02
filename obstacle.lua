obstacle = class()

function obstacle:init(radius, centre_x, centre_y)
    self.radius = radius
    self.centre_x = centre_x
    self.centre_y = centre_y
end

function obstacle:render()
    love.graphics.setColor(255,255,255,160)
    love.graphics.circle('fill', self.centre_x, self.centre_y, self.radius, 150)
end


function obstacle:collide(ball)
    local dx = ball.x - self.centre_x
	local dy = ball.y - self.centre_y
	local distance = math.sqrt(dx * dx + dy * dy)


	if distance <= self.radius + 4 then
		return true 
	end

	return false 
end