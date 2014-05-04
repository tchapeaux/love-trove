require("lib/lgm/lgm")
require("states/state")

export ^

class GameState extends State
    new: (isP1_AI, isP2_AI, @level) =>
        @font = love.graphics.newFont("res/font/roboto/RobotoCondensed-Regular.ttf", 15)
        @kPAUSE = false
        @useSound = true

        @bgm_main = love.audio.newSource("res/audio/bgm_main.ogg", "stream")
        @bgm_main\setVolume(0.5)

        @playerSet = LGM.EntitySet()
        p1Class = if isP1_AI then AI_Player else Player
        p1Name = if isP1_AI then "AI" else "P1"
        p2Class = if isP2_AI then AI_Player else Player
        p2Name = if isP2_AI then "AI" else "P2"

        @playerSet\add(p1Class @level.startingPosition[1][1].x,
            @level.startingPosition[1][1].y,
            @level.startingPosition[1][2].x,
            @level.startingPosition[1][2].y,
            colorP1, p1Name)
        @playerSet\add(p2Class @level.startingPosition[2][1].x,
            @level.startingPosition[2][1].y,
            @level.startingPosition[2][2].x,
            @level.startingPosition[2][2].y,
            colorP2, p2Name)
        @bgm_main\play()

    getAllWalls: =>
        wallSets = {}
        table.insert(wallSets, @level.wallSet)
        for player in @playerSet\iter()
            table.insert(wallSets, player.wallSet)
        return wallSets

    update: (dt) =>
        if not @kPAUSE
            for player in @playerSet\iter()
                allWalls = @getAllWalls()
                player\update(dt, allWalls)
            @level.wallSet\update(dt)

    draw: =>
        love.graphics.setFont(@font)
        for player in @playerSet\iter()
            player\draw()
            love.graphics.setColor(player.color)
            love.graphics.print(player.score, 50 + 30 * player.id , 10)

        for wall in @level.wallSet\iter()
            wall\draw()

        -- music icon ♪
        if @useSound
            love.graphics.setColor(255,255,255)
            love.graphics.printf("m to mute", 10, 10, wScr() - 10, "right")

    keypressed: (k) =>
        switch k
            when "up", "right","left", "down"
                @playerSet\find(1)\keypressed(k)
            when "w", "z"
                @playerSet\find(2)\keypressed("up")
            when "d"
                @playerSet\find(2)\keypressed("right")
            when "s"
                @playerSet\find(2)\keypressed("down")
            when "q", "a"
                @playerSet\find(2)\keypressed("left")
            when "p"
                @kPAUSE = not @kPAUSE
            when "m"
                @useSound = not @useSound
                curV = love.audio.getVolume()
                love.audio.setVolume(1.0 - curV)
            when "escape"
                @bgm_main\stop()
                stateStack\pop()
