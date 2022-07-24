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
        u = 55,
        r = 56,
        d = 57,
        l = 58,
    }

    local delay = 40
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
        palt(u.colors.black, false)
        palt(u.colors.dark_blue, true)
        if m.is_active then
            spr(
                sprite_for_direction[m.direction],
                m.x - m.r,
                u.topbar_h_px + m.y - m.r
            )
        end
        palt()
        if __debug__ then
            circfill(m.x, u.topbar_h_px + m.y, m.r, u.colors.salmon)
        end
    end

    return m;
end