-- -- -- -- -- -- -- --
-- gameplay/memories --
-- -- -- -- -- -- -- --

function new_memories(params)
    local player = params.player

    local memories_from_first_to_last = {}
    local trails = {}

    return {

        --

        add_memory = function()
            local memory = new_memory {
                origin = memories_from_first_to_last[#memories_from_first_to_last] or player
            }
            memories_from_first_to_last[#memories_from_first_to_last + 1] = memory
            add(trails, new_trail {
                origin = memory,
                color = u.colors.purple,
            })
        end,

        --

        move = function()
            for trail in all(trails) do
                trail.update()
            end
            for memory in all(memories_from_first_to_last) do
                memory.follow_origin()
            end
        end,

        --

        has_player_collided_with_memory = function()
            for memory in all(memories_from_first_to_last) do
                if memory.is_active() and collisions.have_circles_collided(
                    player.collision_circle(),
                    memory.collision_circle()
                ) then
                    return true
                end
            end
            return false
        end,

        --

        draw = function()
            for trail in all(trails) do
                trail.draw()
            end
            for memory in all(memories_from_first_to_last) do
                memory.draw()
            end
        end,

        --

    }
end