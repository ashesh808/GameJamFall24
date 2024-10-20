-- bullet.lua
Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y)
    local self = setmetatable({}, Bullet)
    self.image = love.graphics.newImage("/assets/bullet.png")
    self.x = x
    self.y = y
    self.speed = -700 -- Negative for upward movement (change sign if you want to shoot downward)
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