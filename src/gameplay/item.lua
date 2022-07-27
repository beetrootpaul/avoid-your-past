-- -- -- -- -- -- --
-- gameplay/item  --
-- -- -- -- -- -- --

function new_item(params)
    local tile_x = params.tile_x
    local tile_y = params.tile_y
    local collision_circle_r = params.collision_circle_r
    local animated_sprite = params.animated_sprite

    return {

        --

        collision_circle = function()
            return {
                x = (tile_x - 1) * u.tile_px + u.tile_px / 2 - 0.5,
                y = (tile_y - 1) * u.tile_px + u.tile_px / 2 - 0.5,
                r = collision_circle_r,
            }
        end,

        --

        animate = function()
            animated_sprite.advance_1_frame()
        end,

        --

        draw = function()
            palt(u.colors.black, false)
            palt(u.colors.dark_blue, true)
            spr(
                animated_sprite.current_sprite(),
                (tile_x - 1) * u.tile_px,
                (tile_y - 1) * u.tile_px
            )
            palt()
        end,

        --

    }
end