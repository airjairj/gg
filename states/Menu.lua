local Button = require "../components/Button"

function Menu(game,player)
    local funcs = {
        newGame = function()
            --game:startNewGame()
            game:changeGameState(3)
        end,
        quitGame = function()
            love.event.quit()
        end
    }

    local buttons = {
        Button(
            funcs.newGame,
            {r=0.9, g=0.9, b=0.9, a=1},       -- Text color (Light Gray)
            {r=0.08, g=0.3, b=0.6, a=1},      -- Button color (Dark Space Blue)
            {r=0.15, g=0.5, b=0.7, a=1},      -- Border color (Darker Cyan)
            {r=0.08-.2, g=0.3-.2, b=0.6-.2, a=1},
            {r=0.6, g=0.08, b=0.08, a=1},     -- Button color (Dark Red)
            love.graphics.getWidth()/2.3,
            love.graphics.getHeight()/3,
            love.graphics.getWidth()/7,
            love.graphics.getHeight()/14,
            "Gioca",
            nil,
            "center",
            "h3",
            0,
            (love.graphics.getHeight()/14)/5.5
        ),
        Button(
            nil,
            {r=0.9, g=0.9, b=0.9, a=1},       -- Text color (Light Gray)
            {r=0.3, g=0.3, b=0.3, a=1},       -- Button color (Metallic Gray)
            {r=0.5, g=0.5, b=0.5, a=1},       -- Border color (Steel Gray)
            {r=0.3-.2, g=0.3-.2, b=0.3-.2, a=1},
            {r=0.6, g=0.08, b=0.08, a=1},     -- Button color (Dark Red)
            love.graphics.getWidth()/2.3,
            love.graphics.getHeight()/2,
            love.graphics.getWidth()/7,
            love.graphics.getHeight()/14,
            "Impostazioni",
            nil,
            "center",
            "h3",
            0,
            (love.graphics.getHeight()/14)/5.5
        ),
        Button(
            funcs.quitGame,
            {r=0.9, g=0.9, b=0.9, a=1},       -- Text color (Light Gray)
            {r=0.6, g=0.08, b=0.08, a=1},     -- Button color (Dark Red)
            {r=0.8, g=0.2, b=0.2, a=1},       -- Border color (Subdued Lighter Red)
            {r=0.6-.2, g=0.08-.2, b=0.08-.2, a=1},
            {r=0.6, g=0.08, b=0.08, a=1},     -- Button color (Dark Red)
            love.graphics.getWidth()/2.3,
            love.graphics.getHeight()/1.5,
            love.graphics.getWidth()/7,
            love.graphics.getHeight()/14,
            "Esci",
            nil,
            "center",
            "h3",
            0,
            (love.graphics.getHeight()/14)/5.5
        ),
    }
    
    return {

        run = function (self, clicked)
            local mouse_x, mouse_y = love.mouse.getPosition()
            
            for _, button in pairs(buttons) do
                if button:checkHover(mouse_x, mouse_y, 10) then
                    if clicked then
                    button:click(mouse_x, mouse_y)
                    end
                    button:setButtonColor(button.hover_color.r, button.hover_color.g, button.hover_color.b)
                else
                    button:setButtonColor(button.original_color.r, button.original_color.g, button.original_color.b)
                end
            end
        end,

        draw = function()
            for _, button in ipairs(buttons) do
                button:draw()
            end
        end,
    }
end

return Menu