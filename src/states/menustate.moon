export ^

class MenuState extends State
    new: =>
        @isPlayer_AI = {false, true}
        @titleFont = love.graphics.newFont("res/font/moonhouse.ttf", 150)
        @textFont = love.graphics.newFont("res/font/REZ.ttf", 25)
        @playerSelected = 1
        @bgm = love.audio.newSource("res/audio/bgm_menu.ogg", "stream")
        @bgm\play()
        @backdrop_x = 10
        @backdrop_y = 10
        @front_x_off = 0
        @front_y_off = 0
        @timer = 0

    draw: =>
        -- logo
        titleOffset = hScr() / 8
        love.graphics.setFont(@titleFont)
        love.graphics.setColor(colorP1)
        love.graphics.printf("TRÖVE", @backdrop_x, titleOffset + @backdrop_y, wScr(), "center")
        love.graphics.setColor(colorP2)
        love.graphics.printf("TRÖVE", @front_x_off, titleOffset + @front_y_off, wScr(), "center")
        love.graphics.setFont(@textFont)
        love.graphics.setColor(colorP2)
        love.graphics.printf("ALTOM PRESENTS", @front_x_off, titleOffset + @front_y_off, wScr() / 2, "center")
        love.graphics.setColor(colorP1)
        love.graphics.printf("a two players racing game", wScr() / 2 + @front_x_off, titleOffset + 140 + @front_y_off, wScr() / 2, "center")

        -- selectors
        playersSelectorOffset = 5 * hScr() / 8
        p1Text = if @isPlayer_AI[1] then "AI" else "P1"
        p2Text = if @isPlayer_AI[2] then "AI" else "P2"
        if (@playerSelected == 1)
            love.graphics.setColor(colorP1)
            love.graphics.setFont(@textFont)
            love.graphics.printf("Orange", 0, playersSelectorOffset, wScr() / 2, "center")
        love.graphics.setFont(@titleFont)
        love.graphics.printf(p1Text, 0, playersSelectorOffset + 30, wScr() / 2, "center")
        if not @isPlayer_AI[1]
            love.graphics.setFont(@textFont)
            love.graphics.printf("Movements arrows", 0, playersSelectorOffset + 180, wScr() / 2, "center")
        love.graphics.setColor(colorP2)
        if @playerSelected == 2
            love.graphics.setFont(@textFont)
            love.graphics.printf("Blue", wScr() / 2, playersSelectorOffset, wScr() / 2, "center")
        love.graphics.setFont(@titleFont)
        love.graphics.printf(p2Text, wScr() / 2, playersSelectorOffset + 30, wScr() / 2, "center")
        if not @isPlayer_AI[2]
            love.graphics.setFont(@textFont)
            love.graphics.printf("ZSQD or WSAD", wScr() / 2, playersSelectorOffset + 180, wScr() / 2, "center")


    update: (dt) =>
        if @bgm\isStopped()
            @bgm\play()

        @timer += dt
        -- @front_x_off = 2 * love.math.random()
        -- @front_y_off = 2 * love.math.random()
        @backdrop_x = 5 * math.sin(2 * @timer)
        @backdrop_y = 5 * math.sin(3 * @timer)

    keypressed: (k) =>
        switch k
            when "left", "right"
                @playerSelected = 3 - @playerSelected
            when "up", "down"
                @isPlayer_AI[@playerSelected] = not @isPlayer_AI[@playerSelected]
            when "return"
                @bgm\stop()
                stateStack\push(GameState(@isPlayer_AI[1], @isPlayer_AI[2], firstLevel))
            when "escape"
                love.event.push("quit")
