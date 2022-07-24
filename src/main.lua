-- main

--__debug__ = true

local gs


function _init()
    gs = new_game_state_splash()
end

function _update()
    gs = gs.update()
end

function _draw()
    cls()
    gs.draw()
end

-- TODO: extract particles to a separate file
-- TODO: extract special state to a separate file
-- TODO: rename memory triggers to coins
-- TODO: rename invulnerable to negated vulnerable
-- TODO: clean up, refactor, access through methods only

-- TODO: better README: screenshots, explanation, keys
-- TODO: add itch URL to GitHub repo details
