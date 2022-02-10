import necsus, ../components, ../sdl2util, options, vmath

proc simulatePhysics*(dt: TimeDelta, query: Query[(ptr Position, Velocity)]) =
    ## Executes primitive physics simulation
    for (position, velocity) in query:
        position.center += velocity.speed * dt

const WRAP_MARGIN = 20.0

proc wrap(value: float, maximum: int): float =
    if value < -WRAP_MARGIN:
        maximum.float + WRAP_MARGIN
    elif value > maximum.float + WRAP_MARGIN:
        -WRAP_MARGIN
    else:
        value

proc validRange(maximum: int): auto = -WRAP_MARGIN..(maximum.float + WRAP_MARGIN)

proc edgeWrap*(
    wrapping: Query[(ptr Position, EdgeWrap)],
    nonWrapping: Query[(Position, Not[EdgeWrap])],
    screen: Shared[ScreenSize],
    delete: Delete
) =
    ## Checks if any entities have moved off screen and wraps them to the other side of the screen if they have
    for (position, shouldWrap) in wrapping:
        position.center.x = wrap(position.center.x, screen.get.width)
        position.center.y = wrap(position.center.y, screen.get.height)

    for eid, comps in nonWrapping:
        let (pos, _) = comps
        if pos.center.y notin validRange(screen.get.height) or pos.center.x notin validRange(screen.get.width):
            eid.delete()

proc rotation*(dt: TimeDelta, query: Query[(ptr Position, Rotating)]) =
    ## Applies rotation to an element
    for (pos, rotation) in query:
        pos.angle += rotation.rotateSpeed * dt
