-- game_state_splash

function new_game_state_splash()
    local ttl_max = 120
    local ttl = ttl_max
    local ttl_collapse_start = 4

    local sash_h_max = 30
    local sash_center_y = u.topbar_h_px + (u.screen_edge_px - u.topbar_h_px) / 2

    local gs = {}

    gs.update = function()
        if ttl <= 0 then
            return new_game_state_start()
        end
        if btnp(u.buttons.l) or btnp(u.buttons.r) or btnp(u.buttons.u) or btnp(u.buttons.d) then
            ttl = ttl_collapse_start
        end
        ttl = ttl - 1
        return gs
    end

    gs.draw = function()
        rectfill(
            0, u.topbar_h_px,
            u.screen_edge_px - 1, u.screen_edge_px - 1,
            u.colors.dark_blue
        )

        local sash_h
        local text
        if ttl <= ttl_collapse_start then
            sash_h = sash_h_max * ttl / ttl_collapse_start
        else
            sash_h = sash_h_max
            text = {
                title = "avoid your past",
                author = "by @beetrootpaul",
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
            local text_title_w = u.measure_text_width(text.title)
            local text_author_w = u.measure_text_width(text.author)
            u.print_with_outline(
                text.title,
                u.screen_edge_px / 2 - text_title_w / 2,
                sash_center_y - u.text_height_px - 3,
                u.colors.yellow,
                u.colors.black
            )
            print(
                text.author,
                u.screen_edge_px / 2 - text_author_w / 2,
                sash_center_y + 2,
                u.colors.white
            )
        end
    end

    return gs
end