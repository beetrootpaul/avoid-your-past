-- game_state_start

function new_game_state_start()
    local topbar = new_topbar()
    local player = new_player({
        memory = nil,
    })
    local level = new_level({
        player = player,
    })

    local gs = {}

    gs.update = function()
        local has_started = false
        if btnp(u.buttons.l) then
            player.direct_left()
            has_started = true
        elseif btnp(u.buttons.r) then
            player.direct_right()
            has_started = true
        elseif btnp(u.buttons.u) then
            player.direct_up()
            has_started = true
        elseif btnp(u.buttons.d) then
            player.direct_down()
            has_started = true
        end

        level.animate()

        if has_started then
            return new_game_state_gameplay({
                topbar = topbar,
                player = player,
                level = level,
            })
        end
        return gs
    end

    gs.draw = function()
        level.draw_bg()

        level.draw_items({
            can_collect_coins = true,
        })

        player.draw()

        topbar.draw({
            score = 0,
            special_phase = nil,
        })

        local margin = 3
        local time_dependent_boolean = u.boolean_changing_every_nth_second(0.5)
        local glyph_color = time_dependent_boolean and u.colors.light_grey or u.colors.violet_grey
        u.print_with_outline("⬅️", player.x - player.r - margin - 8, u.topbar_h_px + player.y - 2, glyph_color, u.colors.dark_grey)
        u.print_with_outline("➡️", player.x + player.r + margin + 2, u.topbar_h_px + player.y - 2, glyph_color, u.colors.dark_grey)
        u.print_with_outline("⬆️", player.x - 3, u.topbar_h_px + player.y - player.r - margin - 6, glyph_color, u.colors.dark_grey)
        u.print_with_outline("⬇️", player.x - 3, u.topbar_h_px + player.y + player.r + margin + 2, glyph_color, u.colors.dark_grey)
    end

    return gs
end