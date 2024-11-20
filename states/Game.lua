require "../components/Text"
function Game()
    return {
        state = {
            menu = false,
            paused = false,
            gameover = false,
            playing = false,
        },

        changeGameState = function (self, state)
            self.state.menu = state == 0        -- 0 = menu
            self.state.paused = state == 1      -- 1 = paused
            self.state.gameover = state == 2    -- 2 = gameover
            self.state.playing = state == 3     -- 3 = playing
        end,

        -- TEMP
        draw = function (self, faded)
            if faded then
                Text(
                    "PAUSA",
                    "h1",
                    {1, 1, 1},
                    0,
                    love.graphics.getHeight() *.4,
                    1,
                    "center"
                ):draw()
            end
        end
    }
end

return Game