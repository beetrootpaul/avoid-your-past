-- -- -- -- -- -- -- --
-- gameplay/particle --
-- -- -- -- -- -- -- --

function new_particle(params)
    local x = params.x
    local y = params.y
    local color = params.color

    local r_max = 2
    local ttl_max = 28
    local ttl = ttl_max

    return {

        --

        age = function()
            ttl = max(0, ttl - 1)
        end,

        --

        should_disappear = function()
            return ttl <= 0
        end,

        --

        draw = function()
            local r = flr((ttl / ttl_max) * (r_max + 0.9))
            circfill(x, y, r, color)
        end,

        --

    }
end