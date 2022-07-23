-- trail_particle

function new_trail_particle(params)
    local x = params.x
    local y = params.y
    local color = params.color

    local max_ttl = 28
    local max_r = 2

    local to = {
        ttl = max_ttl,
        is_of_memory = params.is_of_memory,
    }

    to.age = function()
        if to.ttl > 0 then
            to.ttl = to.ttl - 1
        end
    end

    to.draw = function()
        local r = flr((to.ttl / max_ttl) * (max_r + 0.9))
        circfill(x, u.topbar_h_px + y, r, color)
    end

    return to;
end