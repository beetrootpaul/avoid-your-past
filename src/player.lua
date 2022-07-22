function new_player(params)
    local r = 4
    local default_speed = 2
    local dx = default_speed
    local dy = 0

    local player = {
        x = params.x,
        y = params.y,
    }

    player.direct_left = function()
        dx, dy = -default_speed, 0
    end
    player.direct_right = function()
        dx, dy = default_speed, 0
    end
    player.direct_up = function()
        dx, dy = 0, -default_speed
    end
    player.direct_down = function()
        dx, dy = 0, default_speed
    end

    player.move_1_frame = function()
        player.x = player.x + dx
        player.y = player.y + dy
        player.x = mid(r, player.x, u.screen_edge_length - r - 1)
        player.y = mid(r, player.y, u.screen_edge_length - r - 1)
    end

    player.draw = function()
        circfill(player.x, player.y, r, u.colors.yellow)
    end

    return player;
end