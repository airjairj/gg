_G.love = require("love")
local player = require("objects/player")
game = require("states/game")
local borders = require("objects/Borders")
local asteroid = require("objects/Asteroid")
local bullet = require("objects/Bullet")

local asteroids = {}
local asteroid_spawn_time = 1.5
local asteroid_timer = 0

local bullets = {}

local isDebug = false

function love.load()
    game = Game()
    game:changeGameState(3) -- cambia in menu

    --love.mouse.setVisible(false)
    mouse_pos = {x = 0, y = 0}

    player = Player(isDebug) -- Per attivare la debug mode : Player(true)
    borders = Borders(love.graphics.getWidth(), love.graphics.getHeight())
end

local load_time = 1.5
local elapsed_time = 0

function love.update(dt)

    -- FAKE LOADING
    elapsed_time = elapsed_time + dt
    if elapsed_time < load_time then
        return
    end


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

        -- Update bullets and check for collisions with asteroids
        for i, bullet in ipairs(bullets) do
            bullet:moveFunc(dt)
            
            for j, asteroidd in ipairs(asteroids) do
                if bullet:checkCollision(asteroidd) then
                    table.remove(bullets, i)

                    if asteroidd.isBig then
                        local offset = 10
                        table.insert(asteroids, asteroid(isDebug, true, asteroidd.x + offset, asteroidd.y + offset))
                        table.insert(asteroids, asteroid(isDebug, true, asteroidd.x - offset, asteroidd.y - offset))
                    end
                    table.remove(asteroids, j)
                end
            end

            if bullet:updateTimer(dt) then
                table.remove(bullets, i)
            end
        end

        -- Spawn new asteroids
        asteroid_timer = asteroid_timer + dt
        if asteroid_timer >= asteroid_spawn_time then
            table.insert(asteroids, asteroid(isDebug))
            asteroid_timer = 0
        end
    end

    --Mouse
    mouse_pos.x, mouse_pos.y = love.mouse.getPosition()
end

function love.draw()
     
    if game.state.playing or game.state.paused then
        player:draw()

        -- Draw asteroids
        for _, asteroid in ipairs(asteroids) do
            asteroid:draw()
        end

        -- Draw bullets
        for _, bullet in ipairs(bullets) do
            bullet:draw()
        end

        game:draw(game.state.paused)
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
    
    if key == "space" and game.state.playing then
        table.insert(bullets, Bullet(player))
    end

    if key == "q" then
        love.event.quit()
    end
end
