-- level

function new_level(params)
    local player = params.player

    local memory_trigger
    local invulnerability_trigger
    local coin_hide_trigger

    local bg_color_normal = u.colors.dark_blue
    local bg_color_invulnerability = u.colors.pink
    local bg_color_coin_hidden = u.colors.orange
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
                tile_x = chosen_tile.tile_x,
                tile_y = chosen_tile.tile_y,
                collision_circle_r = 2.5,
                animated_sprite = new_animated_sprite({
                    first_sprite = 16,
                    number_of_sprites = 16,
                    frames_per_sprite = 2,
                })
            })
        end

        if not invulnerability_trigger and not coin_hide_trigger and not (bg_color == bg_color_invulnerability) and not (bg_color == bg_color_coin_hidden) then
            del(available_tiles, chosen_tile)
            local next_chosen_tile = rnd(available_tiles)
            if next_chosen_tile then
                local probability = rnd(1)
                if probability < 0.3 then
                    invulnerability_trigger = new_item({
                        tile_x = next_chosen_tile.tile_x,
                        tile_y = next_chosen_tile.tile_y,
                        collision_circle_r = 3.5,
                        animated_sprite = new_animated_sprite({
                            first_sprite = 48,
                            number_of_sprites = 1,
                            frames_per_sprite = 1,
                        })
                    })
                end
                if probability > 0.7 then
                    coin_hide_trigger = new_item({
                        tile_x = next_chosen_tile.tile_x,
                        tile_y = next_chosen_tile.tile_y,
                        collision_circle_r = 3.5,
                        animated_sprite = new_animated_sprite({
                            first_sprite = 32,
                            number_of_sprites = 1,
                            frames_per_sprite = 1,
                        })
                    })
                end
            end
        end
    end

    local l = {}

    l.animate = function()
        if memory_trigger then
            memory_trigger.animate()
        end
        if invulnerability_trigger then
            invulnerability_trigger.animate()
        end
        if coin_hide_trigger then
            coin_hide_trigger.animate()
        end
    end

    l.handle_collisions = function(p)
        if p.can_collect_coins and memory_trigger then
            if collisions.have_circles_collided(
                player.collision_circle(),
                memory_trigger.collision_circle()
            ) then
                memory_trigger = nil
                p.on_memory_trigger()
                spawn_memory_trigger()
            end
        end
        if invulnerability_trigger then
            if collisions.have_circles_collided(
                player.collision_circle(),
                invulnerability_trigger.collision_circle()
            ) then
                bg_color = bg_color_invulnerability
                p.on_invulnerability_trigger()
                invulnerability_trigger = nil
            end
        end
        if coin_hide_trigger then
            if collisions.have_circles_collided(
                player.collision_circle(),
                coin_hide_trigger.collision_circle()
            ) then
                bg_color = bg_color_coin_hidden
                p.on_coin_hide_trigger()
                coin_hide_trigger = nil
            end
        end
    end

    l.reset_bg = function()
        bg_color = bg_color_normal
    end

    l.draw = function(params)
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

        if memory_trigger and params.can_collect_coins then
            memory_trigger.draw()
        end
        if invulnerability_trigger then
            invulnerability_trigger.draw()
        end
        if coin_hide_trigger then
            coin_hide_trigger.draw()
        end
    end

    spawn_memory_trigger()

    return l;
end