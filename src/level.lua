function new_level(params)
    local number_of_memory_triggers = params.number_of_memory_triggers

    local l = {
        memory_triggers = {}
    }

    for _ = 1, number_of_memory_triggers do
        add(l.memory_triggers, new_item({
            -- TODO: make sure items won't overlap and won't overflow outside viewport
            x = rnd(u.screen_edge_length),
            y = rnd(u.screen_edge_length),
            color = u.colors.pink,
        }))
    end

    l.handle_collisions = function(p)
        local collision_circle_x = p.collision_circle_x
        local collision_circle_y = p.collision_circle_y
        local collision_circle_r = p.collision_circle_r
        local on_memory_trigger = p.on_memory_trigger

        for memory_trigger in all(l.memory_triggers) do
            local is_colliding = memory_trigger.is_colliding_with({
                collision_circle_x = collision_circle_x,
                collision_circle_y = collision_circle_y,
                collision_circle_r = collision_circle_r,
            })
            if is_colliding then
                del(l.memory_triggers, memory_trigger)
                on_memory_trigger()
            end
        end
    end

    l.draw = function()
        for memory_trigger in all(l.memory_triggers) do
            memory_trigger.draw()
        end
    end

    return l;
end