-- memory

function new_memory(params)
    local origin = params.origin

    local m = {
        x = origin.x,
        y = origin.y,
        r = origin.r,
        direction = origin.direction,
        is_active = false,
    }

    local sprite_for_direction = {
        u = 50,
        r = 51,
        d = 52,
        l = 53,
    }

    local delay = 30
    local origin_state_buffer = {}
    local origin_state_buffer_index = 0

    m.collision_circle = function()
        return {
            x = m.x,
            y = m.y,
            r = m.r,
        }
    end

    m.follow_origin = function()
        origin_state_buffer[origin_state_buffer_index] = {
            x = origin.x,
            y = origin.y,
            r = origin.r,
            direction = origin.direction,
        }

        local delayed_state = origin_state_buffer[(origin_state_buffer_index - delay) % (delay + 1)]
        if delayed_state then
            m.x = delayed_state.x
            m.y = delayed_state.y
            m.r = delayed_state.r
            m.direction = delayed_state.direction
        end

        origin_state_buffer_index = (origin_state_buffer_index + 1) % (delay + 1)

        m.is_active = #origin_state_buffer >= delay
    end

    m.draw = function()
        local color = m.is_active and u.colors.pink or u.colors.violet_grey
        circfill(m.x, m.y, m.r, color)
        palt(u.colors.black, false)
        palt(u.colors.dark_blue, true)
        spr(
            sprite_for_direction[m.direction],
            m.x - m.r,
            m.y - m.r
        )
        palt()
    end

    return m;
end