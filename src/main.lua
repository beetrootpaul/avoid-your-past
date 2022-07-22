u = new_utils()

local player = new_player({
    x = u.screen_edge_length * 1/4,
    y = u.screen_edge_length * 3/4,
})

function _init()
end

function _update60()
    if btnp(u.buttons.l) then
        player.direct_left()
    end
    if btnp(u.buttons.r) then
        player.direct_right()
    end
    if btnp(u.buttons.u) then
        player.direct_up()
    end
    if btnp(u.buttons.d) then
        player.direct_down()
    end
    player.move_1_frame()
end

function _draw()
    cls(u.colors.dark_grey)
    player.draw()
end
