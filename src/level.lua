-- level

function new_level(params)
    local player = params.player
    local memory_trigger = nil
    local invulnerability_trigger = nil
    local bg_color_normal = u.colors.dark_grey
    local bg_color_invulnerability = u.colors.pink
    local bg_color = bg_color_normal

    local get_tiles_close_to_player = function()
        local left_tile_x = flr((player.x - player.r) / u.tile_length) + 1
        local right_tile_x = flr((player.x + player.r) / u.tile_length) + 1
        local top_tile_y = flr((player.y - player.r) / u.tile_length) + 1
        local bottom_tile_y = flr((player.y + player.r) / u.tile_length) + 1

        local close_tiles = {}
        local margin_tiles = 3
        for tile_x = left_tile_x - margin_tiles, right_tile_x + margin_tiles do
            for tile_y = top_tile_y - margin_tiles, bottom_tile_y + margin_tiles do
                close_tiles[tile_x .. "_" .. tile_y] = true
            end
        end
        return close_tiles
    end

    local spawn_memory_trigger = function()
        local tiles_close_to_player = get_tiles_close_to_player()
        local available_tiles = {}
        local margin_tiles = 1
        for tile_x = 1 + margin_tiles, u.screen_edge_tiles - margin_tiles do
            for tile_y = 1 + margin_tiles, u.screen_edge_tiles - margin_tiles do
                if not tiles_close_to_player[tile_x .. "_" .. tile_y] then
                    add(available_tiles, { tile_x = tile_x, tile_y = tile_y })
                end
            end
        end

        local chosen_tile = rnd(available_tiles)
        if chosen_tile then
            memory_trigger = new_item({
                x = (chosen_tile.tile_x - 0.5) * u.tile_length,
                y = (chosen_tile.tile_y - 0.5) * u.tile_length,
                color = u.colors.orange,
            })
        end

        if not invulnerability_trigger and not (bg_color == bg_color_invulnerability) then
            del(available_tiles, chosen_tile)
            local next_chosen_tile = rnd(available_tiles)
            if next_chosen_tile then
                invulnerability_trigger = new_item({
                    x = (next_chosen_tile.tile_x - 0.5) * u.tile_length,
                    y = (next_chosen_tile.tile_y - 0.5) * u.tile_length,
                    color = u.colors.pink,
                })
            end
        end
    end

    local l = {}

    l.handle_collisions = function(p)
        if memory_trigger then
            if collisions.have_circles_collided(player, memory_trigger) then
                memory_trigger = nil
                bg_color = bg_color_normal
                p.on_memory_trigger()
                spawn_memory_trigger()
            end
        end
        if invulnerability_trigger then
            if collisions.have_circles_collided(player, invulnerability_trigger) then
                bg_color = bg_color_invulnerability
                p.on_invulnerability_trigger()
                invulnerability_trigger = nil
            end
        end
    end

    l.draw = function()
        rectfill(0, 0, u.screen_edge_length - 1, u.screen_edge_length - 1, bg_color)

        local tiles_close_to_player = get_tiles_close_to_player()
        if __debug__ then
            for tile_x = 1, u.screen_edge_tiles do
                for tile_y = 1, u.screen_edge_tiles do
                    line(
                        (tile_x - 1) * u.tile_length, (tile_y - 1) * u.tile_length,
                        (tile_x - 1) * u.tile_length, (tile_y - 1) * u.tile_length,
                        u.colors.violet_grey
                    )
                    if tiles_close_to_player[tile_x .. "_" .. tile_y] then
                        rectfill(
                            (tile_x - 1) * u.tile_length, (tile_y - 1) * u.tile_length,
                            tile_x * u.tile_length - 1, tile_y * u.tile_length - 1,
                            u.colors.purple
                        )
                    end
                end
            end
        end

        if memory_trigger then
            memory_trigger.draw()
        end
        if invulnerability_trigger then
            invulnerability_trigger.draw()
        end
    end

    spawn_memory_trigger()

    return l;
end