local player = {}

function player.load()
    player.x = 100
    player.y = 100
    player.speed = 200
end

function player.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    elseif love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    end
end

function player.draw()
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)
end

return player
