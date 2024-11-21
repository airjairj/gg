function Player(showDebug)
    local SIZE = 32
    local VIEW_ANGLE = math.rad(90)
    
    debug = showDebug or false

    return
    {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SIZE / 2,
        angle = VIEW_ANGLE,
        rotation = 0,
        accelerating = false,
        max_trail_length = 10,
        move = {x = 0,
                y = 0,
                speed = 5,
                trail = {}
                },

        drawTrail = function (self, trailColor, trailThickness)
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

            while #self.move.trail > self.max_trail_length do
                table.remove(self.move.trail, 1)
            end

            for i, point in ipairs(self.move.trail) do
                local opacity = i / #self.move.trail
                love.graphics.setColor(trailColor[1], trailColor[2], trailColor[3], opacity)
                love.graphics.circle("fill", point.x, point.y, trailThickness)
            end
        end,

        draw = function (self)
            local opacity = 1

            self:drawTrail( {1, 0.22, 0.1}, self.radius / 4)

            if debug then
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("line", self.x, self.y, self.radius)
            end

            love.graphics.setColor(1, 1, 1, opacity)
            
            love.graphics.setLineWidth(2) 
            -- IMPORTANTE: SE LO SFONDO CAMBIA COLORE QUESTO COLORE DEVE CAMBIARE CON ESSO
            love.graphics.setColor(0, 0, 0, 1) -- Set color to background color (black in this case)
            love.graphics.polygon(
            "fill",
            self.x + (4/3.5)*self.radius * math.cos(self.angle),                        -- Punta davanti
            self.y - (4/3.5)*self.radius * math.sin(self.angle),
            self.x + self.radius * math.cos(self.angle + 2 * math.pi / 3),           -- Punto sinistro
            self.y - self.radius * math.sin(self.angle + 2 * math.pi / 3),
            self.x + (self.radius / 7) * math.cos(self.angle + math.pi * 0.9),       -- Incavo sinistro
            self.y - (self.radius / 7) * math.sin(self.angle + math.pi * 0.9),
            self.x + (self.radius / 15) * math.cos(self.angle + math.pi),             -- Fondo centrale
            self.y - (self.radius / 15) * math.sin(self.angle + math.pi),
            self.x + (self.radius / 7) * math.cos(self.angle - math.pi * 0.9),       -- Incavo destro
            self.y - (self.radius / 7) * math.sin(self.angle - math.pi * 0.9),
            self.x + self.radius * math.cos(self.angle - 2 * math.pi / 3),           -- Punto destro
            self.y - self.radius * math.sin(self.angle - 2 * math.pi / 3)
            )
            love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
            love.graphics.polygon(
            "line",
            self.x + (4/3.5)*self.radius * math.cos(self.angle),                        -- Punta davanti
            self.y - (4/3.5)*self.radius * math.sin(self.angle),
            self.x + self.radius * math.cos(self.angle + 2 * math.pi / 3),           -- Punto sinistro
            self.y - self.radius * math.sin(self.angle + 2 * math.pi / 3),
            self.x + (self.radius / 7) * math.cos(self.angle + math.pi * 0.9),       -- Incavo sinistro
            self.y - (self.radius / 7) * math.sin(self.angle + math.pi * 0.9),
            self.x + (self.radius / 15) * math.cos(self.angle + math.pi),             -- Fondo centrale
            self.y - (self.radius / 15) * math.sin(self.angle + math.pi),
            self.x + (self.radius / 7) * math.cos(self.angle - math.pi * 0.9),       -- Incavo destro
            self.y - (self.radius / 7) * math.sin(self.angle - math.pi * 0.9),
            self.x + self.radius * math.cos(self.angle - 2 * math.pi / 3),           -- Punto destro
            self.y - self.radius * math.sin(self.angle - 2 * math.pi / 3)
            )
            
            

        end,

        moveFunc = function(self)
            local FPS = love.timer.getFPS()
            local friction = 0.7

            self.rotation = 360/180 * math.pi/FPS

            if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            self.angle = self.angle + self.rotation
            end
            if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            self.angle = self.angle - self.rotation
            end

            if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            self.accelerating = true
            elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            self.accelerating = false
            self.move.x = self.move.x - 2*friction * self.move.x/FPS
            self.move.y = self.move.y - 2*friction * self.move.y/FPS
            else
            self.accelerating = false
            end

            if self.accelerating then
            self.move.x = self.move.x + self.move.speed * math.cos(self.angle)/FPS
            self.move.y = self.move.y - self.move.speed * math.sin(self.angle)/FPS
            else
            if self.move.x ~= 0 or self.move.y ~= 0 then
                self.move.x = self.move.x - friction * self.move.x/FPS
                self.move.y = self.move.y - friction * self.move.y/FPS
            end
            end

            self.x = self.x + self.move.x
            self.y = self.y + self.move.y
        end,
    }
end

return Player