import necsus, sdl2, ../text, ../assets, ../components, ../sdl2util, vmath

proc splashScreen*(text: Shared[TextBuilder], spawn: Spawn[(Renderable, Position)], screen: Shared[ScreenSize]) =
    ## Creates text for the splash screen
    discard spawn.with(
        Renderable(
            kind: RenderKind.Text,
            text: text.getOrRaise.renderText(PixelFontLarge, "Asteroids", color(255, 255, 255, 255))
        ),
        Position(center: vec2(screen.getOrRaise.width / 2, screen.getOrRaise.height / 2))
    )

    discard spawn.with(
        Renderable(
            kind: RenderKind.Text,
            text: text.getOrRaise.renderText(PixelFontSmall, "Press any key to start", color(255, 255, 255, 255))
        ),
        Position(center: vec2(screen.getOrRaise.width / 2, screen.getOrRaise.height / 2 + 50))
    )

proc exitSplash*(input: Inbox[KeyboardEventObj], exit: Shared[NecsusRun]) =
    ## Exits the current app when any key is pressed
    for key in input:
        if key.kind == KeyUp and key.keysym.scancode in SDL_SCANCODE_A..SDL_SCANCODE_NONUSBACKSLASH:
            exit.set(ExitLoop)
