-- game_state_over

function new_game_state_over(params)
    local player = params.player
    local level = params.level

    local gs = {}

    gs.update = function()
        if btnp(u.buttons.x) then
            extcmd("reset")
        end
        return gs
    end

    gs.draw = function()
        level.draw_bg()
        level.draw_items({
            can_collect_coins = true,
        })
        player.draw()
    end

    return gs
end