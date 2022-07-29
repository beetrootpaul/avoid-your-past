-- -- -- -- -- -- --
-- gameplay/score --
-- -- -- -- -- -- --

function new_score()
    local value = 0

    return {

        --

        value = function()
            return value
        end,

        --

        add = function(points)
            value = value + points
        end,

        --

    }
end