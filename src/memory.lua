-- memory

function new_memory(params)
    local origin = params.origin

    local m = {
        x = origin.x,
        y = origin.y,
        r = origin.r,
        is_active = false,
    }

    local delay = 30
    local origin_state_buffer = {}
    local origin_state_buffer_index = 0

    m.follow_origin = function()
        origin_state_buffer[origin_state_buffer_index] = {
            x = origin.x,
            y = origin.y,
            r = origin.r,
        }

        local delayed_state = origin_state_buffer[(origin_state_buffer_index - delay) % (delay + 1)]
        if delayed_state then
            m.x = delayed_state.x
            m.y = delayed_state.y
            m.r = delayed_state.r
        end

        origin_state_buffer_index = (origin_state_buffer_index + 1) % (delay + 1)

        m.is_active = #origin_state_buffer >= delay
    end

    m.draw = function()
        local color = m.is_active and u.colors.pink or u.colors.violet_grey
        circfill(m.x, m.y, m.r, color)
    end

    return m;
end