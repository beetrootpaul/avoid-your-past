u = new_utils()

function _init()
end

function _update60()
end

function _draw()
    cls(u.colors.dark_grey)
    local t = "test"
    local w = u.measure_text_width(t)
    print(t,
        u.screen_edge_length / 2 - w / 2,
        u.screen_edge_length / 2 - u.text_height_px / 2,
        u.colors.orange)
end
