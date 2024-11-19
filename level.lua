love = require("love")

function love.load()
    -- Load assets, initialize variables, etc.
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    player = {
        x = 400,
        y = 300,
        speed = 200
    }
end

function love.update(dt)
    -- Update game state
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed * dt
    end
end

function love.draw()
    -- Draw the game
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)
end

local gameState = "menu"
local buttons = {
    {text = "Play", x = 350, y = 200, width = 100, height = 50, action = function() gameState = "play" end},
    {text = "Options", x = 350, y = 300, width = 100, height = 50, action = function() print("Options selected") end},
    {text = "Quit", x = 350, y = 400, width = 100, height = 50, action = function() love.event.quit() end}
}

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == "menu" then
        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.action()
            end
        end
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.setColor(1, 1, 1)
        for _, btn in ipairs(buttons) do
            love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
            love.graphics.printf(btn.text, btn.x, btn.y + 15, btn.width, "center")
        end
    elseif gameState == "play" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, 50, 50)
    end
end
function love.keypressed(key)
    if key == "escape" then
        if gameState == "play" then
            gameState = "pause"
        elseif gameState == "pause" then
            gameState = "play"
        end
    end
end

local pauseButtons = {
    {text = "Resume", x = 350, y = 200, width = 100, height = 50, action = function() gameState = "play" end},
    {text = "Main Menu", x = 350, y = 300, width = 100, height = 50, action = function() gameState = "menu" end}
}

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if gameState == "menu" then
            for _, btn in ipairs(buttons) do
                if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                    btn.action()
                end
            end
        elseif gameState == "pause" then
            for _, btn in ipairs(pauseButtons) do
                if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                    btn.action()
                end
            end
        end
    end
end

function love.draw()
    if gameState == "play" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, 50, 50)
    elseif gameState == "pause" then
        love.graphics.setColor(1, 1, 1)
        for _, btn in ipairs(pauseButtons) do
            love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
            love.graphics.printf(btn.text, btn.x, btn.y + 15, btn.width, "center")
        end
    end
end