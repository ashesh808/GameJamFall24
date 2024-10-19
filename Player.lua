Player = {}
Player.__index = Player

local animation

function Player:new(x, y, obstacles)
    local self = setmetatable({}, Player)
    self.x = x or 100
    self.y = y or 100
    self.speed = 200
    self.width = 16
    self.height = 18
    self.obstacles = obstacles or {} -- Pass obstacles here
    return self
end

function Player:load()
    local playerImage = love.graphics.newImage("assets/oldHero.png")
    animation = newAnimation(playerImage, self.width, self.height, 1) -- Width, height, and duration for animation
end

function Player:update(dt)
    -- Update the animation timer
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end

    -- Player movement logic
    local nextX, nextY = self.x, self.y
    if love.keyboard.isDown("w") then
        nextY = self.y - self.speed * dt
    end
    if love.keyboard.isDown("s") then
        nextY = self.y + self.speed * dt
    end
    if love.keyboard.isDown("a") then
        nextX = self.x - self.speed * dt
    end
    if love.keyboard.isDown("d") then
        nextX = self.x + self.speed * dt
    end

    -- Check for collisions with obstacles
    if not self:checkCollision(nextX, nextY) then
        self.x, self.y = nextX, nextY
    end
end

function Player:draw()
    -- Draw the player animation
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.setColor(1, 1, 1) -- Reset color to white for sprite
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], self.x, self.y, 0, 4, 4) -- Scale to make the sprite larger
end

function Player:checkCollision(x, y)
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

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image
    animation.quads = {}
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end
