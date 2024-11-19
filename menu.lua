local menu = {}
local buttons = {}

local function createMenu(buttons)
    menuButtons = buttons
end

-- Funzione per inizializzare il menu
function menu.load(initialState)
    buttons = {
        {id = "PLAY", text = "Play", x = 350, y = 200, width = 100, height = 50, action = function() initialState = "play" end},
        {id = "OPTIONS", text = "Options", x = 350, y = 300, width = 100, height = 50, action = function() print("Options selected") end},
        {id = "QUIT", text = "Quit", x = 350, y = 400, width = 100, height = 50, action = function() love.event.quit() end},
    }
end

function menu.update(dt)
    -- Qui potresti aggiungere animazioni o transizioni del menu
end

function menu.draw()
    love.graphics.setColor(1, 1, 1)
    for _, btn in ipairs(buttons) do
        love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
        love.graphics.printf(btn.text, btn.x, btn.y + 15, btn.width, "center")
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                if btn.id == "PLAY" then
                    -- Start the game
                    btn.action()
                end
                if btn.id == "OPTIONS" then
                    -- Open the options menu
                    createMenu({
                        {id = "RESUME", text = "Resume", x = 350, y = 200, width = 100, height = 50, action = function() gameState = "play" end},
                        {id = "MENU", text = "Main Menu", x = 350, y = 300, width = 100, height = 50, action = function() gameState = "menu" end},
                    })
                    btn.action()
                end
                if btn.id == "QUIT" then
                    -- Quit the game
                    love.event.quit()
                    btn.action()
                end
            end
        end
    end
end

return menu
