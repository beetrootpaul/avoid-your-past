-- item

function new_item(params)
    local color = params.color

    local it = {
        x = params.x,
        y = params.y,
        r = 2,
    }

    it.draw = function()
        circfill(it.x, it.y, it.r, color)
    end

    return it;
end