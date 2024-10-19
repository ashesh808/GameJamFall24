require "Player"

local player
local obstacles = {
    {x = 300, y = 150, width = 200, height = 20},
    {x = 100, y = 300, width = 20, height = 200},
    {x = 500, y = 400, width = 150, height = 20}
}

function love.load()
    player = Player:new(100, 100, obstacles) -- Pass obstacles to player
    player:load()
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    -- Set the background color to a light brown (scene color)
    love.graphics.clear(222 / 255, 184 / 255, 135 / 255)

    -- Draw the obstacles in the scene
    for _, obstacle in ipairs(obstacles) do
        love.graphics.setColor(160 / 255, 82 / 255, 45 / 255) -- Medium brown
        love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height)
    end

    -- Draw the player
    player:draw()
end
