import necsus, sdl2, math, ../components, ../sdl2util, ../textures, vmath, explosion

proc spawnShip*(spawn: Spawn[(Ship, Position, Velocity, Sprite, EdgeWrap, Bounds)], screen: Shared[ScreenSize]) =
    ## Initializes the ship
    discard spawn((
        Ship(),
        Position(center: vec2(screen.get.width / 2, screen.get.height / 2)),
        Velocity(),
        Sprite(texture: ShipTexture),
        EdgeWrap(),
        Bounds(
            kind: BoundsKind.Hull,
            points: @[ vec2(0.0, -13.0), vec2(8.0, 13.0), vec2(-8.0, 13.0) ]
        )
    ))

type Rotating = enum
    ## Used to mark that a user has requested rotation in a specific direction
    RotateLeft, RotateRight, NoRotate

const ROTATE_SPEED = 300.0

proc rotateShip*(
    dt: TimeDelta,
    ship: Query[(Ship, ptr Position)],
    inputs: Inbox[KeyboardEventObj],
    isRotating: var Local[Rotating]
) =
    ## Changes the rotation of the ship based on keyboard input

    # Look for keyboard events and record what direction the ship should be rotating
    for event in inputs:
        case event.kind
        of KeyDown:
            case event.keysym.scancode
            of SDL_SCANCODE_LEFT: isRotating.set(RotateLeft)
            of SDL_SCANCODE_RIGHT: isRotating.set(RotateRight)
            else: discard
        of KeyUp:
            case event.keysym.scancode
            of SDL_SCANCODE_LEFT:
                if isRotating.get(NoRotate) == RotateLeft:
                    isRotating.set(NoRotate)
            of SDL_SCANCODE_RIGHT:
                if isRotating.get(NoRotate) == RotateRight:
                    isRotating.set(NoRotate)
            else: discard
        else:
            discard

    # Update the angle of the ship based on the rotation direction
    for (_, pos) in ship:
        case isRotating.get(NoRotate):
        of NoRotate: discard
        of RotateLeft:
            pos.angle -= ROTATE_SPEED * dt
        of RotateRight:
            pos.angle += ROTATE_SPEED * dt

        pos.angle = if pos.angle < 0: 360.0 - pos.angle else: pos.angle mod 360.0

const ACCELERATION = 300.0

const MAX_SPEED = 500.0

proc accelerateShip*(
    dt: TimeDelta,
    ship: Query[(Ship, Position, ptr Velocity)],
    inputs: Inbox[KeyboardEventObj],
    isAccelerating: var Local[bool]
) =
    ## Looks for keyboard events and accelerates the ship

    # Look for keyboard events and record that the ship is accelerating
    for event in inputs:
        case event.kind
        of KeyDown:
            if event.keysym.scancode == SDL_SCANCODE_UP: isAccelerating.set(true)
        of KeyUp:
            if event.keysym.scancode == SDL_SCANCODE_UP: isAccelerating.set(false)
        else:
            discard

    if isAccelerating.get(false):
        for (_, pos, vel) in ship:
            vel.speed += pos.angleVector * (dt * ACCELERATION)

            # Cap out the max speed
            let speed = vel.speed.length
            if speed > MAX_SPEED:
                vel.speed *= MAX_SPEED / speed

proc resolveShipCollisions*(
    collision: Query[(Collided, Ship, Position)],
    delete: Delete,
    explode: Outbox[TriggerExplosion]
) =
    for eid, comp in collision:
        explode(comp[2].center)
        eid.delete()
