function new_item(params)
    local x = params.x
    local y = params.y
    local color = params.color

    local it = {}

    local r = 2

    it.is_colliding_with = function(p)
        local collision_circle_x = p.collision_circle_x
        local collision_circle_y = p.collision_circle_y
        local collision_circle_r = p.collision_circle_r

        local distance_x = abs(collision_circle_x - x)
        local distance_y = abs(collision_circle_y - y)
        local distance = sqrt(distance_x*distance_x + distance_y*distance_y)

        return distance < collision_circle_r + r
    end

    it.draw = function()
        circfill(x, y, r, color)
    end

    return it;
end