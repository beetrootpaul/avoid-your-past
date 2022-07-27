-- -- -- -- -- -- --
-- gameplay/level --
-- -- -- -- -- -- --

function new_level(params)
    local mode = params.mode
    local player = params.player

    local coin
    local droplet_no_coins
    local droplet_no_memories

    local function get_tiles_close_to_player()
        local left_tile_x = flr(player.x1() / u.tile_px) + 1
        local right_tile_x = flr(player.x2() / u.tile_px) + 1
        local top_tile_y = flr(player.y1() / u.tile_px) + 1
        local bottom_tile_y = flr(player.y2() / u.tile_px) + 1

        local close_tiles = {}
        local margin_tiles = 3
        for tile_x = left_tile_x - margin_tiles, right_tile_x + margin_tiles do
            for tile_y = top_tile_y - margin_tiles, bottom_tile_y + margin_tiles do
                close_tiles[tile_x .. "_" .. tile_y] = true
            end
        end
        return close_tiles
    end

    return {

        --

        spawn_items = function()
            local tiles_close_to_player = get_tiles_close_to_player()
            local available_tiles = {}
            local margin_tiles = 1
            for tile_x = 1 + margin_tiles, a.game_area_w_tiles - margin_tiles do
                for tile_y = 1 + margin_tiles, a.game_area_h_tiles - margin_tiles do
                    if not tiles_close_to_player[tile_x .. "_" .. tile_y] then
                        add(available_tiles, { tile_x = tile_x, tile_y = tile_y })
                    end
                end
            end

            local coin_tile = rnd(available_tiles)
            if coin_tile then
                coin = new_item {
                    tile_x = coin_tile.tile_x,
                    tile_y = coin_tile.tile_y,
                    collision_circle_r = 2.5,
                    animated_sprite = new_animated_sprite {
                        first_sprite = 16,
                        number_of_sprites = 16,
                        frames_per_sprite = 2,
                    }
                }
            end

            if not droplet_no_coins and not droplet_no_memories and not mode.is_no_coins() and not mode.is_no_memories() then
                del(available_tiles, coin_tile)
                local droplet_tile = rnd(available_tiles)
                if droplet_tile then
                    local probability = rnd(1)
                    if __debug__ then
                        printh(probability)
                    end
                    if probability < 0.3 then
                        droplet_no_coins = new_item {
                            tile_x = droplet_tile.tile_x,
                            tile_y = droplet_tile.tile_y,
                            collision_circle_r = 3.5,
                            animated_sprite = new_animated_sprite {
                                first_sprite = 32,
                                number_of_sprites = 1,
                                frames_per_sprite = 1,
                            }
                        }
                    elseif probability > 0.7 then
                        droplet_no_memories = new_item {
                            tile_x = droplet_tile.tile_x,
                            tile_y = droplet_tile.tile_y,
                            collision_circle_r = 3.5,
                            animated_sprite = new_animated_sprite {
                                first_sprite = 48,
                                number_of_sprites = 1,
                                frames_per_sprite = 1,
                            }
                        }
                    end
                end
            end
        end,

        --

        remove_coin = function()
            coin = nil
        end,

        --

        remove_droplet_no_coins = function()
            droplet_no_coins = nil
        end,
        remove_droplet_no_memories = function()
            droplet_no_memories = nil
        end,

        --

        check_collisions = function(callbacks)
            if coin then
                if collisions.have_circles_collided(
                    player.collision_circle(),
                    coin.collision_circle()
                ) then
                    callbacks.on_coin()
                end
            end
            if droplet_no_coins then
                if collisions.have_circles_collided(
                    player.collision_circle(),
                    droplet_no_coins.collision_circle()
                ) then
                    callbacks.on_droplet_no_coins()
                end
            end
            if droplet_no_memories then
                if collisions.have_circles_collided(
                    player.collision_circle(),
                    droplet_no_memories.collision_circle()
                ) then
                    callbacks.on_droplet_no_memories()
                end
            end
        end,

        --

        animate = function()
            if coin then
                coin.animate()
            end
            if droplet_no_coins then
                droplet_no_coins.animate()
            end
            if droplet_no_memories then
                droplet_no_memories.animate()
            end
        end,

        --

        draw_bg = function()
            fillp(mode.bg_pattern())
            rectfill(
                0,
                0,
                a.game_area_w - 1,
                a.game_area_h - 1,
                mode.bg_color()
            )
            fillp()

            if __debug__ then
                local tiles_close_to_player = get_tiles_close_to_player()
                for tile_x = 1, a.game_area_w_tiles do
                    for tile_y = 1, a.game_area_h_tiles do
                        line(
                            (tile_x - 1) * u.tile_px, (tile_y - 1) * u.tile_px,
                            (tile_x - 1) * u.tile_px, (tile_y - 1) * u.tile_px,
                            u.colors.violet_grey
                        )
                        if tiles_close_to_player[tile_x .. "_" .. tile_y] then
                            rectfill(
                                (tile_x - 1) * u.tile_px, (tile_y - 1) * u.tile_px,
                                tile_x * u.tile_px - 1, tile_y * u.tile_px - 1,
                                u.colors.purple
                            )
                        end
                    end
                end
            end
        end,

        --

        draw_items = function()
            if not mode.is_no_coins() then
                coin.draw()
            end
            if droplet_no_coins then
                droplet_no_coins.draw()
            end
            if droplet_no_memories then
                droplet_no_memories.draw()
            end
        end,

        --

    }
end