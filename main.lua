require "Player"
require "Ghost"
require "Bookshelves"

local largeFont

local logo 
local startImage 
local player
local ghosts = {}
local currentScene = 1
local gameState = "start"  

local scenes = {
    {
        backgroundColor = {245 / 255, 222 / 255, 179 / 255}, -- Light brown
        bookshelves = {
            Bookshelf:new(300, 150, 50, 50),
            Bookshelf:new(100, 300, 50, 50),
            Bookshelf:new(500, 400, 50, 50)
        }
    },
    {
        backgroundColor = {200 / 255, 230 / 255, 201 / 255}, -- Light green
        bookshelves = {
            Bookshelf:new(100, 50, 50, 50),
            Bookshelf:new(160, 50, 50, 50),
            Bookshelf:new(220, 50, 50, 50),
            Bookshelf:new(280, 50, 50, 50),
            Bookshelf:new(340, 50, 50, 50),
            Bookshelf:new(400, 50, 50, 50),
            Bookshelf:new(460, 50, 50, 50),
            Bookshelf:new(520, 50, 50, 50),
            Bookshelf:new(580, 50, 50, 50)
        }
    }
}

function love.load()
    startImage = love.graphics.newImage("assets/millerinfo.jpg")
    largeFont = love.graphics.newFont(36)

    player = Player:new(100, 100, scenes[currentScene].bookshelves)
    player:load()
    for i = 1, 10 do
        local ghost = Ghost:new(200 + i * 50, 200 + i * 50, scenes[currentScene].bookshelves)
        ghost:load()
        table.insert(ghosts, ghost)
    end
    for _, bookshelf in ipairs(scenes[currentScene].bookshelves) do
        bookshelf:load()
    end
    logo = love.graphics.newImage("assets/scsu.png")
end

function changeScene(direction)
    if direction == "next" then
        currentScene = currentScene + 1
        if currentScene > #scenes then
            currentScene = 1
        end
    elseif direction == "previous" then
        currentScene = currentScene - 1
        if currentScene < 1 then
            currentScene = #scenes
        end
    end

    player.x = 100
    player.y = 100

    bookshelves = scenes[currentScene].bookshelves
    for _, bookshelf in ipairs(bookshelves) do
        bookshelf:load()
    end

    ghosts = {}
    for i = 1, 10 do
        local ghost = Ghost:new(200 + i * 50, 200 + i * 50, bookshelves)
        ghost:load()
        table.insert(ghosts, ghost)
    end
end

function love.update(dt)
    if gameState == "start" then
        if love.keyboard.isDown("return") then
            gameState = "play"  
        end
    elseif gameState == "play" then
        player:update(dt, ghosts)
        if player.x > love.graphics.getWidth() then
            changeScene("next")
        elseif player.x < 0 then
            changeScene("previous")
        end
        for _, ghost in ipairs(ghosts) do
            ghost:update(dt)
        end
    end
end

function love.draw()
    if gameState == "start" then
        love.graphics.draw(startImage, 0, 0, 0, love.graphics.getWidth() / startImage:getWidth(), love.graphics.getHeight() / startImage:getHeight())
        love.graphics.setFont(largeFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press Enter to Start", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
    elseif gameState == "play" then
        -- Set the background color based on the current scene
        local scene = scenes[currentScene]
        love.graphics.clear(scene.backgroundColor[1], scene.backgroundColor[2], scene.backgroundColor[3])

        -- Draw the bookshelves for the current scene
        for _, bookshelf in ipairs(scene.bookshelves) do
            bookshelf:draw()
            bookshelf:drawCollisionBox()
        end

        -- Draw the player
        player:draw()

        -- Draw the ghosts
        for _, ghost in ipairs(ghosts) do
            ghost:draw()
        end

        -- Draw the logo at the top right-hand corner with scaling
        local logoWidth = logo:getWidth()
        local windowWidth = love.graphics.getWidth()
        local scaleFactor = 0.20
        love.graphics.draw(logo, windowWidth - (logoWidth * scaleFactor) - 10, 10, 0, scaleFactor, scaleFactor)
    end
end
