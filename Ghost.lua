Ghost = {}
Ghost.__index = Ghost

local animation

function Ghost:new(x, y, obstacles)
    local self = setmetatable({}, Ghost)
    self.x = x or 300 -- Different starting position from player
    self.y = y or 300
    self.speed = 150 -- Ghosts can be slower or faster than players
    self.width = 32
    self.height = 32
    self.obstacles = obstacles or {}
    return self
end

function Ghost:load()
    local ghostImage = love.graphics.newImage("assets/ghost.png")
    animation = newAnimation(ghostImage, self.width, self.height, 1)
end

function Ghost:update(dt)
    -- Simple AI for ghost movement
    local nextX, nextY = self.x, self.y

    -- Move randomly or towards the player in this simple AI
    if math.random() < 0.5 then
        nextX = self.x + (self.speed * dt * (math.random(2) == 1 and 1 or -1))
    end
    if math.random() < 0.5 then
        nextY = self.y + (self.speed * dt * (math.random(2) == 1 and 1 or -1))
    end

    -- Check for collisions with obstacles
    if not self:checkCollision(nextX, nextY) then
        self.x, self.y = nextX, nextY
    end
end

function Ghost:draw()
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.setColor(1, 1, 1)
    local scaleX = 0.5
    local scaleY = 0.5 
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], self.x, self.y, 0, scaleX, scaleY)
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

