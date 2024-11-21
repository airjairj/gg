function Bullet(player)
    local SPEED = 500

    local bullet = {
        x = player.x,
        y = player.y,
        radius = 3,
        angle = player.angle,
        move = {
            x = SPEED * math.cos(player.angle),
            y = SPEED * math.sin(player.angle),
        },
        initialize = function(self)
            -- Posizione iniziale del proiettile basata sulla posizione del giocatore e l'angolo
            self.x = player.x + math.cos(player.angle) * player.radius
            self.y = player.y - math.sin(player.angle) * player.radius  -- Invertito segno su Y per la direzione corretta
        end,
        
        

        draw = function(self)
            love.graphics.setColor(1, 1, 0)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        end,

        moveFunc = function(self, dt)
            -- Calcola lo spostamento in base all'angolo e la velocità
            local dx = self.move.x * dt
            local dy = self.move.y * dt

            -- Aggiorna la posizione del proiettile
            self.x = self.x + dx
            self.y = self.y - dy
        end,

        checkCollision = function(self, target)
            -- Calcola la distanza tra il centro del proiettile e il bersaglio
            local dx = self.x - target.x
            local dy = self.y - target.y
            local distance = math.sqrt(dx * dx + dy * dy)

            -- Verifica collisione
            if distance < (self.radius + target.collisionRadius) then
                return true
            end
            return false
        end,
        
        updateTimer = function(self, dt)
            if self.timer then
                self.timer = self.timer - dt
                if self.timer <= 0 then
                    self.timer = nil
                    return true
                end
            end
            return false
        end,
    }

    bullet:initialize()
    return bullet
end

return Bullet