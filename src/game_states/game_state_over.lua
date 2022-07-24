-- game_state_over

function new_game_state_over(params)
    sfx(-1, 0)
    sfx(4, 1)
    sfx(5, 2)
    sfx(6, 3)

    local player = params.player
    local level = params.level
    local score = params.score

    local ttl_max = 120
    local ttl = ttl_max
    local ttl_collapse_start = 4
    local ttl_expansion_start = ttl_max - 20
    local ttl_expansion_end = ttl_expansion_start - 4

    local sash_h_max = 30
    local sash_center_y = u.topbar_h_px + (u.screen_edge_px - u.topbar_h_px) / 2

    local gs = {}

    gs.update = function()
        if ttl <= 0 then
            return new_game_state_start()
        end
        if ttl < ttl_expansion_end then
            if btnp(u.buttons.l) or btnp(u.buttons.r) or btnp(u.buttons.u) or btnp(u.buttons.d) then
                ttl = ttl_collapse_start
            end
        end
        ttl = ttl - 1
        return gs
    end

    gs.draw = function()
        level.draw_bg()
        level.draw_items({
            can_collect_coins = true,
        })
        player.draw()

        local sash_h
        local text
        if ttl > ttl_expansion_start then
            sash_h = 0
        elseif ttl <= ttl_expansion_start and ttl >= ttl_expansion_end then
            sash_h = sash_h_max * (ttl_expansion_start - ttl) / (ttl_expansion_start - ttl_expansion_end)
        elseif ttl <= ttl_collapse_start then
            sash_h = sash_h_max * ttl / ttl_collapse_start
        else
            sash_h = sash_h_max
            text = {
                heading = "your score",
                score = tostr(score),
            }
        end
        if sash_h > 0 then
            rectfill(
                0, sash_center_y - sash_h / 2,
                u.screen_edge_px - 1, sash_center_y + sash_h / 2 - 1,
                u.colors.dark_green
            )
        end
        if text then
            local text_heading_w = u.measure_text_width(text.heading)
            local text_score_w = u.measure_text_width(text.score)
            print(
                text.heading,
                u.screen_edge_px / 2 - text_heading_w / 2,
                sash_center_y - u.text_height_px - 3,
                u.colors.white
            )
            u.print_with_outline(
                text.score,
                u.screen_edge_px / 2 - text_score_w / 2,
                sash_center_y + 2,
                u.colors.pink,
                u.colors.black
            )
        end
    end

    return gs
end