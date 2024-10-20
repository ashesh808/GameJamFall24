Bookshelf = {}
Bookshelf.__index = Bookshelf

local bookshelfImage

function Bookshelf:new(x, y, width, height)
    local self = setmetatable({}, Bookshelf)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    return self
end

function Bookshelf:load()
    -- Load the bookshelf image
    bookshelfImage = love.graphics.newImage("assets/bookshelf.png")
end

function Bookshelf:draw()
    -- Draw the bookshelf image at the given position and scale it to fit the width and height
    love.graphics.draw(bookshelfImage, self.x, self.y, 0, self.width / bookshelfImage:getWidth(), self.height / bookshelfImage:getHeight())

    function Bookshelf:drawCollisionBox()
         love.graphics.setColor(0,1,1)
         love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
         love.graphics.setColor(1, 1, 1)
    end
end
