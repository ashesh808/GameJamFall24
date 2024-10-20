require "Player"
require "Ghost"
require "Bookshelves"
require "bullet"
anim8 = require 'libraries/anim8'

local backgroundMusic  
local largeFont
local logo 
local startImage 
local player
local ghosts = {}
local bookshelves = {}
local currentScene = 1
local gameState = "start"  -- Start with the 'start' screen
local windowWidth, windowHeight = 800, 600 -- Game window dimensions
local maxBookshelves = 6 -- number of bookshelves to generate 

-- Define the scenes with different backgrounds and bookshelves
local scenes = {
    {
        backgroundImage = love.graphics.newImage("assets/carpet.jpg"),  -- Load the background image
        bookshelves = {
            Bookshelf:new(300, 150, 50, 50),
            Bookshelf:new(100, 300, 50, 50),
            Bookshelf:new(500, 400, 50, 50)
        }
    },
    {
        backgroundImage = love.graphics.newImage("assets/wood.jpg"),
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
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Load background music
    backgroundMusic = love.audio.newSource("assets/sounds/backgroundMusic.wav", "stream")
    backgroundMusic:setLooping(true) 
    backgroundMusic:setVolume(0.5)    
    backgroundMusic:play()            

    startImage = love.graphics.newImage("assets/millerinfo.jpg")
    largeFont = love.graphics.newFont(36)

    -- Initialize player and ghosts for the first scene
    player = Player:new(100, 100, scenes[currentScene].bookshelves)
    player:load()

    for i = 1, 10 do
        local ghost = Ghost:new(200 + i * 50, 200 + i * 50, scenes[currentScene].bookshelves)
        ghost:load()
        table.insert(ghosts, ghost)
    end

    -- Load bookshelves for the current scene
    for _, bookshelf in ipairs(scenes[currentScene].bookshelves) do
        bookshelf:load()
    end

    -- Load the logo
    logo = love.graphics.newImage("assets/scsu.png")

    -- Generate random bookshelves
    generateRandomBookshelves(maxBookshelves)
end

-- Generate random bookshelves
function generateRandomBookshelves(count)
    local minDistance = 30 -- Minimum distance between bookshelves

    for i = 1, count do
        local bookshelf
        local validPosition = false

        while not validPosition do
            -- Randomize position and size within the game window
            local width = math.random(50, 200)  -- Random width between 50 and 200 pixels
            local height = math.random(30, 100) -- Random height between 30 and 100 pixels
            local x = math.random(0, windowWidth - width) -- Random x within the window, allowing room for the width
            local y = math.random(0, windowHeight - height) -- Random y within the window, allowing room for the height

            bookshelf = Bookshelf:new(x, y, width, height)
            bookshelf:load()

            -- Check for distance with existing bookshelves
            validPosition = true -- Assume it's valid until proven otherwise

            for _, existingBookshelf in ipairs(bookshelves) do
                -- Get existing bookshelf properties
                local existingX, existingY = existingBookshelf.x, existingBookshelf.y
                local existingWidth, existingHeight = existingBookshelf.width, existingBookshelf.height

                -- Check for overlap or proximity
                if not (x + width + minDistance < existingX or 
                        y + height + minDistance < existingY or 
                        x - minDistance > existingX + existingWidth or 
                        y - minDistance > existingY + existingHeight) then
                    validPosition = false
                    break -- No need to check further if an overlap is found
                end
            end
        end

        -- After finding a valid position, add the bookshelf to the list
        table.insert(bookshelves, bookshelf)
    end
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

    -- Reset player position
    player.x = 100
    player.y = 100

    -- Load bookshelves for the new scene
    local bookshelves = scenes[currentScene].bookshelves
    for _, bookshelf in ipairs(bookshelves) do
        bookshelf:load()
    end

    -- Initialize new ghosts for the new scene
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

        -- Update ghosts
        for _, ghost in ipairs(ghosts) do
            ghost:update(dt)
        end
    end
end

function love.keypressed(key)
    player:keyPressed(key)  -- Fire bullets with the player's key press
end

function love.draw()
    if gameState == "start" then
        -- Start screen
        love.graphics.draw(startImage, 0, 0, 0, love.graphics.getWidth() / startImage:getWidth(), love.graphics.getHeight() / startImage:getHeight())
        love.graphics.setFont(largeFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press Enter to Start", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
    elseif gameState == "play" then
        -- Play scene
        local scene = scenes[currentScene]

        -- Check if the scene has a background image
        if scene.backgroundImage then
            love.graphics.draw(scene.backgroundImage, 0, 0, 0, love.graphics.getWidth() / scene.backgroundImage:getWidth(), love.graphics.getHeight() / scene.backgroundImage:getHeight())
        else
            -- If no image, use the background color
            love.graphics.clear(1, 1, 1)
        end

        -- Draw the bookshelves
        for _, bookshelf in ipairs(scene.bookshelves) do
            bookshelf:draw()
            bookshelf:drawCollisionBox()
        end

        -- Draw random bookshelves
        for _, bookshelf in ipairs(bookshelves) do
            bookshelf:draw()
            bookshelf:drawCollisionBox()
        end

        -- Draw player
        player:draw()

        -- Draw ghosts
        for _, ghost in ipairs(ghosts) do
            ghost:draw()
        end

        -- Draw the logo in the top right-hand corner
        local logoWidth = logo:getWidth()
        local windowWidth = love.graphics.getWidth()
        local scaleFactor = 0.20
        love.graphics.draw(logo, windowWidth - (logoWidth * scaleFactor) - 10, 10, 0, scaleFactor, scaleFactor)
    end
end
