function love.load()
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5) -- Set background color to gray
    font = love.graphics.newFont(32) -- Set font size
    love.graphics.setFont(font)
end

function love.draw()
    love.graphics.setColor(1, 1, 1) -- Set text color to white
    love.graphics.print("Hello, World!", 300, 200) -- Display text at (300, 200)
end
