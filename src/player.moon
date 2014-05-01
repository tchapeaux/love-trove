require("lib/lgm/lgm")

export ^

defaultSpeed = 50 -- px/s
deltaSpeed = 50
maxSpeed = 200

class Player extends LGM.Entity
    new: (x, y, @dirX, @dirY, @color) =>
        super(x,y)
        @basePosition = {x, y}
        @baseDirection = {@dirX, @dirY}
        @score = 0
        @speed = defaultSpeed
        @linkedWallsID = {}
        @lastWall = None
        @resetLastWall()

    update: (dt) =>
        oldX = @x
        oldY = @y

        @x += @dirX * @speed * dt
        @y += @dirY * @speed * dt

        @lastWall.x2 = @x - @dirX
        @lastWall.y2 = @y - @dirY

        foundCollision = false
        moveSegment = LGM.Segment(LGM.Vector(oldX, oldY), LGM.Vector(@x, @y))
        -- collisions with walls
        for wall in wallSet\iter()
            if wall ~= @lastWall
                if moveSegment\intersect(wall\as_segment(), False)
                    foundCollision = wall\as_segment()

        if not foundCollision
            @speed = math.min(maxSpeed, @speed + deltaSpeed * dt)
        else
            @score -= 1
            @x, @y = @basePosition[1], @basePosition[2]
            @dirX, @dirY = @baseDirection[1], @baseDirection[2]
            @speed = 0
            for id in *@linkedWallsID
                wallSet\removeID(id)
            @linkedWallsID = {}
            @resetLastWall()

    draw: =>
        love.graphics.setColor(@color)
        love.graphics.circle("fill", @x, @y, 5)

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
        @lastWall = Wall(@x, @y, @x, @y, @color, 0)
        wallSet\add(@lastWall)
        table.insert(@linkedWallsID, @lastWall.id)

    hasTurned: =>
        -- finalize lastWall (in global wallSet)
        @lastWall.time = 0
        @lastWall.x2 = @x
        @lastWall.y2 = @y

        -- create new wall for the new direction
        @resetLastWall()

        playSfxTurn()
        -- hotfix to not crash into its own wall
        @x += @dirX
        @y += @dirY

export playerSet = LGM.EntitySet()
