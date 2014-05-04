require("lib/lgm/lgm")
require("level")
require("wall")
require("player")
require("ai_player")
require("states/statestack")
require("states/gamestate")
require("states/menustate")

export wScr, hScr
wScr = love.window.getWidth
hScr = love.window.getHeight

export colorP1 = {227,138,23}
export colorP2 = {91,205,229}

love.load = ->
    export stateStack = StateStack()
    stateStack\push(MenuState())
    -- stateStack\push(GameState(true, false, firstLevel))


love.update = (dt) ->
    curState = stateStack\peek()
    curState\update(dt)

love.draw = ->
    curState = stateStack\peek()
    curState\draw()

love.keypressed = (k) ->
        curState = stateStack\peek()
        curState\keypressed(k)
