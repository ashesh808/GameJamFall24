require "Player"
require "Ghost"
require "Bookshelves" 

 anim8 = require 'libraries/anim8'

local logo 
local player
local ghosts = {}
local bookshelves = {} 
local maxBookshelves = 6 -- number of bookshelves  to generate 
local windowWidth, windowHeight = 800, 600 -- Game window dimensions


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = Player:new(100, 100, bookshelves) 
    player:load()

    -- Initialize ghosts
    for i = 1, 10 do
        local ghost = Ghost:new(200 + i * 50, 200 + i * 50, {}) 
        ghost:load()
        table.insert(ghosts, ghost)
    end

    generateRandomBookshelves(5)

        -- Load the logo
        logo = love.graphics.newImage("assets/scsu.png")
    end

    -- generate randdom bookshelves using an for loop 
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


function love.update(dt)
    player:update(dt, ghosts)

    -- Update ghosts
    for _, ghost in ipairs(ghosts) do
        ghost:update(dt)
    end

end

function love.draw()
    love.graphics.clear(245 / 255, 222 / 255, 179 / 255) --background of whole game

    -- Draw bookshelves instead of obstacles
    for _, bookshelf in ipairs(bookshelves) do
        bookshelf:draw() -- Draw the bookshelf images
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
    local logoHeight = logo:getHeight()
    local windowWidth = love.graphics.getWidth()
    local scaleFactor = 0.20
    love.graphics.draw(logo, windowWidth - (logoWidth * scaleFactor) - 10, 10, 0, scaleFactor, scaleFactor)

end