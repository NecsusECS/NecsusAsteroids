import necsus, random, vmath, ../components

type TriggerExplosion* = Vec2
    ## An event used to indicate where an explosion should originate

proc explosions*(
    dt: TimeDelta,
    triggers: Inbox[TriggerExplosion],
    spawnExplosion: Spawn[(Explosion, Position, Velocity, Shape)],
    particles: Query[(ptr Explosion, )],
    delete: Delete,
) =
    for eid, comp in particles:
        comp[0].ttl -= dt
        if comp[0].ttl < 0:
            delete(eid)

    for trigger in triggers:
        for _ in 1..50:
            discard spawnExplosion((
                Explosion(ttl: rand(0.0..3.0)),
                Position(center: trigger),
                Velocity(speed: vec2(rand(-100.0..100.0), rand(-100.0..100.0))),
                Shape(kind: ShapeKind.Point)
            ))
