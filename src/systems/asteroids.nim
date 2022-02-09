import necsus, ../components, ../sdl2util, ../textures, random, math

type AsteroidComponents = (Asteroid, Position, Bounds, Velocity, Sprite, EdgeWrap, Rotating)

proc sqrDistance(a, b: Position): float =
    ## Calculate the squared distance between two positions
    pow(b.x - a.x, 2) + pow(b.y - a.y, 2)

proc pickStartPosition(center: Position, screen: ScreenSize): Position =
    ## Pick a starting position that is not going to overlap with the ship
    let picked = Position(x: rand(0.0..screen.width.float), y: rand(0.0..screen.height.float), angle: rand(0.0..360.0))
    return if sqrDistance(center, picked) < 1000: pickStartPosition(center, screen) else: picked

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
        Velocity(dx: randomVelocity(), dy: randomVelocity()),
        Sprite(texture: texture),
        EdgeWrap(),
        Rotating(rotateSpeed: rand(-100.0..100.0)),
    )

proc spawnAsteroids*(spawn: Spawn[AsteroidComponents], screen: Shared[ScreenSize]) =
    ## Initializes an asteroid
    randomize()

    let center = Position(x: screen.get.width / 2, y: screen.get.height / 2)

    for i in 0..5:
        discard spawn(createAsteroid(pickStartPosition(center, screen.get), AsteroidTexture, 40.0, 1))

proc resolveAsteroidCollisions*(
    collisions: Query[(Collided, Asteroid, Position)],
    delete: Delete,
    spawn: Spawn[AsteroidComponents],
    screen: Shared[ScreenSize]
) =
    ## Responds to an asteroid colliding
    for eid, comps in collisions:
        let (_, asteroid, pos) = comps
        if asteroid.remainingSplits > 0:
            for _ in 0..1:
                discard spawn(createAsteroid(pos, SmallAsteroidTexture, 20.0, asteroid.remainingSplits - 1))
        eid.delete()
