local Text = require "components/Text"

function Button(func, text_color, button_color, border_color, hover_color, original_color, x, y, width, height, text, font, align, font_size, text_x, text_y)
    local btn_text = {
        text = text,
        color = text_color,
        font = font,
        align = align,
        size = font_size,
        x = x,
        y = y
    }
    
    func = func or function() print("Funzionalità bottone mancante") end

    if text_y then
        btn_text.y = text_y + y
    else
        btn_text.y = y
    end

    if text_x then
        btn_text.x = text_x + x
    else
        btn_text.x = x
    end

    return {
        text_color = text_color or {r=0, g=0, b=0},
        button_color = button_color or {r=0.5, g=0.5, b=0.5},
        border_color = border_color or {r=1, g=1, b=1},
        hover_color = hover_color or {r=0.3, g=0.3, b=0.3},
        original_color = button_color,
        width = width or 100,
        height = height or 50,
        text = text or "Nessun testo",
        text_x = text_x or x or 0,
        text_y = text_y or y or 0,
        x = x or 0,
        y = y or 0,
        text_component = Text(text,font_size,text_color,btn_text.x,btn_text.y,1,align,false,false,width),

        setButtonColor = function(self, r, g, b)
            self.button_color = {r=r, g=g, b=b}
        end,

        setBorderColor = function(self, r, g, b)
            self.border_color = {r=r, g=g, b=b}
        end,

        setTextColor = function(self, r, g, b)
            self.text_color = {r=r, g=g, b=b}
        end,
        
        getPos = function(self)
            return self.x, self.y
        end,

        getTextPos = function(self)
            return self.text_x, self.text_y
        end,

        click = function(self, x, y)
            func()
        end,

        checkHover = function(self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.x and mouse_x - cursor_radius <= self.x + self.width) and
                (mouse_y + cursor_radius >= self.y and mouse_y - cursor_radius <= self.y + self.height) then
                return true
            end

            return false
        end,

        draw = function(self)
            love.graphics.setColor(self.button_color["r"], self.button_color["g"], self.button_color["b"])
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
            self.text_component:draw()

            self.text_component:setColor(self.text_color["r"], self.text_color["g"], self.text_color["b"])
            self.text_component:draw()

            love.graphics.setColor(1, 1, 1)
            
            -- Draw thick button borders
            love.graphics.setLineWidth(5)
            love.graphics.setColor(self.border_color["r"], self.border_color["g"], self.border_color["b"])
            love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
            love.graphics.setLineWidth(1)
        end,

    }
end

return Button