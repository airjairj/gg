function Asteroid(showDebug, spawnSmall, parent_pos_x, parent_pos_y)
    local MIN_MIN_SIZE = 64  -- Dimensione minima
    local MAX_MIN_SIZE = 96  -- Dimensione minima

    local MIN_MAX_SIZE = 97 -- Dimensione minima
    local MAX_MAX_SIZE = 128 -- Dimensione massima
    local SPEED = 150

    debug = showDebug or false

    local asteroid = {
        x = 0,
        y = 0,
        radius = 0, -- Raggio basato sulla dimensione
        collisionRadius = 0, -- Raggio di collisione calcolato sui vertici
        angle = 0,
        isBig = false,
        move = {
            x = 0,
            y = 0,
            trail = {}
        },
        vertices = {},
        timer = math.random(8, 12),

        initialize = function(self)
            -- Genera una dimensione casuale
            if spawnSmall then
                local size = math.random(MIN_MIN_SIZE, MAX_MIN_SIZE)
                self.isBig = false
                self.radius = size / 2
            else
                local size = math.random(MIN_MIN_SIZE, MAX_MAX_SIZE)
                self.isBig = size > MIN_MAX_SIZE
                self.radius = size / 2
            end

            -- Posizione iniziale fuori dallo schermo
            local screenWidth = love.graphics.getWidth()
            local screenHeight = love.graphics.getHeight()
            local side = math.random(1, 4) -- 1 = sopra, 2 = sotto, 3 = sinistra, 4 = destra

            if spawnSmall then
                self.x = parent_pos_x
                self.y = parent_pos_y
            else
                if side == 1 then -- Sopra lo schermo
                    self.x = math.random(0, screenWidth)
                    self.y = -self.radius
                elseif side == 2 then -- Sotto lo schermo
                    self.x = math.random(0, screenWidth)
                    self.y = screenHeight + self.radius
                elseif side == 3 then -- Sinistra dello schermo
                    self.x = -self.radius
                    self.y = math.random(0, screenHeight)
                elseif side == 4 then -- Destra dello schermo
                    self.x = screenWidth + self.radius
                    self.y = math.random(0, screenHeight)
                end
            end

            if spawnSmall then
                self.angle = math.random() * 2 * math.pi
            else
                self.angle = math.atan((screenHeight / 2 - self.y) / (screenWidth / 2 - self.x))
            end
        end,

        drawTrail = function (self, trailColor, trailThickness, shape)
            trailColor = trailColor or {1, 1, 1}
            trailThickness = trailThickness or self.radius / 4

            local lastPoint = self.move.trail[#self.move.trail]
            if lastPoint then
                local distance = math.sqrt((self.x - lastPoint.x)^2 + (self.y - lastPoint.y)^2)
                local steps = math.ceil(distance / (trailThickness * 2))
                for i = 1, steps do
                    local t = i / steps
                    local interpolatedX = lastPoint.x + t * (self.x - lastPoint.x)
                    local interpolatedY = lastPoint.y + t * (self.y - lastPoint.y)
                    table.insert(self.move.trail, {x = interpolatedX, y = interpolatedY})
                end
            else
                table.insert(self.move.trail, {x = self.x, y = self.y})
            end

            while #self.move.trail > 20 do
                table.remove(self.move.trail, 1)
            end

            for i, point in ipairs(self.move.trail) do
                local opacity = trailColor[4] * 2 / #self.move.trail
                love.graphics.setColor(trailColor[1], trailColor[2], trailColor[3], opacity)
                love.graphics.circle("fill", point.x, point.y, trailThickness)
            end
        end,

        draw = function(self)
            local transformedVertices = {}
            for _, vertex in ipairs(self.vertices) do
                table.insert(transformedVertices, self.x + vertex.x) -- Applica traslazione X
                table.insert(transformedVertices, self.y + vertex.y) -- Applica traslazione Y
            end

            self:drawTrail( {1, 0.1, 0, 0.3}, self.collisionRadius, shape)

            love.graphics.setColor(1, 0.1, 0, 0.3)
            love.graphics.polygon("fill", transformedVertices)

            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.polygon("line", transformedVertices)

            if debug then
                -- Hitbox originale
                love.graphics.setColor(0, 1, 0, 0.3)
                love.graphics.circle("line", self.x, self.y, self.radius)

                -- Hitbox più precisa
                love.graphics.setColor(0, 0, 1, 0.5)
                love.graphics.circle("line", self.x, self.y, self.collisionRadius)
            end
        end,

        getVertices = function(self)
            local vertices = {}
            local sides = math.random(5, 8)
            for i = 1, sides do
                local angle = (i * 2 * math.pi / sides) + self.angle -- Rotazione iniziale
                local offset = math.random(self.radius * 0.5, self.radius)
                local x = offset * math.cos(angle) -- Offset rispetto al centro
                local y = offset * math.sin(angle)
                table.insert(vertices, {x = x, y = y}) -- Salva i vertici relativi
            end
            return vertices
        end,

        calculateCollisionRadius = function(self)
            local minDistance = math.huge
            local maxDistance = 0
            for _, vertex in ipairs(self.vertices) do
                local distance = math.sqrt(vertex.x * vertex.x + vertex.y * vertex.y)
                if distance < minDistance then
                    minDistance = distance
                end
                if distance > maxDistance then
                    maxDistance = distance
                end
            end
            self.collisionRadius = (minDistance + maxDistance) / 2
        end,

        moveFunc = function(self, dt)
            -- Calcola lo spostamento in base all'angolo e la velocità
            local dx = SPEED * math.cos(self.angle) * dt
            local dy = SPEED * math.sin(self.angle) * dt

            -- Aggiorna la posizione dell'asteroide
            self.x = self.x + dx
            self.y = self.y + dy
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

        checkCollision = function(self, player)
            -- Calcola la distanza tra il centro dell'asteroide e il giocatore
            local dx = self.x - player.x
            local dy = self.y - player.y
            local distance = math.sqrt(dx * dx + dy * dy)

            -- Verifica collisione
            if distance < (self.collisionRadius + player.radius) then
                -- Normale di collisione
                local nx = dx / distance
                local ny = dy / distance

                -- Separazione
                local separation = self.collisionRadius + player.radius
                player.x = self.x - separation * nx
                player.y = self.y - separation * ny

                -- Riflettività del movimento
                local dot = player.move.x * nx + player.move.y * ny
                local bounce = 0.8 -- Rimbalzo
                player.move.x = (player.move.x - 2 * dot * nx) * bounce
                player.move.y = (player.move.y - 2 * dot * ny) * bounce

                -- Trail
                player.move.trail = player.move.trail or {}
                table.insert(player.move.trail, {x = player.x, y = player.y})
                if #player.move.trail > (player.max_trail_length or 10) then
                    table.remove(player.move.trail, 1)
                end

                return true
            end
            return false
        end,
    }

    asteroid:initialize()
    asteroid.vertices = asteroid:getVertices()
    asteroid:calculateCollisionRadius()
    return asteroid
end

return Asteroid
