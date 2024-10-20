require "Player"
require "Ghost"
require "Bookshelves" 

local logo 
local player
local ghosts = {}
local bookshelves = {} 
function love.load()
    player = Player:new(100, 100, bookshelves) 
    player:load()

    -- Initialize ghosts
    for i = 1, 10 do
        local ghost = Ghost:new(200 + i * 50, 200 + i * 50, bookshelves) 
        ghost:load()
        table.insert(ghosts, ghost)
    end

    -- Initialize bookshelves with the same dimensions as obstacles
    local bookshelf1 = Bookshelf:new(300, 150, 50, 50)
    local bookshelf2 = Bookshelf:new(100, 300, 50, 50)
    local bookshelf3 = Bookshelf:new(500, 400, 50, 50)

    -- Load bookshelf images
    bookshelf1:load()
    bookshelf2:load()
    bookshelf3:load()

    -- Add bookshelves to the bookshelves table
    table.insert(bookshelves, bookshelf1)
    table.insert(bookshelves, bookshelf2)
    table.insert(bookshelves, bookshelf3)

    -- Load the logo
    logo = love.graphics.newImage("assets/scsu.png")
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
