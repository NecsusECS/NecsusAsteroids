import necsus, ../components, bumpy, vmath, math

proc rotateAround*(point, pivot: Vec2, degreesAngle: float): Vec2 =
    ## Rotates a point around another point
    let theta = degreesAngle.toRadians
    return vec2(
        cos(theta) * (point.x - pivot.x) - sin(theta) * (point.y - pivot.y) + pivot.x,
        sin(theta) * (point.x - pivot.x) + cos(theta) * (point.y - pivot.y) + pivot.y
    )

proc positionHull(points: seq[Vec2], position: Vec2): seq[Vec2] =
    for point in points:
        result.add(rotateAround(point + position, position, position.angle))

proc collides(a: Circle, b: Bounds; bPos: Vec2): bool =
    case b.kind
    of BoundsKind.Circle: return a.overlaps(circle(bPos, b.radius))
    of BoundsKind.Hull: return a.overlaps(positionHull(b.points, bPos))

proc collides(a, b: Bounds; aPos, bPos: Vec2): bool =
    case a.kind
    of BoundsKind.Circle: return circle(aPos, a.radius).collides(b, bPos)
    of BoundsKind.Hull: raise newException(AssertionDefect, "Not yet implemented!")

proc markCollisions*(
    asteroids: FullQuery[(Asteroid, Position, Bounds)],
    bullets: FullQuery[(Bullet, Position, Bounds)],
    ships: FullQuery[(Ship, Position, Bounds)],
    collided: Attach[(Collided, )],
) =
    ## Calculates asteroid collisions with various other entities
    for asteroid, asteroidComp in asteroids:
        let (_, asterPos, asterBounds) = asteroidComp

        for bullet, bulletComp in bullets:
            let (_, bulletPos, bulletBounds) = bulletComp
            if collides(asterBounds, bulletBounds, asterPos.center, bulletPos.center):
                asteroid.collided((Collided(), ))
                bullet.collided((Collided(), ))

        for ship, shipComps in ships:
            let (_, shipPos, shipBounds) = shipComps
            if collides(asterBounds, shipBounds, asterPos.center, shipPos.center):
                ship.collided((Collided(), ))
