-- game_state_gameplay

function new_game_state_gameplay(params)
    local topbar = new_topbar()
    local player = params.player
    local level = params.level

    local memory_chain = new_memory_chain()

    local trail_particles = {}
    local vulnerable = true
    local can_collect_coins = true

    local score = 0
    local special_phase

    local particle_counter_max = 4
    local particle_counter = particle_counter_max

    function on_coin_taken()
        sfx(0)
        score = score + 10
        if vulnerable then
            local last_memory = memory_chain.last_memory_or_player(player)
            last_memory.memory = new_memory({ origin = last_memory })
        end
    end

    function hide_memories()
        sfx(2)
        score = score + 1
        vulnerable = false
        special_phase = {
            label = "invulnerable",
            color = u.colors.pink,
            ttl_max = 150,
            ttl = 150,
        }
    end

    function hide_coins()
        sfx(1)
        score = score + 3
        can_collect_coins = false
        special_phase = {
            label = "cannot collect coins",
            color = u.colors.orange,
            ttl_max = 90,
            ttl = 90,
        }
    end

    local gs = {}

    gs.update = function()
        if btnp(u.buttons.l) then
            player.direct_left()
        elseif btnp(u.buttons.r) then
            player.direct_right()
        elseif btnp(u.buttons.u) then
            player.direct_up()
        elseif btnp(u.buttons.d) then
            player.direct_down()
        end

        if special_phase then
            level.set_bg_color(special_phase.color)
            local transition_speed = 1
            local ttl_distance_from_start_end = min(special_phase.ttl, special_phase.ttl_max - special_phase.ttl)
            if ttl_distance_from_start_end < transition_speed then
                level.set_bg_pattern(1 + 2 + 4 + 8 + 16 + 32 + 128 + 256 + 512 + 1024 + 2048 + 4096 + 8192 + 16384 + 32768)
            elseif ttl_distance_from_start_end < 2 * transition_speed then
                level.set_bg_pattern(1 + 2 + 4 + 8 + 32 + 128 + 256 + 512 + 1024 + 2048 + 8192 + 32768)
            elseif ttl_distance_from_start_end < 3 * transition_speed then
                level.set_bg_pattern(1 + 4 + 32 + 128 + 256 + 1024 + 8192 + 32768)
            elseif ttl_distance_from_start_end < 4 * transition_speed then
                level.set_bg_pattern(1 + 4 + 256 + 1024)
            elseif ttl_distance_from_start_end < 5 * transition_speed then
                level.set_bg_pattern(1)
            else
                level.set_bg_pattern(nil)
            end
            if special_phase.ttl <= 0 then
                special_phase = nil
                vulnerable = true
                can_collect_coins = true
                level.reset_bg()
                level.set_bg_pattern(nil)
            else
                special_phase.ttl = special_phase.ttl - 1
            end
        else
            level.reset_bg()
        end

        level.handle_collisions({
            can_collect_coins = can_collect_coins,
            on_memory_trigger = on_coin_taken,
            on_invulnerability_trigger = hide_memories,
            on_coin_hide_trigger = hide_coins,
        })

        level.animate()

        if particle_counter == 0 then
            add(trail_particles, new_trail_particle({
                x = player.x,
                y = player.y,
                color = u.colors.dark_green,
                is_of_memory = false,
            }))
        end
        player.move()

        local has_collided_with_memory = false
        memory_chain.for_each_memory_in_order(player, function(memory)
            if particle_counter == 0 then
                add(trail_particles, new_trail_particle({
                    x = memory.x,
                    y = memory.y,
                    color = u.colors.purple,
                    is_of_memory = true,
                }))
            end
            memory.follow_origin()
            if vulnerable then
                if memory.is_active and collisions.have_circles_collided(
                    memory.collision_circle(),
                    player.collision_circle()
                ) then
                    has_collided_with_memory = true
                end
            end
        end)

        particle_counter = (particle_counter + 1) % particle_counter_max

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

        if has_collided_with_memory then
            return new_game_state_over({
                player = player,
                level = level,
                score = score,
            })
        end
        return gs
    end

    gs.draw = function()
        level.draw_bg()

        for i = 1, #trail_particles do
            if not trail_particles[i].is_of_memory or vulnerable then
                trail_particles[i].draw()
            end
        end

        level.draw_items({
            can_collect_coins = can_collect_coins,
        })

        player.draw()

        if vulnerable then
            memory_chain.for_each_memory_in_order(player, function(memory)
                memory.draw()
            end)
        end

        topbar.draw({
            score = score,
            special_phase = special_phase,
        })
    end

    return gs
end