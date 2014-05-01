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
        @lastWallX = x
        @lastWallY = y
        @linkedWallsID = {}

    update: (dt) =>
        oldX = @x
        oldY = @y

        @x += @dirX * @speed * dt
        @y += @dirY * @speed * dt

        foundCollision = false
        moveSegment = LGM.Segment(LGM.Vector(oldX, oldY), LGM.Vector(@x, @y))
        -- collisions with walls
        for wall in wallSet\iter()
            if moveSegment\intersect(wall\as_segment(), False)
                foundCollision = wall\as_segment()
        -- collisions with other players's last wall (not in the set yet)
        for otherPlayer in playerSet\iter()
            if otherPlayer.id == @id
                continue
            playerSegment = LGM.Segment(LGM.Vector(otherPlayer.lastWallX, otherPlayer.lastWallY), LGM.Vector(otherPlayer.x, otherPlayer.y))
            if moveSegment\intersect(playerSegment)
                foundCollision = 2

        if not foundCollision
            @speed = math.min(maxSpeed, @speed + deltaSpeed * dt)
        else
            @score -= 1
            @x, @y = @basePosition[1], @basePosition[2]
            @dirX, @dirY = @baseDirection[1], @baseDirection[2]
            @lastWallX, @lastWallY = @x, @y
            @speed = 0
            for id in *@linkedWallsID
                wallSet\removeID(id)
            @linkedWallsID = {}

    draw: =>
        love.graphics.setColor(@color)
        love.graphics.circle("fill", @x, @y, 5)
        love.graphics.line(@lastWallX, @lastWallY, @x, @y)

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

    hasTurned: () =>
        newColor = {@color[1], @color[2], @color[3]}
        newWall = Wall(@lastWallX, @lastWallY, @x, @y, newColor, 0)
        wallSet\add(newWall)
        table.insert(@linkedWallsID, newWall.id)
        @lastWallX = @x
        @lastWallY = @y
        playSfxTurn()
        -- hotfix to not crash into its own wall
        @x += @dirX
        @y += @dirY

export playerSet = LGM.EntitySet()
