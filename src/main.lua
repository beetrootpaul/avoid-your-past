u = new_utils()

local player = new_player({
    x = u.screen_edge_length * 1 / 4,
    y = u.screen_edge_length * 3 / 4,
    memory = nil,
})

local memory_chain = new_memory_chain()

local trail_particles = {}

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
    add(trail_particles, new_trail_particle({
        x = player.x,
        y = player.y,
        color = u.colors.brown
    }))
    player.move()
    memory_chain.for_each_memory_in_order(player, function(memory)
        add(trail_particles, new_trail_particle({
            x = memory.x,
            y = memory.y,
            color = u.colors.purple
        }))
        memory.follow_origin()
    end)
    for i = 1, #trail_particles do
        if trail_particles[i] then
            trail_particles[i].age()
            if trail_particles[i].ttl <= 0 then
                deli(trail_particles, i)
                trail_particles[i] = trail_particles[#trail_particles]
                trail_particles[#trail_particles] = nil
            end
        end
    end
end

function _draw()
    cls(u.colors.dark_grey)
    for i = 1, #trail_particles do
        trail_particles[i].draw()
    end
    player.draw()
    memory_chain.for_each_memory_in_order(player, function(memory)
        memory.draw()
    end)
end
