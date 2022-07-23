-- main

--__debug__ = true

local game_state = "start"

local player = new_player({
    memory = nil,
})

local level = new_level({
    player = player,
})

local memory_chain = new_memory_chain()

local trail_particles = {}

local invulnerable = false

function add_memory()
    invulnerable = false
    local last_memory = memory_chain.last_memory_or_player(player)
    last_memory.memory = new_memory({ origin = last_memory })
end

function hide_memories()
    invulnerable = true
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
        on_memory_trigger = add_memory,
        on_invulnerability_trigger = hide_memories,
    })

    if u.boolean_changing_every_nth_second(1 / 20) then
        add(trail_particles, new_trail_particle({
            x = player.x,
            y = player.y,
            color = u.colors.brown,
            is_of_memory = false,
        }))
    end

    player.move()

    memory_chain.for_each_memory_in_order(player, function(memory)
        if u.boolean_changing_every_nth_second(1 / 20) then
            add(trail_particles, new_trail_particle({
                x = memory.x,
                y = memory.y,
                color = u.colors.purple,
                is_of_memory = true,
            }))
        end
        memory.follow_origin()
        if not invulnerable then
            if memory.is_active and collisions.have_circles_collided(memory, player) then
                extcmd("reset")
            end
        end
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
    cls()

    level.draw()
    for i = 1, #trail_particles do
        if not trail_particles[i].is_of_memory or not invulnerable then
            trail_particles[i].draw()
        end
    end

    player.draw()

    if not invulnerable then
        memory_chain.for_each_memory_in_order(player, function(memory)
            memory.draw()
        end)
    end

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
-- TODO: show 1 new memory trigger (coin?) on every item collect, instead of having a static amount of them from the very beginning
-- TODO: show score, increase it on every coin collect
-- TODO: rename memory triggers to coins
