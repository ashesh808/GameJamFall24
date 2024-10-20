Ghost = {}
Ghost.__index = Ghost

local anim8 = require 'libraries/anim8' 

function Ghost:new(x, y, obstacles)
    local self = setmetatable({}, Ghost)
    self.x = x or 200
    self.y = y or 200
    self.speed = 100
    self.width = 32
    self.height = 32
    self.obstacles = obstacles or {}
    return self
end

function Ghost:load()
    local ghostImage = love.graphics.newImage("assets/ghost.png")
    self.spriteSheet = ghostImage
    local grid = anim8.newGrid(self.width, self.height, ghostImage:getWidth(), ghostImage:getHeight())
    self.anim = anim8.newAnimation(grid('1-4', 1), 0.2)  -- 4 frames, 0.2 seconds per frame
end

function Ghost:update(dt)
    local nextX, nextY = self.x, self.y
    if math.random() < 0.5 then
        nextX = self.x + (self.speed * dt * (math.random(2) == 1 and 1 or -1))
    end
    if math.random() < 0.5 then
        nextY = self.y + (self.speed * dt * (math.random(2) == 1 and 1 or -1))
    end
    if not self:checkCollision(nextX, nextY) then
        self.x, self.y = nextX, nextY
    end
    self.anim:update(dt)
end

function Ghost:draw()
    love.graphics.setColor(1, 1, 1)
    self.anim:draw(self.spriteSheet, self.x, self.y, 0, 0.8, 0.8)  -- Scale by 1.5
end

function Ghost:checkCollision(x, y)
    for _, obstacle in ipairs(self.obstacles) do
        if x < obstacle.x + obstacle.width and
           x + self.width > obstacle.x and
           y < obstacle.y + obstacle.height and
           y + self.height > obstacle.y then
            return true
        end
    end
    return false
end
