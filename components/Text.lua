--[[
    PARAMETERS:
    -> text: string - The text to be displayed
    -> font: font - The font to be used 
    -> color: color - The color of the text
    -> x: number - The x position of the text
    -> y: number - The y position of the text
    -> opacity: number - The opacity of the text
    -> align: string - The alignment of the text
    -> fade_in: boolean - If the text should fade in
    -> fade_out: boolean - If the text should fade out
    -> wrap_width: number - The width at which the text should wrap
]]
function Text(text, font, color, x, y, opacity, align, fade_in, fade_out, wrap_width)
    font = font or "p"
    fade_in = fade_in or false
    fade_out = fade_out or false
    wrap_width = wrap_width or love.graphics.getWidth()
    align = align or "left"
    opacity = opacity or 1

    local TEXT_FADE_DURATION = 5

    local fonts = {
        h1 = love.graphics.newFont(60),
        h2 = love.graphics.newFont(50),
        h3 = love.graphics.newFont(40),
        h4 = love.graphics.newFont(30),
        h5 = love.graphics.newFont(20),
        h6 = love.graphics.newFont(10),
        p = love.graphics.newFont(16)
    }

    if fade_in then
        opacity = 0.1
    end
    
    return {
        text = text,
        x = x,
        y = y,
        opacity = opacity,

        colors = {
            r = 1,
            g = 1,
            b = 1
        },

        setColor = function (self, red, green, blue)
            self.colors.r = red
            self.colors.g = green
            self.colors.b = blue
        end,

        draw = function (self, tbl_text, index)
            if self.opacity > 0 then
                love.graphics.setColor(self.colors.r, self.colors.g, self.colors.b, self.opacity)
                love.graphics.setFont(fonts[font])
                love.graphics.printf(self.text, self.x, self.y, wrap_width, align)
            else
                table.remove(tbl_text, index)
                return false
            end

            return true
        end
    }
end

return Text