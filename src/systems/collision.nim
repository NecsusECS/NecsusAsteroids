import necsus, ../components, bumpy, vmath

proc collides(a: Circle, b: Bounds; bPos: Vec2): bool =
    case b.kind
    of BoundsKind.Circle: return a.overlaps(circle(bPos, b.radius))
    of BoundsKind.Triangle:
        discard

proc collides(a, b: Bounds; aPos, bPos: Vec2): bool =
    case a.kind
    of BoundsKind.Circle: return circle(aPos, a.radius).collides(b, bPos)
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
            if collides(asterBounds, bulletBounds, asterPos.center, bulletPos.center):
                asteroid.collided((Collided(), ))
                bullet.collided((Collided(), ))

        for (ship, shipComps) in ships.pairs:
            let (_, shipPos, shipBounds) = shipComps
            if collides(asterBounds, shipBounds, asterPos.center, shipPos.center):
                ship.collided((Collided(), ))
