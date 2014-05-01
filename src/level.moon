require("lib/lgm/lgm")
require("wall")
require("wallset")

export ^

class Level
    new: =>
        @wallSet = WallSet()
        @startingPosition = {}

    add: (wall) =>
        @wallSet\add(wall)

    intersectsWall: (segment) =>
        for wall in @wallSet\iter()
            if segment\intersect(wall\as_segment(), False)
                return true
        return false

export firstLevel = Level()

w = 800
h = 600
arenaOutSize = 40

firstLevel\add(Wall arenaOutSize, arenaOutSize, w - arenaOutSize,
    arenaOutSize,
    {255,255,255},
    -1)
firstLevel\add(Wall arenaOutSize,
    arenaOutSize,
    arenaOutSize,
    h - arenaOutSize,
    {255,255,255},
    -1)
firstLevel\add(Wall w - arenaOutSize,
    arenaOutSize,
    w - arenaOutSize,
    h - arenaOutSize,
    {255,255,255},
    -1)
firstLevel\add(Wall arenaOutSize,
    h - arenaOutSize,
    w - arenaOutSize,
    h - arenaOutSize,
    {255,255,255},
    -1)

table.insert(firstLevel.startingPosition, {
        LGM.Entity(w - (arenaOutSize + 10), h - (arenaOutSize + 10)),
        LGM.Vector(-1, 0)
    })
table.insert(firstLevel.startingPosition, {
    LGM.Entity(arenaOutSize + 10, arenaOutSize + 10),
    LGM.Vector(1, 0)
    })
