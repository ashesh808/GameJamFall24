Player = {}
Player.__index = Player

local animation

function Player:new(x, y, obstacles)
    local self = setmetatable({}, Player)
    self.x = x or 100
    self.y = y or 100
    self.speed = 200
    self.width = 12
    self.height = 18
    self.health = 100
    self.maxHealth = 100
    self.obstacles = obstacles or {}

    
    return self
end

function Player:load()
    -- Load the player sprite sheet
    local playerImage = love.graphics.newImage("assets/player-sheet.png")
    self.spriteSheet = playerImage

    -- Define the grid based on the dimensions of each frame
    local grid = anim8.newGrid(self.width, self.height, playerImage:getWidth(), playerImage:getHeight())

    -- Create animations (adjust the frame range and rows to match your sprite sheet)
    self.animations = {
        down = anim8.newAnimation(grid('1-4', 1), 0.2),  -- 3 frames on row 1 for moving down
        left = anim8.newAnimation(grid('1-4', 2), 0.2),  -- 3 frames on row 2 for moving left
        right = anim8.newAnimation(grid('1-4', 3), 0.2), -- 3 frames on row 3 for moving right
        up = anim8.newAnimation(grid('1-4', 4), 0.2)     -- 3 frames on row 4 for moving up
    }

    -- Set the initial animation
    self.anim = self.animations.down
end

function Player:update(dt, ghosts)
    -- animation.currentTime = animation.currentTime + dt
    -- if animation.currentTime >= animation.duration then
    --     animation.currentTime = animation.currentTime - animation.duration
    -- end

    local nextX, nextY = self.x, self.y
    local moving = false

    -- Movement and animation assignment
    if love.keyboard.isDown("w") then
        nextY = self.y - self.speed * dt
        self.anim = self.animations.up
        moving = true
    elseif love.keyboard.isDown("s") then
        nextY = self.y + self.speed * dt
        self.anim = self.animations.down
        moving = true
    elseif love.keyboard.isDown("a") then
        nextX = self.x - self.speed * dt
        self.anim = self.animations.left
        moving = true
    elseif love.keyboard.isDown("d") then
        nextX = self.x + self.speed * dt
        self.anim = self.animations.right
        moving = true
    end

    -- Only update animation if the player is moving
    if moving then
        self.anim:resume()
        self.anim:update(dt)
    else 
        -- Pause animation when not moving
       -- self.anim:pause()
       self.anim:gotoFrame(2);
    end

    if not self:checkCollision(nextX, nextY) then
        self.x, self.y = nextX, nextY
    end

    -- Check collisions with ghosts
    for _, ghost in ipairs(ghosts) do
        if self:checkCollisionWithGhost(ghost) then
            self:takeDamage(10) -- Assume 10 damage per collision
            break -- Exit the loop after taking damage
        end
    end
end


function Player:checkCollisionWithGhost(ghost)
    return self.x < ghost.x + ghost.width and
           self.x + self.width > ghost.x and
           self.y < ghost.y + ghost.height and
           self.y + self.height > ghost.y
end

function Player:takeDamage(amount)
    self.health = self.health - amount
    if self.health < 0 then
        self.health = 0
    
    end
end


function Player:draw()
    love.graphics.setColor(1, 1, 1) 
    self.anim:draw(self.spriteSheet, self.x, self.y, 0, 1.8, 1.8)

    -- Draw health bar
    self:drawHealthBar()
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

function Player:drawHealthBar()
    -- Position of the health bar relative to the player
    local barX = self.x - 5
    local barY = self.y - 10  -- Slightly above the player sprite
    local barWidth = 40
    local barHeight = 5

    -- Background of the health bar (black)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", barX - 1, barY - 1, barWidth + 2, barHeight + 2)

    -- Health bar (green)
    love.graphics.setColor(0, 1, 0)
    local healthRatio = self.health / self.maxHealth
    love.graphics.rectangle("fill", barX, barY, barWidth * healthRatio, barHeight)

    -- Reset color to white
    love.graphics.setColor(1, 1, 1)
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

