require("lib/lgm/lgm")

export ^

class AI_Player extends Player
    new: (x, y, dirX, dirY, color, @lookahead=30) =>
        -- lookahead is to be specified in px
        super(x, y, dirX, dirY, color)

    update: (dt) =>
        -- TODO: remove magic numbers
        newX = @x + @dirX * @lookahead
        newY = @y + @dirY * @lookahead

        moveSegment = LGM.Segment(LGM.Vector(@x, @y), LGM.Vector(newX, newY))

        if intersectsWall(moveSegment)
            -- turn
            if @dirX ~= 0
                @dirY = if love.math.random() > 0.5 then 1 else -1
                @dirX = 0
            elseif @dirY ~= 0
                @dirX = if love.math.random() > 0.5 then 1 else -1
                @dirY = 0
            else
                error("Invalid dir state! (#{@dirX}, #{@dirY})")
            @hasTurned()

        super(dt)
