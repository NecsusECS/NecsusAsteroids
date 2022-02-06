import necsus, sdl2util, sdl2, systems/[sdl2events]

proc asteroids(screenSize: ScreenSize, renderer: RendererPtr) {.necsus(
    [],
    [~emitEvents, ~exiter],
    [],
    newNecsusConf()
).}

let screenSize = (width: 640, height: 480)

initialize(screenSize, window, renderer):
    asteroids(screenSize, renderer)
