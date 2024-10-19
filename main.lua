-- Player table
local player = {
    x = 100,       -- X position
    y = 100,       -- Y position
    speed = 200,   -- Movement speed
    width = 16,    -- Width of the player sprite
    height = 18    -- Height of the player sprite
}

local animation -- Variable to store the player animation

-- Obstacles (brown objects) in the scene
local obstacles = {
    {x = 300, y = 150, width = 200, height = 20},
    {x = 100, y = 300, width = 20, height = 200},
    {x = 500, y = 400, width = 150, height = 20}
}

function love.load()
    love.window.setTitle("Sprite-based Player Animation")
    love.window.setMode(800, 600) -- Set the window size (width, height)

    -- Load the player animation
    local playerImage = love.graphics.newImage("assests/oldHero.png")
    animation = newAnimation(playerImage, player.width, player.height, 1) -- Width, height, and duration for animation
end

function love.update(dt)
    -- Update the animation timer
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end

    -- Temporary player position
    local nextX, nextY = player.x, player.y

    -- Player movement with WASD
    if love.keyboard.isDown("w") then
        nextY = player.y - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        nextY = player.y + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        nextX = player.x - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        nextX = player.x + player.speed * dt
    end

    -- Check for collisions with obstacles
    if not checkCollision(nextX, nextY, player.width, player.height) then
        player.x, player.y = nextX, nextY
    end
end

function love.draw()
    -- Set the background color to a light brown (scene color)
    love.graphics.clear(222 / 255, 184 / 255, 135 / 255)

    -- Draw the obstacles in the scene
    for _, obstacle in ipairs(obstacles) do
        love.graphics.setColor(160 / 255, 82 / 255, 45 / 255) -- Medium brown
        love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height)
    end

    -- Draw the player animation
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.setColor(1, 1, 1) -- Reset color to white for sprite
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x, player.y, 0, 4, 4) -- Scale to make the sprite larger
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image
    animation.quads = {}

    -- Split the sprite sheet into individual frames (quads)
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

-- Function to check if the player collides with any obstacle
function checkCollision(x, y, width, height)
    for _, obstacle in ipairs(obstacles) do
        if x < obstacle.x + obstacle.width and
           x + width > obstacle.x and
           y < obstacle.y + obstacle.height and
           y + height > obstacle.y then
            return true
        end
    end
    return false
end