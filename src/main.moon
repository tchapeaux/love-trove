require("lib/lgm/lgm")
require("level")
require("wall")
require("player")
require("ai_player")
require("states/statestack")
require("states/gamestate")

export wScr, hScr
wScr = love.window.getWidth
hScr = love.window.getHeight

love.load = ->
    export stateStack = StateStack()
    stateStack\push(GameState(true, false, firstLevel))


love.update = (dt) ->
    curState = stateStack\peek()
    curState\update(dt)

love.draw = ->
    curState = stateStack\peek()
    curState\draw()

love.keypressed = (k) ->
    curState = stateStack\peek()
    curState\keypressed(k)
