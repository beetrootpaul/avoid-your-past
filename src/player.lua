-- player

function new_player()
    local p = {
        x = u.screen_edge_length / 2,
        y = u.screen_edge_length / 2,
        r = 3.5,
    }

    local default_speed = 3
    local dx = default_speed
    local dy = 0
    p.direction = "r"
    local sprite_for_direction = {
        u = 34,
        r = 35,
        d = 36,
        l = 37,
    }

    p.direct_left = function()
        dx, dy = -default_speed, 0
        p.direction = "l"
    end
    p.direct_right = function()
        dx, dy = default_speed, 0
        p.direction = "r"
    end
    p.direct_up = function()
        dx, dy = 0, -default_speed
        p.direction = "u"
    end
    p.direct_down = function()
        dx, dy = 0, default_speed
        p.direction = "d"
    end

    p.collision_circle = function()
        return {
            x = p.x,
            y = p.y,
            r = p.r,
        }
    end

    p.move = function()
        p.x = p.x + dx
        p.y = p.y + dy
        p.x = mid(p.r, p.x, u.screen_edge_length - p.r - 1)
        p.y = mid(p.r, p.y, u.screen_edge_length - p.r - 1)
    end

    p.draw = function()
        palt(u.colors.black, false)
        palt(u.colors.dark_blue, true)
        spr(
            sprite_for_direction[p.direction],
            p.x - p.r,
            p.y - p.r
        )
        palt()
    end

    return p;
end