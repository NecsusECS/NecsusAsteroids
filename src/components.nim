import textures

type
    Ship* = object
        ## Marker component that represents the ship

    Bullet* = object
        ## Marker component that represents a bullet

    Asteroid* = object
        ## Marker component that represents an asteroid

    Rotating* = object
        ## Rotates a sprite
        rotateSpeed*: float

    Position* = object
        ## Position of an element
        x*, y*, angle*: float

    Velocity* = object
        ## The speed of movement of an object
        dx*, dy*: float

    Sprite* = object
        ## A renderable sprite
        texture*: TextureType

    ShapeKind* = enum Circle

    Shape* = object
        ## Allows rendering of an arbitrary shape
        case kind*: ShapeKind
        of Circle:
            radius*: float

    EdgeWrap* = object
        ## Indicates that an entity should wrap to the other side of
        ## the screen when it goes of the edge
