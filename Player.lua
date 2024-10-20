Player = {}
Player.__index = Player

local anim8 = require 'libraries/anim8' 
local Bullet = require 'Bullet'  -- Assuming you have a separate Bullet class

function Player:new(x, y, obstacles)
    local self = setmetatable({}, Player)
    self.x = x or 100
    self.y = y or 100
    self.speed = 200
    self.width = 12
    self.height = 18
    self.health = 10000
    self.maxHealth = 10000
    self.obstacles = obstacles or {}
    self.bullets = {}  -- Initialize bullets table

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
        down = anim8.newAnimation(grid('1-4', 1), 0.2),  -- 4 frames on row 1 for moving down
        left = anim8.newAnimation(grid('1-4', 2), 0.2),  -- 4 frames on row 2 for moving left
        right = anim8.newAnimation(grid('1-4', 3), 0.2), -- 4 frames on row 3 for moving right
        up = anim8.newAnimation(grid('1-4', 4), 0.2)     -- 4 frames on row 4 for moving up
    }

    -- Set the initial animation
    self.anim = self.animations.down

    -- Load the ghost collision sound effect
    self.ghostCollisionSound = love.audio.newSource("assets/sounds/ghostkillSound.wav", "static")
end

function Player:update(dt, ghosts)
    local nextX, nextY = self.x, self.y
    local moving = false

    -- Player movement and animation
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

    -- Update animation if moving
    if moving then
        self.anim:resume()
        self.anim:update(dt)
    else
        self.anim:gotoFrame(2)  -- Pause animation when not moving
    end

    -- Ensure player stays within the screen bounds
    if nextY < 0 then nextY = 0
    elseif nextY + self.height > love.graphics.getHeight() then nextY = love.graphics.getHeight() - self.height end
    if not self:checkCollision(nextX, nextY) then
        self.x, self.y = nextX, nextY
    end

    -- Check for collisions with ghosts
    for _, ghost in ipairs(ghosts) do
        if self:checkCollisionWithGhost(ghost) then
            self:takeDamage(10)  -- Assume 10 damage per collision
            break  -- Exit the loop after taking damage
        end
    end

    -- Update bullets
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        bullet:update(dt)

        -- Remove bullet if it's off-screen
        if bullet.y < 0 then
            table.remove(self.bullets, i)
        end
    end
end

function Player:draw()
    -- Draw the player sprite with animation
    love.graphics.setColor(1, 1, 1)
    self.anim:draw(self.spriteSheet, self.x, self.y, 0, 1.8, 1.8)

    -- Draw health bar
    self:drawHealthBar()

    -- Draw bullets
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

function Player:keyPressed(key)
    if key == "space" then
        -- Fire a bullet when the space key is pressed
        local bullet = Bullet:new(self.x + self.width / 2 - 2, self.y)  -- Adjust bullet position if needed
        table.insert(self.bullets, bullet)
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
    -- Play the ghost collision sound effect
    self.ghostCollisionSound:play()
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
    -- Position the health bar slightly above the player
    local barX = self.x - 5
    local barY = self.y - 10
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

return Player
