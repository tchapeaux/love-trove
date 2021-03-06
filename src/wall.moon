require("lib/lgm/lgm")

export ^

wallLifeTime = 5 --s
wallFadeOut = .5

class Wall extends LGM.Entity
    new: (x, y, @x2, @y2, @color, @time)=>
        --time: -1 for immortal
        super(x,y)
        @lifeTime = wallLifeTime

    as_segment: =>
        return LGM.Segment(LGM.Vector(@x, @y), LGM.Vector(@x2, @y2))

    length: =>
        LGM.distance(@x, @y, @x2, @y2)

    update: (dt) =>
        if @time ~= -1
            @time += dt

    draw: =>
        newColor = {}
        fadeFactor = 1
        if @time ~= -1 and @time > (wallLifeTime - wallFadeOut)
            fadeFactor = (wallLifeTime - @time) / wallFadeOut
        table.insert(newColor, @color[i] * fadeFactor) for i=1,3
        love.graphics.setColor(newColor)
        love.graphics.setLineWidth(2)
        love.graphics.line(@x, @y, @x2, @y2)
