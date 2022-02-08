import necsus, ../components, ../sdl2util

proc simulatePhysics*(dt: TimeDelta, query: Query[(ptr Position, Velocity)]) =
    ## Executes primitive physics simulation
    for (position, velocity) in query:
        position.x += velocity.dx * dt
        position.y += velocity.dy * dt

const WRAP_MARGIN = 20.0

proc wrap(value: float, maximum: int): float =
    if value < -WRAP_MARGIN:
        maximum.float + WRAP_MARGIN
    elif value > maximum.float + WRAP_MARGIN:
        WRAP_MARGIN
    else:
        value

proc edgeWrap*(query: Query[(ptr Position, EdgeWrap)], screen: Shared[ScreenSize],) =
    ## Checks if any entities have moved off screen and wraps them to the other side of the screen if they have
    for (position, _) in query:
        position.y = wrap(position.y, screen.get.height)
        position.x = wrap(position.x, screen.get.width)
