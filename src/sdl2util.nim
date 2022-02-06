import sdl2

type
    SDLException = object of Defect

    ScreenSize* = tuple[width: int, height: int]

template sdlFailIf(condition: typed, reason: string) =
    if condition: raise SDLException.newException(reason & ", SDL error " & $getError())

template initialize*(screenSize: ScreenSize, window, renderer, code: untyped) =
    try:

        sdlFailIf(not sdl2.init(INIT_VIDEO or INIT_TIMER or INIT_EVENTS)): "SDL2 initialization failed"
        defer: sdl2.quit()

        let window = createWindow(
            title = "Example",
            x = SDL_WINDOWPOS_CENTERED,
            y = SDL_WINDOWPOS_CENTERED,
            w = screenSize.width.cint,
            h = screenSize.height.cint,
            flags = SDL_WINDOW_SHOWN
        )

        sdlFailIf window.isNil: "window could not be created"
        defer: window.destroy()

        let renderer = createRenderer(
            window = window,
            index = -1,
            flags = Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture
        )
        sdlFailIf renderer.isNil: "renderer could not be created"
        defer: renderer.destroy()

        code
    except:
        echo getCurrentExceptionMsg()
        raise
