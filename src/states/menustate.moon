export ^

class MenuState extends State
    new: =>
        @isPlayer_AI = {false, true}
        @titleFont = love.graphics.newFont("res/font/moonhouse.ttf", 150)
        @textFont = love.graphics.newFont("res/font/REZ.ttf", 25)
        @playerSelected = 1

    draw: =>
        -- logo
        titleOffset = hScr() / 8
        love.graphics.setFont(@titleFont)
        love.graphics.setColor(colorP1)
        love.graphics.printf("TRÖVE", 10, titleOffset + 10, wScr(), "center")
        love.graphics.setColor(colorP2)
        love.graphics.printf("TRÖVE", 0, titleOffset, wScr(), "center")
        love.graphics.setFont(@textFont)
        love.graphics.setColor(colorP2)
        love.graphics.printf("ALTOM PRESENTS", 0, titleOffset, wScr() / 2, "center")
        love.graphics.setColor(colorP1)
        love.graphics.printf("a two player racing game", wScr() / 2, titleOffset + 140, wScr() / 2, "center")

        -- selectors
        playersSelectorOffset = 5 * hScr() / 8
        p1Text = if @isPlayer_AI[1] then "AI" else "P1"
        p2Text = if @isPlayer_AI[2] then "AI" else "P2"
        love.graphics.setColor(colorP1)
        love.graphics.setFont(@textFont)
        love.graphics.printf("Orange", 0, playersSelectorOffset, wScr() / 2, "center")
        love.graphics.setFont(@titleFont)
        love.graphics.printf(p1Text, 0, playersSelectorOffset + 30, wScr() / 2, "center")
        if not @isPlayer_AI[1]
            love.graphics.setFont(@textFont)
            love.graphics.printf("Movements arrows", 0, playersSelectorOffset + 180, wScr() / 2, "center")
        love.graphics.setFont(@textFont)
        love.graphics.setColor(colorP2)
        love.graphics.printf("Blue", wScr() / 2, playersSelectorOffset, wScr() / 2, "center")
        love.graphics.setFont(@titleFont)
        love.graphics.printf(p2Text, wScr() / 2, playersSelectorOffset + 30, wScr() / 2, "center")
        if not @isPlayer_AI[2]
            love.graphics.setFont(@textFont)
            love.graphics.printf("ZSQD or WSAD", wScr() / 2, playersSelectorOffset + 180, wScr() / 2, "center")


    update: (dt) =>

    keypressed: (k) =>
        switch k
            when "left", "right"
                @playerSelected = 3 - @playerSelected
            when "up", "down"
                @isPlayer_AI[@playerSelected] = not @isPlayer_AI[@playerSelected]
            when "return"
                stateStack\push(GameState(@isPlayer_AI[1], @isPlayer_AI[2], firstLevel))
