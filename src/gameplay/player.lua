-- -- -- -- -- -- -- --
-- gameplay/player   --
-- -- -- -- -- -- -- --

function new_player()
    local x = a.game_area_w / 2
    local y = a.game_area_h / 2
    local r = 3

    local speed = 2
    local dx = speed
    local dy = 0

    local direction = "r"
    local sprite_for_direction = {
        u = 39,
        r = 40,
        d = 41,
        l = 42,
    }

    return {

        --

        x1 = function()
            return x - r
        end,
        xc = function()
            return x
        end,
        x2 = function()
            return x + r
        end,
        y1 = function()
            return y - r
        end,
        yc = function()
            return y
        end,
        y2 = function()
            return y + r
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

        direct_left = function()
            dx, dy = -speed, 0
            direction = "l"
        end,
        direct_right = function()
            dx, dy = speed, 0
            direction = "r"
        end,
        direct_up = function()
            dx, dy = 0, -speed
            direction = "u"
        end,
        direct_down = function()
            dx, dy = 0, speed
            direction = "d"
        end,

        --

        move = function()
            x = x + dx
            y = y + dy
            x = mid(r, x, a.game_area_w - r - 1)
            y = mid(r, y, a.game_area_h - r - 1)
        end,

        --

        draw = function()
            palt(u.colors.black, false)
            palt(u.colors.dark_blue, true)
            spr(
                sprite_for_direction[direction],
                x - r,
                y - r
            )
            palt()
            if __debug__ then
                circfill(x, y, r, u.colors.red)
            end
        end,

        --

    }
end