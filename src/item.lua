-- item

function new_item(params)
    local animated_sprite = params.animated_sprite
    local collision_circle_r = params.collision_circle_r

    local it = {
        tile_x = params.tile_x,
        tile_y = params.tile_y,
    }

    it.collision_circle = function()
        return {
            x = (it.tile_x - 1) * u.tile_length + u.tile_length / 2 - 0.5,
            y = (it.tile_y - 1) * u.tile_length + u.tile_length / 2 - 0.5,
            r = collision_circle_r,
        }
    end

    it.animate = function()
        animated_sprite.advance_1_frame()
    end

    it.draw = function()
        palt(u.colors.black, false)
        palt(u.colors.dark_blue, true)
        spr(
            animated_sprite.current_sprite(),
            (it.tile_x - 1) * u.tile_length,
            u.topbar_h_px + (it.tile_y - 1) * u.tile_length
        )
        palt()
    end

    return it;
end