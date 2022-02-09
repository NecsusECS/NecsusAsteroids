import necsus, ../components, ../sdl2util, ../textures, random, math

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

proc spawnAsteroids*(
    spawn: Spawn[(Asteroid, Position, Velocity, Sprite, EdgeWrap, Rotating)],
    screen: Shared[ScreenSize]
) =
    ## Initializes an asteroid
    randomize()

    let center = Position(x: screen.get.width / 2, y: screen.get.height / 2)

    for i in 0..5:

        discard spawn((
            Asteroid(),
            pickStartPosition(center, screen.get),
            Velocity(dx: randomVelocity(), dy: randomVelocity()),
            Sprite(texture: AsteroidTexture),
            EdgeWrap(),
            Rotating(rotateSpeed: rand(-100.0..100.0)),
        ))
