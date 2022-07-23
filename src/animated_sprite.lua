function new_animated_sprite(params)
    local first_sprite = params.first_sprite
    local number_of_sprites = params.number_of_sprites
    local frames_per_sprite = params.frames_per_sprite

    local frame_counter = 0
    local loop_length_frames = frames_per_sprite * number_of_sprites

    local animated_sprite = {}

    animated_sprite.advance_1_frame = function()
        frame_counter = (frame_counter + 1) % loop_length_frames
    end

    animated_sprite.current_sprite = function()
        local sprite_index = flr(frame_counter / frames_per_sprite)
        return first_sprite + sprite_index
    end

    return animated_sprite
end