-- bullet.lua
Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y)
    local self = setmetatable({}, Bullet)
    self.image = love.graphics.newImage("assets/bullet.png")  -- Correct image path
    self.x = x
    self.y = y
    self.speed = -700 -- Negative for upward movement (adjust for direction)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    return self
end

function Bullet:update(dt)
    self.y = self.y + self.speed * dt
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Bullet
