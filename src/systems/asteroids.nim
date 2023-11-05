import necsus, ../components, ../sdl2util, ../assets, random, vmath, explosion

type AsteroidComponents = (Asteroid, Position, Bounds, Velocity, Renderable, EdgeWrap, Rotating)

proc pickStartPosition(center: Vec2, screen: ScreenSize): Position =
    ## Pick a starting position that is not going to overlap with the ship
    let picked = vec2(rand(0.0..screen.width.float), rand(0.0..screen.height.float))
    if distSq(center, picked) < 30_000:
        return pickStartPosition(center, screen)
    else:
        return Position(center: picked, angle: rand(0.0..360.0))

proc randomVelocity(): auto =
    ## Picks a random velocity for an asteroid
    result = rand(30.0..180.0)
    if sample({true, false}):
        result *= -1

proc createAsteroid(position: Position, texture: TextureType, radius: float, splits: int): AsteroidComponents =
    (
        Asteroid(remainingSplits: splits),
        position,
        Bounds(kind: BoundsKind.Circle, radius: radius),
        Velocity(speed: vec2(randomVelocity(), randomVelocity())),
        Renderable(kind: RenderKind.Sprite, texture: texture),
        EdgeWrap(),
        Rotating(rotateSpeed: rand(-100.0..100.0)),
    )

proc spawnAsteroids*(spawn: Spawn[AsteroidComponents], screen: Shared[ScreenSize]) =
    ## Initializes an asteroid
    randomize()

    let center = vec2(screen.getOrRaise.width / 2, screen.getOrRaise.height / 2)

    for i in 0..5:
        discard spawn.set(createAsteroid(pickStartPosition(center, screen.getOrRaise), AsteroidTexture, 25.0, 1))

proc resolveAsteroidCollisions*(
    collisions: Query[(Collided, Asteroid, Position)],
    delete: Delete,
    spawn: Spawn[AsteroidComponents],
    screen: Shared[ScreenSize],
    explode: Outbox[TriggerExplosion],
) =
    ## Responds to an asteroid colliding
    for eid, comps in collisions:
        let (_, asteroid, pos) = comps
        explode(pos.center)
        if asteroid.remainingSplits > 0:
            for _ in 0..1:
                discard spawn.set(createAsteroid(pos, SmallAsteroidTexture, 10.0, asteroid.remainingSplits - 1))
        eid.delete()
