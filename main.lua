-- Includo i moduli
local menu = require("menu")
local player = require("player")

-- Stato del gioco
local gameState = "menu"

function love.load()
    -- Carico i moduli
    menu.load(gameState)
    player.load()
end

function love.update(dt)
    if gameState == "menu" then
        menu.update(dt)
    elseif gameState == "play" then
        player.update(dt)
    end
end

function love.draw()
    if gameState == "menu" then
        menu.draw()
    elseif gameState == "play" then
        player.draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == "menu" then
        menu.mousepressed(x, y, button)
    end
end
