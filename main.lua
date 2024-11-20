_G.love = require("love")
local player = require("objects/player")
local Game = require("states/game")
local borders = require("objects/Borders")
local Asteroid = require("objects/Asteroid")

local asteroids = {}
local asteroid_spawn_time = 3
local asteroid_timer = 0


function love.load()
    game = Game()
    game:changeGameState(3)

    love.mouse.setVisible(false)
    mouse_pos = {x = 0, y = 0}

    player = Player() -- Per attivare la debug mode : Player(true)
    borders = Borders(love.graphics.getWidth(), love.graphics.getHeight())
end

local load_time = 1.5
local elapsed_time = 0

function love.update(dt)

    if game.state.playing then
        player:moveFunc()
        borders:checkCollision(player)

        -- Update asteroids
        for i, asteroid in ipairs(asteroids) do
            asteroid:checkCollision(player)
            asteroid:moveFunc(dt)
            if asteroid:updateTimer(dt) then
                table.remove(asteroids, i)
            end
        end

        -- Spawn new asteroids
        asteroid_timer = asteroid_timer + dt
        if asteroid_timer >= asteroid_spawn_time then
            table.insert(asteroids, Asteroid())
            asteroid_timer = 0
        end
    end

    elapsed_time = elapsed_time + dt
    if elapsed_time < load_time then
        return
    end

    --Mouse
    mouse_pos.x, mouse_pos.y = love.mouse.getPosition()
end

function love.draw()
     
    if game.state.playing or game.state.paused then
        player:draw()
        game:draw(game.state.paused)

        -- Draw asteroids
        for _, asteroid in ipairs(asteroids) do
            asteroid:draw()
        end
    end

    borders:draw()


    -- Reset font size to normal before drawing FPS
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
end

--  TEMP
function love.keypressed(key)
    if key == "escape" and game.state.playing then
        game:changeGameState(1)
    elseif key == "escape" and game.state.paused then
        game:changeGameState(3)
    end

    if key == "q" then
        love.event.quit()
    end
end