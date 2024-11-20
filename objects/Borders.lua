function Borders(screenWidth, screenHeight)
    return {
        screenWidth = screenWidth,
        screenHeight = screenHeight,

        draw = function(self)
            love.graphics.setColor(0, 1, 0) -- Set color to green
            love.graphics.setLineWidth(2) 
            love.graphics.rectangle("line", 0, 0, self.screenWidth, self.screenHeight)
            love.graphics.setColor(1, 1, 1) -- Reset color to white
            love.graphics.setLineWidth(1) 
        end,

        checkCollision = function(self, player)
            local bounced = false
        
            if player.x - player.radius < 0 then
                player.x = player.radius
                player.move.x = -player.move.x
                bounced = true
            elseif player.x + player.radius > self.screenWidth then
                player.x = self.screenWidth - player.radius
                player.move.x = -player.move.x
                bounced = true
            end
        
            if player.y - player.radius < 0 then
                player.y = player.radius
                player.move.y = -player.move.y
                bounced = true
            elseif player.y + player.radius > self.screenHeight then
                player.y = self.screenHeight - player.radius
                player.move.y = -player.move.y
                bounced = true
            end
        
            if bounced then
                table.insert(player.move.trail, {x = player.x, y = player.y})
                if #player.move.trail > player.max_trail_length then
                    table.remove(player.move.trail, 1)
                end
            end
        end
    }
end

return Borders
