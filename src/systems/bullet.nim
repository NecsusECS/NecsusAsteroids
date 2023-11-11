import necsus, sdl2, ../components, vmath

const BULLET_SPEED = 700.0

const BULLET_DELAY = 0.2

proc shoot*(
    inputs: Inbox[KeyboardEventObj],
    ship: Query[(Ship, Position)],
    spawn: Spawn[(Bounds, Bullet, Position, Renderable, Velocity)],
    time: TimeElapsed,
    lastShot: Local[float]
) =
    ## Create a bullet when the spacebar is pressed
    template spawnBullet(start: Position) =
        lastShot := time
        discard spawn.with(
            Bounds(kind: BoundsKind.Circle, radius: 4.0),
            Bullet(),
            start,
            Renderable(kind: Circle, radius: 5.0),
            Velocity(speed: start.angleVector * BULLET_SPEED),
        )

    for input in inputs:
        if input.kind == KeyDown and input.keysym.scancode == SDL_SCANCODE_SPACE:
            if time - lastShot.get(-BULLET_SPEED) > BULLET_DELAY:
                for (_, spawnPosition) in ship:
                    spawnBullet(spawnPosition)

proc resolveBulletCollisions*(other: Query[(Collided, Bullet)], delete: Delete) =
    ## Responds to a bullet hitting an asteroid
    for eid, _ in other:
        eid.delete()
