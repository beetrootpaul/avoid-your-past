u = new_utils()

local player = new_player({
    x = u.screen_edge_length * 1 / 4,
    y = u.screen_edge_length * 3 / 4,
    memory = nil,
})

local memory_chain = new_memory_chain()

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
    if btnp(u.buttons.x) then
        local last_memory = memory_chain.last_memory_or_player(player)
        last_memory.memory = new_memory({ origin = last_memory })
    end
    player.move()
    memory_chain.for_each_memory_in_order(player, function(memory)
        memory.follow_origin()
    end)
end

function _draw()
    cls(u.colors.dark_grey)
    player.draw()
    memory_chain.for_each_memory_in_order(player, function(memory)
        memory.draw()
    end)
end
