import textures

type
    Ship* = object
        ## Marker component that represents the ship

    Position* = object
        ## Position of an element
        x*, y*, angle*: float

    Velocity* = object
        ## The speed of movement of an object
        dx*, dy*: float

    Sprite* = object
        ## A renderable sprite
        texture*: TextureType

    EdgeWrap* = object
        ## Indicates that an entity should wrap to the other side of
        ## the screen when it goes of the edge
