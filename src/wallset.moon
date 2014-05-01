require("lib/lgm/lgm")

export ^

class WallSet extends LGM.EntitySet
    new: =>
        super()

    update: (dt) =>
        for wall in @iter()
            wall\update(dt)
            if (wall.time > wall.lifeTime) then
                @removeID(wall.id)

    intersectsWall: (segment) =>
        for wall in @iter()
            if segment\intersect(wall\as_segment())
                return true
        return false
