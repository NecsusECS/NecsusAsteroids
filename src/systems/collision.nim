import necsus, ../components, bumpy, vmath

proc collides(a: Circle, b: Bounds; bPos: Position): bool =
    case b.kind
    of BoundsKind.Circle: return a.overlaps(circle(vec2(bPos.x, bPos.y), b.radius))
    of BoundsKind.Triangle:
        discard

proc collides(a, b: Bounds; aPos, bPos: Position): bool =
    case a.kind
    of BoundsKind.Circle: return circle(vec2(aPos.x, aPos.y), a.radius).collides(b, bPos)
    of BoundsKind.Triangle:
        discard

proc markCollisions*(
    asteroids: Query[(Asteroid, Position, Bounds)],
    bullets: Query[(Bullet, Position, Bounds)],
    ships: Query[(Ship, Position, Bounds)],
    collided: Attach[(Collided, )],
) =
    ## Calculates asteroid collisions with various other entities
    for (asteroid, asteroidComp) in asteroids.pairs:
        let (_, asterPos, asterBounds) = asteroidComp

        for (bullet, bulletComp) in bullets.pairs:
            let (_, bulletPos, bulletBounds) = bulletComp
            if collides(asterBounds, bulletBounds, asterPos, bulletPos):
                asteroid.collided((Collided(), ))
                bullet.collided((Collided(), ))

        for (ship, shipComps) in ships.pairs:
            let (_, shipPos, shipBounds) = shipComps
            if collides(asterBounds, shipBounds, asterPos, shipPos):
                ship.collided((Collided(), ))
