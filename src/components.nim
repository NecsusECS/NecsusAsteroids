import textures, vmath

type
    Ship* = object
        ## Marker component that represents the ship

    Bullet* = object
        ## Marker component that represents a bullet

    Asteroid* = object
        ## Marker component that represents an asteroid
        remainingSplits*: int

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

    Sprite* = object
        ## A renderable sprite
        texture*: TextureType

    ShapeKind* {.pure.} = enum Circle

    Shape* = object
        ## Allows rendering of an arbitrary shape
        case kind*: ShapeKind
        of ShapeKind.Circle:
            radius*: float

    EdgeWrap* = object
        ## Indicates that an entity should wrap to the other side of
        ## the screen when it goes of the edge

    BoundsKind* {.pure.} = enum Circle, Triangle

    Bounds* = object
        ## Collision boundary
        case kind*: BoundsKind
        of BoundsKind.Circle:
            radius*: float
        of BoundsKind.Triangle:
            width, height: float

    Collided* = object
        ## Marks that a collision happened

proc angleVector*(position: Position): Vec2 =
    ## Produces a vector representing the angle of a given position
    dir((position.angle - 90).toRadians.float32)
