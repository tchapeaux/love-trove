require("lib/lgm/lgm")
require("wall")
require("player")
require("ai_player")

export wScr, hScr
wScr = love.window.getWidth
hScr = love.window.getHeight

kPAUSE = false

love.load = ->

    arenaOutSize = 40

    colorP1 = {227,138,23}
    colorP2 = {91,205,229}

    useSound = true

    bgm_main = love.audio.newSource("res/bgm_main.ogg", "stream")
    bgm_main\setVolume(0.5)
    sfx_turn = {}
    for i=1,10
        s = love.audio.newSource("res/sfx_turn.wav", "static")
        s\setVolume(0.5)
        s\setPitch(0.5 + 0.1 * i)
        table.insert(sfx_turn, s)

    wallSet\add(Wall arenaOutSize, arenaOutSize, wScr() - arenaOutSize,
        arenaOutSize,
        {255,255,255},
        -1)
    wallSet\add(Wall arenaOutSize,
        arenaOutSize,
        arenaOutSize,
        hScr() - arenaOutSize,
        {255,255,255},
        -1)
    wallSet\add(Wall wScr() - arenaOutSize,
        arenaOutSize,
        wScr() - arenaOutSize,
        hScr() - arenaOutSize,
        {255,255,255},
        -1)
    wallSet\add(Wall arenaOutSize,
        hScr() - arenaOutSize,
        wScr() - arenaOutSize,
        hScr() - arenaOutSize,
        {255,255,255},
        -1)

    playerSet\add(Player wScr() - (arenaOutSize + 10),
        hScr() - (arenaOutSize + 10),
        -1, 0,colorP1)
    playerSet\add(Player arenaOutSize + 10, arenaOutSize + 10, 1, 0, colorP2)

    playerSet\add(AI_Player wScr() / 2, hScr() / 2, 0, 1, {255, 105, 180})

    bgm_main\play()

    love.update = (dt) ->
        if not kPAUSE
            for wall in wallSet\iter()
                wall\update(dt)
                if (wall.time > wall.lifeTime) then
                    wallSet\removeID(wall.id)
            for player in playerSet\iter()
                player\update(dt)

    love.draw = ->
        for player in playerSet\iter()
            player\draw()
            love.graphics.setColor(player.color)
            love.graphics.print(player.score, 50 + 30 * player.id , 10)

        for wall in wallSet\iter()
            wall\draw()

        -- music icon ♪
        if useSound
            love.graphics.setColor(255,255,255)
            love.graphics.print("m to mute", 1, 1)

    love.keypressed = (k) ->
        switch k
            when "up", "right","left", "down"
                playerSet\find(1)\keypressed(k)
            when "w", "z"
                playerSet\find(2)\keypressed("up")
            when "d"
                playerSet\find(2)\keypressed("right")
            when "s"
                playerSet\find(2)\keypressed("down")
            when "q", "a"
                playerSet\find(2)\keypressed("left")

            when "p"
                kPAUSE = not kPAUSE

            when "m"
                useSound = not useSound
                curV = love.audio.getVolume()
                love.audio.setVolume(1.0 - curV)

            when "escape"
                love.event.push("quit")

    export playSfxTurn = ->
        i = -1
        while i == -1 or not sfx_turn[i]\isStopped()
            i = love.math.random(1, #sfx_turn)
        sfx_turn[i]\play()
