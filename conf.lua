-- Require the Love2D framework
local love = require("love")

-- Function to configure the game settings
function love.conf(app)
    -- Set the window title
    app.window.title = "Titolo del gioco"
    -- Set the window width
    app.window.width = 1920
    -- Set the window height
    app.window.height = 1080
    -- Make the window resizable
    app.window.resizable = true
end