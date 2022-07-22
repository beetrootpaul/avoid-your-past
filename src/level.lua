-- level

function new_level(params)
    local number_of_memory_triggers = params.number_of_memory_triggers

    local l = {}

    -- init empty level
    local items = {}
    for tile_x = 1, u.screen_edge_tiles do
        add(items, {})
        for tile_y = 1, u.screen_edge_tiles do
            add(items[tile_x], nil)
        end
    end

    -- place items randomly
    local available_tiles = {}
    for tile_x = 1, u.screen_edge_tiles do
        for tile_y = 1, u.screen_edge_tiles do
            -- don't make center tiles available, because a player will start there
            if tile_x < u.screen_edge_tiles / 2 - 2 or
                tile_x > u.screen_edge_tiles / 2 + 3 or
                tile_y < u.screen_edge_tiles / 2 - 2 or
                tile_y > u.screen_edge_tiles / 2 + 3 then
                add(available_tiles, {
                    tile_x = tile_x,
                    tile_y = tile_y,
                })
            end
        end
    end
    assert(number_of_memory_triggers <= #available_tiles)
    for _ = 1, number_of_memory_triggers do
        local chosen_tile = rnd(available_tiles)
        items[chosen_tile.tile_x][chosen_tile.tile_y] = new_item({
            x = (chosen_tile.tile_x - 0.5) * u.tile_length,
            y = (chosen_tile.tile_y - 0.5) * u.tile_length,
            color = u.colors.pink,
        })
        del(available_tiles, chosen_tile)
    end

    l.handle_collisions = function(p)
        local collision_circle_x = p.collision_circle_x
        local collision_circle_y = p.collision_circle_y
        local collision_circle_r = p.collision_circle_r
        local on_memory_trigger = p.on_memory_trigger

        for tile_x = 1, u.screen_edge_tiles do
            for tile_y = 1, u.screen_edge_tiles do
                local item = items[tile_x][tile_y]
                if item then
                    local collided = collisions.have_circles_collided(
                        { x = collision_circle_x, y = collision_circle_y, r = collision_circle_r },
                        item
                    )
                    if collided then
                        on_memory_trigger()
                        items[tile_x][tile_y] = nil
                    end
                end
            end
        end
    end

    l.draw = function()
        for tile_x = 1, u.screen_edge_tiles do
            for tile_y = 1, u.screen_edge_tiles do
                local item = items[tile_x][tile_y]
                if item then
                    item.draw()
                end
            end
        end
    end

    return l;
end