
ball = class()

function ball:init(x, y, width, height, theta, velocity)
    self.x = x
    self.y = y 
    self.c_x = x 
    self.c_y = y 
    self.width = width 
    self.height = height 
    self.theta = theta
    self.velocity = velocity

    self.dx  = self.velocity * math.cos(self.theta)
    self.dy  = self.velocity * math.sin(self.theta)
    self.d2_x = 0
    self.d2_y = GRAVITY

    self:updateCurvature()
end

function ball:reset()
    self.x = self.c_x
    self.y = self.c_y 
    self.dx  = self.velocity * math.cos(self.theta)
    self.dy  = self.velocity * math.sin(self.theta)
    self.d2_x = 0
    self.d2_y = GRAVITY

    self:updateCurvature()
end

function ball:update(dt)
    self.x = self.x + self.dx * dt 
    self.y = self.y + self.dy * dt
  
    self.dx = self.dx + self.d2_x * dt
    self.dy = self.dy + self.d2_y * dt

    self:updateCurvature()
end

function ball:updateCurvature()
    local velocity_mag = math.sqrt(self.dx * self.dx + self.dy * self.dy)

    if velocity_mag > 0 then
        self.cos_alph = self.dx / velocity_mag
        self.dr = (self.dx * self.dx + self.dy * self.dy) / (self.d2_y * self.cos_alph)

        self.ce_x = self.x + self.dr * (-self.dy / velocity_mag)
        self.ce_y = self.y + self.dr * (self.dx / velocity_mag)
    else
        self.cos_alph = 0
        self.dr = 0
        self.ce_x = self.x
        self.ce_y = self.y
    end
end

function ball:render()
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.circle('line', self.ce_x, self.ce_y, math.abs(self.dr), 150)
end
