-- player

function new_player()
    local p = {
        x = u.screen_edge_length / 2,
        y = u.screen_edge_length / 2,
        r = 4,
    }

    local default_speed = 2
    local dx = default_speed
    local dy = 0

    p.direct_left = function()
        dx, dy = -default_speed, 0
    end
    p.direct_right = function()
        dx, dy = default_speed, 0
    end
    p.direct_up = function()
        dx, dy = 0, -default_speed
    end
    p.direct_down = function()
        dx, dy = 0, default_speed
    end

    p.move = function()
        p.x = p.x + dx
        p.y = p.y + dy
        p.x = mid(p.r, p.x, u.screen_edge_length - p.r - 1)
        p.y = mid(p.r, p.y, u.screen_edge_length - p.r - 1)
    end

    p.draw = function()
        circfill(p.x, p.y, p.r, u.colors.yellow)
    end

    return p;
end