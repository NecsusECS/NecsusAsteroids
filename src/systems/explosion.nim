import necsus, random, vmath, ../components

type TriggerExplosion* = Vec2
    ## An event used to indicate where an explosion should originate

proc explosions*(
    dt: TimeDelta,
    triggers: Inbox[TriggerExplosion],
    spawnExplosion: Spawn[(Explosion, Position, Renderable, Velocity)],
    particles: FullQuery[(ptr Explosion, )],
    delete: Delete,
) =
    for eid, comp in particles:
        comp[0].ttl -= dt
        if comp[0].ttl < 0:
            delete(eid)

    for trigger in triggers:
        for _ in 1..50:
            spawnExplosion.with(
                Explosion(ttl: rand(0.0..3.0)),
                Position(center: trigger),
                Renderable(kind: RenderKind.Point),
                Velocity(speed: vec2(rand(-100.0..100.0), rand(-100.0..100.0))),
            )
