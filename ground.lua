ground = class()

function ground:init(x, y, width, height)
    self.x = x 
    self.y = y 
    self.width = width 
    self.height = height
end

function ground:render()
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function ground:collide(ball)
    if self.x > ball.x + ball.width or ball.x > self.x + self.width then
        return false
    end

    if self.y > ball.y + ball.height or ball.y > self.y + self.height then
        return false
    end

    return true
end