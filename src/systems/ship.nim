import necsus, ../components, ../sdl2util, ../textures

proc spawnShip*(spawn: Spawn[(Ship, Position, Velocity, Sprite, EdgeWrap)], screen: Shared[ScreenSize]) =
    ## Initializes the ship
    discard spawn((
        Ship(),
        Position(x: screen.get.width / 2, y: screen.get.height / 2),
        Velocity(dy: -30.0),
        Sprite(texture: ShipTexture),
        EdgeWrap()
    ))
