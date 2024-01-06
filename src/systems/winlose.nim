import necsus, ../components, ../text, ../sdl2util, ../assets, sdl2, vmath

type GameState = enum Playing, Won, Loss

proc checkWinOrLose*(
    text: Shared[TextBuilder],
    screen: Shared[ScreenSize],
    asteroids: Query[(Asteroid, )],
    ships: Query[(Ship, )],
    state: Local[GameState],
    spawn: Spawn[(Position, Renderable)]
) =
    proc spawnText(str: string) =
        spawn.with(
            Position(center: vec2(screen.getOrRaise.width / 2, screen.getOrRaise.height / 2)),
            Renderable(
                kind: RenderKind.Text,
                text: text.getOrRaise.renderText(PixelFontLarge, str, color(255, 255, 255, 255))
            ),
        )

    block done:
        if state.get(Playing) == Playing:
            for _ in ships:
                break done
            state.set(Won)
            spawnText("You Lose")

    block done:
        if state.get(Playing) == Playing:
            for _ in asteroids:
                break done
            state.set(Won)
            spawnText("You Win")
