-- -- -- -- -- -- -- --
-- gameplay/memory   --
-- -- -- -- -- -- -- --

function new_memory(params)
    local origin = params.origin

    local x = origin.xc()
    local y = origin.yc()
    local r = origin.r()

    local direction = origin.direction
    local sprite_for_direction = {
        u = 55,
        r = 56,
        d = 57,
        l = 58,
    }

    local origin_state_delay = 40
    local origin_state_buffer = {}
    local origin_state_buffer_index = 1

    local function is_active()
        return #origin_state_buffer > origin_state_delay
    end

    return {

        --

        xc = function()
            return x
        end,
        yc = function()
            return y
        end,
        r = function()
            return r
        end,
        direction = function()
            return direction
        end,

        --

        collision_circle = function()
            return { x = x, y = y, r = r }
        end,

        --

        is_active = function()
            return is_active()
        end,

        --

        follow_origin = function()
            origin_state_buffer[origin_state_buffer_index] = {
                x = origin.xc(),
                y = origin.yc(),
                r = origin.r(),
                direction = origin.direction(),
            }

            local offset_for_1_indexed_table = 1
            local delayed_state_index = (origin_state_buffer_index - origin_state_delay - offset_for_1_indexed_table) %
                (origin_state_delay + 1) +
                offset_for_1_indexed_table
            local delayed_state = origin_state_buffer[delayed_state_index]
            if delayed_state then
                x = delayed_state.x
                y = delayed_state.y
                r = delayed_state.r
                direction = delayed_state.direction
            end
            origin_state_buffer_index = (origin_state_buffer_index + 1 - offset_for_1_indexed_table)
                % (origin_state_delay + 1)
                + offset_for_1_indexed_table
        end,

        --

        draw = function()
            palt(u.colors.black, false)
            palt(u.colors.dark_blue, true)
            if is_active() then
                spr(
                    sprite_for_direction[direction],
                    x - r,
                    y - r
                )
            end
            palt()
            if __debug__ then
                circfill(x, y, r, is_active() and u.colors.salmon or u.colors.violet_grey)
            end
        end,

        --

    }
end