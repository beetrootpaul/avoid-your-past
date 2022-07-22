function new_utils()
    local utils = {

        buttons = {
            -- left, right, up, down
            l = 0,
            r = 1,
            u = 2,
            d = 3,
            -- button O (Z), button X
            o = 4,
            x = 5,
        },

        colors = {
            black = 0,
            dark_blue = 1,
            purple = 2,
            dark_green = 3,
            brown = 4,
            dark_grey = 5,
            light_grey = 6,
            white = 7,
            red = 8,
            orange = 9,
            yellow = 10,
            lime = 11,
            blue = 12,
            violet_grey = 13,
            pink = 14,
            salmon = 15,
        },

        print_with_outline = function(text, x, y, text_color, outline_color)
            -- Docs on Control Codes: https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Control_Codes
            for control_code in all(split "\-f,\-h,\|f,\|h,\+ff,\+hh,\+fh,\+hf") do
                print(control_code .. text, x, y, outline_color)
            end
            print(text, x, y, text_color)
        end,

        screen_edge_length = 128,

        screen_edge_tiles = 16,

        text_height_px = 5,

        tile_length = 8,

        trim = function(text)
            local result = text
            while sub(result, 1, 1) == ' ' do
                result = sub(result, 2)
            end
            while sub(result, #result, #result) == ' ' do
                result = sub(result, 0, #result - 1)
            end
            return result
        end
    }

    utils.measure_text_width = function(text)
        local y_to_print_outside_screen = -utils.text_height_px
        return print(text, 0, y_to_print_outside_screen) - 1
    end

    return utils
end
