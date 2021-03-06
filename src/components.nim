import assets, vmath, text

type
    Ship* = object
        ## Marker component that represents the ship

    Bullet* = object
        ## Marker component that represents a bullet

    Asteroid* = object
        ## Marker component that represents an asteroid
        remainingSplits*: int

    Explosion* = object
        ## Marks a particle in an explosion
        ttl*: float

    Rotating* = object
        ## Rotates a sprite
        rotateSpeed*: float

    Position* = object
        ## Position of an element
        center*: Vec2
        angle*: float

    Velocity* = object
        ## The speed of movement of an object
        speed*: Vec2

    RenderKind* {.pure.} = enum Sprite, Circle, Point, Text

    Renderable* = object
        ## Various things that can be rendered
        case kind*: RenderKind
        of RenderKind.Sprite:
            texture*: TextureType
        of RenderKind.Circle:
            radius*: float
        of RenderKind.Point:
            discard
        of RenderKind.Text:
            text*: RenderedText

    EdgeWrap* = object
        ## Indicates that an entity should wrap to the other side of
        ## the screen when it goes of the edge

    BoundsKind* {.pure.} = enum Circle, Hull

    Bounds* = object
        ## Collision boundary
        case kind*: BoundsKind
        of BoundsKind.Circle:
            radius*: float
        of BoundsKind.Hull:
            points*: seq[Vec2]

    Collided* = object
        ## Marks that a collision happened

proc angleVector*(position: Position): Vec2 =
    ## Produces a vector representing the angle of a given position
    dir((position.angle - 90).toRadians.float32)
