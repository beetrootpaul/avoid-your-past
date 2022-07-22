u = new_utils()

local game_state = "start"

local player = new_player({
    memory = nil,
})

local level = new_level({
    number_of_memory_triggers = 5
})

local memory_chain = new_memory_chain()

local trail_particles = {}

function add_memory()
    local last_memory = memory_chain.last_memory_or_player(player)
    last_memory.memory = new_memory({ origin = last_memory })
end

function _init()
end

function _update()
    if game_state == "start" then
        if btnp(u.buttons.l) then
            player.direct_left()
            game_state = "gameplay"
        elseif btnp(u.buttons.r) then
            player.direct_right()
            game_state = "gameplay"
        elseif btnp(u.buttons.u) then
            player.direct_up()
            game_state = "gameplay"
        elseif btnp(u.buttons.d) then
            player.direct_down()
            game_state = "gameplay"
        end
        return
    end

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
    level.handle_collisions({
        collision_circle_x = player.x,
        collision_circle_y = player.y,
        collision_circle_r = player.r,
        on_memory_trigger = add_memory
    })
    if u.boolean_changing_every_nth_second(1/20) then
        add(trail_particles, new_trail_particle({
            x = player.x,
            y = player.y,
            color = u.colors.brown
        }))
    end
    player.move()
    memory_chain.for_each_memory_in_order(player, function(memory)
        if u.boolean_changing_every_nth_second(1/20) then
            add(trail_particles, new_trail_particle({
                x = memory.x,
                y = memory.y,
                color = u.colors.purple
            }))
        end
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
    level.draw()
    for i = 1, #trail_particles do
        trail_particles[i].draw()
    end
    player.draw()
    memory_chain.for_each_memory_in_order(player, function(memory)
        memory.draw()
    end)

    if game_state == "start" then
        local margin = 3
        local time_dependent_boolean = u.boolean_changing_every_nth_second(0.5)
        local glyph_color = time_dependent_boolean and u.colors.light_grey or u.colors.violet_grey
        u.print_with_outline("⬅️", player.x - player.r - margin - 8, player.y - 2, glyph_color, u.colors.purple)
        u.print_with_outline("➡️", player.x + player.r + margin + 2, player.y - 2, glyph_color, u.colors.purple)
        u.print_with_outline("⬆️", player.x - 3, player.y - player.r - margin - 6, glyph_color, u.colors.purple)
        u.print_with_outline("⬇️", player.x - 3, player.y + player.r + margin + 2, glyph_color, u.colors.purple)
    end
end

-- TODO: extract some noise out of main.lua
-- TODO: SFXs
-- TODO: VFXs
-- TODO: color changer, memories not harmful nor visible in same color
-- TODO: keys to collect to open level's exit
-- TODO: better README: screenshots, explanation, keys
-- TODO: entry screen with a game title and author (Twitter handle, www)
