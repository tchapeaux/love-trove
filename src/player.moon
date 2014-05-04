require("lib/lgm/lgm")
require("wallset")

export ^

-- speeds are in px/s
intialSpeed = 50
deltaSpeed = 50 -- acceleration (in (px/s)/s)
maxSpeed = 200
deltaWall = 10 -- maximal length (in px) of a player wall
-- when that distance is reached the wall is divided into smaller walls

class Player extends LGM.Entity
    new: (x, y, @dirX, @dirY, @color, @name) =>
        super(x,y)
        @basePosition = {x, y}
        @baseDirection = {@dirX, @dirY}
        @score = 0
        @speed = intialSpeed
        @wallSet = WallSet()
        @lastWall = None
        @resetLastWall()
        @sfx_turn = {}
        baseSource = love.audio.newSource("res/sfx_turn.wav", "static")
        for i=1,10
            s = baseSource\clone()
            s\setVolume(0.5)
            s\setPitch(0.5 + 0.1 * i)
            table.insert(@sfx_turn, s)


    update: (dt, allWalls) =>
        -- update position
        oldX = @x
        oldY = @y
        @x += @dirX * @speed * dt
        @y += @dirY * @speed * dt

        -- update last wall
        @lastWall.x2 = @x - @dirX
        @lastWall.y2 = @y - @dirY
        if @lastWall\length() > deltaWall
            @resetLastWall()

        -- handle collisions
        foundCollision = false
        moveSegment = LGM.Segment(LGM.Vector(oldX, oldY), LGM.Vector(@x, @y))
        for wallSet in *allWalls
            foundCollision or= wallSet\intersectsWall(moveSegment)
        if not foundCollision
            @speed = math.min(maxSpeed, @speed + deltaSpeed * dt)
        else
            @score -= 1
            @x, @y = @basePosition[1], @basePosition[2]
            @dirX, @dirY = @baseDirection[1], @baseDirection[2]
            @speed = 0
            @wallSet = WallSet()
            @resetLastWall()

        -- update wallset
        @wallSet\update(dt)

    draw: =>
        love.graphics.setColor(@color)
        love.graphics.circle("fill", @x, @y, 5)
        love.graphics.printf(@name, @x - wScr() / 2, @y - 20, wScr(), "center")

        for wall in @wallSet\iter()
            wall\draw()

    keypressed: (k) =>
        if k == "up" and @dirY == 0
            @dirX = 0
            @dirY = -1
            @hasTurned()
        if k == "right" and @dirX == 0
            @dirX = 1
            @dirY = 0
            @hasTurned()
        if k == "left" and @dirX == 0
            @dirX = -1
            @dirY = 0
            @hasTurned()
        if k == "down" and @dirY == 0
            @dirX = 0
            @dirY = 1
            @hasTurned()

    resetLastWall: =>
        -- finalize @lastWall (also referenced in @wallSet)
        if @lastWall
            @lastWall.time = 0
        -- create new wall for the new direction
        @lastWall = Wall(@x, @y, @x, @y, @color, -1)
        @wallSet\add(@lastWall)

    hasTurned: =>
        @resetLastWall()

        @playSfxTurn()
        -- hotfix to not crash into its own wall
        @x += @dirX
        @y += @dirY

    playSfxTurn: =>
        i = -1
        cnt = 0
        while (i == -1 or not @sfx_turn[i]\isStopped()) and cnt < 10
            i = love.math.random(1, #@sfx_turn)
            cnt += 1
        @sfx_turn[i]\play()

