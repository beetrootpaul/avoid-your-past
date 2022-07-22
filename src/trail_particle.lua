function new_trail_particle(params)
    local x = params.x
    local y = params.y
    local color = params.color

    local max_ttl = 30

    local to = {
        ttl = max_ttl
    }

    to.age = function()
        if to.ttl > 0 then
            to.ttl = to.ttl - 1
        end
    end

    to.draw = function()
        local r = (to.ttl / max_ttl) * 3
        circfill(x, y, r, color)
    end

    return to;
end