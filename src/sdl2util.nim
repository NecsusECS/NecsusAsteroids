import sdl2, sdl2/gfx, vmath

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

proc drawLine*(renderer: RendererPtr, p1, p2: Vec2; r, g, b: uint8) =
    renderer.lineRGBA(p1.x.int16, p1.y.int16, p2.x.int16, p2.y.int16, r, g, b, 255)

iterator lines*(points: openarray[Vec2]): (Vec2, Vec2) =
    ## Generates lines from a list of points
    var firstPoint: Vec2
    var recentPoint: Vec2
    var isFirst: bool = true
    for point in points:
        if isFirst:
            firstPoint = point
            isFirst = false
        else:
            yield (recentPoint, point)
        recentPoint = point
    yield (recentPoint, firstPoint)
