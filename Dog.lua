local anim8 = require 'library/anim8'

Dog = {}
Dog.__index = Dog

function Dog:new(x, y)
    local self = setmetatable({}, Dog)
    self.x = x or 100
    self.y = y or 100
    self.speed = 100
    self.width = 32  -- Assuming each frame is 32x32 pixels
    self.height = 32
    self.scale = 2  -- Scale the dog to make it larger
    self.directionX = math.random(2) == 1 and 1 or -1  -- Random horizontal direction
    self.directionY = math.random(2) == 1 and 1 or -1  -- Random vertical direction
    return self
end

function Dog:load()
    -- Load the dog image and create the grid and animation using anim8
    local dogImage = love.graphics.newImage("assets/Dog.png")  -- Use the correct image path
    local g = anim8.newGrid(6, 6, dogImage:getWidth(), dogImage:getHeight())  -- 32x32 grid
    self.animation = anim8.newAnimation(g('1-8', 1), 0.1)  -- Using frames from the first row
    self.image = dogImage
end

function Dog:update(dt)
    -- Update the animation
    self.animation:update(dt)

    -- Random movement logic
    self.x = self.x + self.speed * dt * self.directionX
    self.y = self.y + self.speed * dt * self.directionY

    -- Change direction randomly every few seconds
    if math.random() < 0.01 then
        self.directionX = math.random(2) == 1 and 1 or -1
        self.directionY = math.random(2) == 1 and 1 or -1
    end

    -- Keep the dog within the screen bounds
    if self.x < 0 then self.directionX = 1 end
    if self.x + self.width * self.scale > love.graphics.getWidth() then self.directionX = -1 end
    if self.y < 0 then self.directionY = 1 end
    if self.y + self.height * self.scale > love.graphics.getHeight() then self.directionY = -1 end
end

function Dog:draw()
    -- Draw the dog animation at the dog's current position
    self.animation:draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end
