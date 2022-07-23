-- main

--__debug__ = true

local gs


function _init()
    gs = new_game_state_start()
end

function _update()
    gs = gs.update()
end

function _draw()
    cls()
    gs.draw()
end

-- TODO: VFXs
-- TODO: entry screen with a game title and author (Twitter handle, www)
-- TODO: polish arrows on start
-- TODO: fix memory first moments
-- TODO: bring back game restart on over

-- TODO: extract particles to a separate file
-- TODO: rename memory triggers to coins
-- TODO: rename invulnerable to negated vulnerable
-- TODO: clean up, refactor, access through methods only

-- TODO: better README: screenshots, explanation, keys
-- TODO: add itch URL to GitHub repo details
-- TODO: generate cart label image
