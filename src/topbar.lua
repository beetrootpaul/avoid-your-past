-- topbar

function new_topbar()
    local tb = {}

    tb.draw = function(p)
        rectfill(
            0, 0,
            u.screen_edge_px - 1, u.topbar_h_px - 1,
            u.colors.black
        )

        local text_y = 4

        if p.special_phase then
            local progress_w = u.measure_text_width(p.special_phase.label)
            local progress_remaining_w = (p.special_phase.ttl / p.special_phase.ttl_max) * progress_w
            local progress_x = u.screen_edge_px - progress_w - 1
            local progress_y = text_y + u.text_height_px + 2
            local progress_h = 1
            print(
                p.special_phase.label,
                progress_x,
                text_y,
                u.colors.light_grey
            )
            if progress_remaining_w > 0 then
                line(
                    progress_x + progress_w - progress_remaining_w,
                    progress_y,
                    progress_x + progress_w - 1,
                    progress_y + progress_h - 1,
                    p.special_phase.color
                )
            end
        end

        print(
            "score " .. tostr(p.score),
            1,
            text_y,
            u.colors.light_grey
        )
    end

    return tb
end
