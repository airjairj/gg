-- IMPORTS
_G.love = require("love")
local player = require("objects/player")
game = require("states/game")
local borders = require("objects/Borders")
local asteroid = require("objects/Asteroid")
local bullet = require("objects/Bullet")
local menu = require("states/Menu")

--VARIABLES
local asteroids = {}
local asteroid_spawn_time = 1.5
local asteroid_timer = 0

local bullets = {}
local shoot_timer = 0
local shoot_interval = 0.2
local isShooting = false

local load_time = 1
local elapsed_time = 0

local stars = {}

local originalWidth, originalHeight = 1920, 1080
local scaleX, scaleY = 1, 1

local isDebug = false

-- CORE FUNCTIONS
function love.load()
    love.window.setFullscreen(false) -- Puoi attivare/disattivare il fullscreen
    local screenWidth, screenHeight = love.graphics.getDimensions()
    scaleX, scaleY = screenWidth / originalWidth, screenHeight / originalHeight

    game = Game()
    player = Player(isDebug) -- Per attivare la debug mode : Player(true)
    menu = Menu(game, player)
    game:changeGameState(0) -- cambia in menu


    love.mouse.setVisible(false)
    mouse_pos = {x = 0, y = 0}


    borders = Borders(love.graphics.getWidth(), love.graphics.getHeight())

    -- Draw stars in the background on first frame
    generateStars() -- Genera le stelle
end


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

        -- Shooting
        shoot_timer = shoot_timer + dt
            if shoot_timer >= shoot_interval and isShooting then
                table.insert(bullets, Bullet(player))
                shoot_timer = 0
            end
        
    elseif game.state.menu then
        menu:run(clickedMouse)
        clickedMouse = false
    end

    --Mouse
    mouse_pos.x, mouse_pos.y = love.mouse.getPosition()
end

function love.draw()
    -- Applica la scalatura
    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)

    -- Disegna stelle sullo sfondo
    love.graphics.setColor(1, 1, 1) -- Colore bianco per le stelle
    for _, star in ipairs(stars) do
        love.graphics.rectangle("fill", star.x, star.y, star.size, star.size)
    end
 
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
        else if game.state.menu then
            menu:draw()
        end

        if not game.state.playing then
            drawCursor()
        end

    end

    borders:draw()

    -- Reset font size to normal before drawing FPS
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)

    love.graphics.pop() -- Ripristina la scala originale
end

-- KEYBOARD AND MOUSE
function love.keypressed(key)
    if key == "escape" and game.state.playing then
        game:changeGameState(1)
    elseif key == "escape" and game.state.paused then
        game:changeGameState(3)
    end

    if key == "space" and game.state.playing then
        isShooting = true
    end

    if key == "q" then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == "space" then
        isShooting = false
    end
end

function love.mousepressed(x, y, button)
    if game.state.menu then
        if button == 1 then
            clickedMouse = true
        end
    end
end

-- MISC FUNCTIONS
function love.resize(w, h)
    -- Ricalcola i fattori di scala
    scaleX, scaleY = w / originalWidth, h / originalHeight
    borders = Borders(originalWidth, originalHeight)
end

function generateStars()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    for i = 1, 200 do -- Numero di stelle
        table.insert(stars, {
            x = math.random(0, screenWidth),
            y = math.random(0, screenHeight),
            size = math.random(1, 3), -- Dimensione casuale tra 1 e 3 pixel
        })
    end
end

function drawCursor()
    -- Set arrow properties
    local radius = 10  -- Size of the arrow
    local angle = (math.pi / 2) + (math.pi/5)  -- Angle pointing upward (adjust as needed)

    love.graphics.setColor(0.7, 0.7, 0.7, 0.7) -- Arrow color dark grey
    love.graphics.polygon(
        "fill",
        mouse_pos.x + (4 / 3.5) * radius * math.cos(angle),                      -- Front tip
        mouse_pos.y - (4 / 3.5) * radius * math.sin(angle),
        mouse_pos.x + radius * math.cos(angle + 2 * math.pi / 3),               -- Left point
        mouse_pos.y - radius * math.sin(angle + 2 * math.pi / 3),
        mouse_pos.x + (radius / 7) * math.cos(angle + math.pi * 0.9),           -- Left recess
        mouse_pos.y - (radius / 7) * math.sin(angle + math.pi * 0.9),
        mouse_pos.x + (radius / 15) * math.cos(angle + math.pi),                -- Center base
        mouse_pos.y - (radius / 15) * math.sin(angle + math.pi),
        mouse_pos.x + (radius / 7) * math.cos(angle - math.pi * 0.9),           -- Right recess
        mouse_pos.y - (radius / 7) * math.sin(angle - math.pi * 0.9),
        mouse_pos.x + radius * math.cos(angle - 2 * math.pi / 3),               -- Right point
        mouse_pos.y - radius * math.sin(angle - 2 * math.pi / 3)
    )
    love.graphics.setColor(1, 1, 1, 1) -- Arrow border color white
    love.graphics.polygon(
        "line",
        mouse_pos.x + (4 / 3.5) * radius * math.cos(angle),                      -- Front tip
        mouse_pos.y - (4 / 3.5) * radius * math.sin(angle),
        mouse_pos.x + radius * math.cos(angle + 2 * math.pi / 3),               -- Left point
        mouse_pos.y - radius * math.sin(angle + 2 * math.pi / 3),
        mouse_pos.x + (radius / 7) * math.cos(angle + math.pi * 0.9),           -- Left recess
        mouse_pos.y - (radius / 7) * math.sin(angle + math.pi * 0.9),
        mouse_pos.x + (radius / 15) * math.cos(angle + math.pi),                -- Center base
        mouse_pos.y - (radius / 15) * math.sin(angle + math.pi),
        mouse_pos.x + (radius / 7) * math.cos(angle - math.pi * 0.9),           -- Right recess
        mouse_pos.y - (radius / 7) * math.sin(angle - math.pi * 0.9),
        mouse_pos.x + radius * math.cos(angle - 2 * math.pi / 3),               -- Right point
        mouse_pos.y - radius * math.sin(angle - 2 * math.pi / 3)
    )
    
end    