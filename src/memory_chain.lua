-- memory_chain

function new_memory_chain()
    local memory_chain = {}

    memory_chain.last_memory_or_player = function(player)
        local last_memory = player
        while last_memory.memory do
            last_memory = last_memory.memory
        end
        return last_memory
    end

    memory_chain.for_each_memory_in_order = function(player, callback)
        local processed_memory = player
        while processed_memory.memory do
            callback(processed_memory.memory)
            processed_memory = processed_memory.memory
        end
    end

    return memory_chain;
end