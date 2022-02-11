import necsus, ../components, ../text, ../sdl2util, ../assets, sdl2, vmath

type GameState = enum Playing, Won, Loss

proc checkWinOrLose*(
    text: Shared[TextBuilder],
    screen: Shared[ScreenSize],
    asteroids: Query[(Asteroid, )],
    ships: Query[(Ship, )],
    state: var Local[GameState],
    spawn: Spawn[(Renderable, Position)]
) =
    proc spawnText(str: string) =
        discard spawn((
            Renderable(
                kind: RenderKind.Text,
                text: text.get.renderText(PixelFontLarge, str, color(255, 255, 255, 255))
            ),
            Position(center: vec2(screen.get.width / 2, screen.get.height / 2))
        ))

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
