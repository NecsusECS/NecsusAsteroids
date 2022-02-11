import necsus, sdl2util, sdl2, assets, text
import systems/[sdl2events, ship, physics, render, bullet, asteroids, collision, explosion, splash]

proc splash(screenSize: ScreenSize, renderer: RendererPtr, assets: Assets, text: TextBuilder) {.necsus(
    [~splashScreen],
    [ ~emitEvents, ~exitSplash, ~renderer],
    [],
    newNecsusConf()
).}

proc game(screenSize: ScreenSize, renderer: RendererPtr, assets: Assets, text: TextBuilder) {.necsus(
    [~spawnShip, ~spawnAsteroids],
    [
        ~emitEvents,
        ~rotateShip,
        ~accelerateShip,
        ~rotation,
        ~shoot,
        ~markCollisions,
        ~resolveAsteroidCollisions,
        ~resolveShipCollisions,
        ~resolveBulletCollisions,
        ~explosions,
        ~simulatePhysics,
        ~edgeWrap,
        ~renderer,
    ],
    [],
    newNecsusConf()
).}

let screenSize = (width: 640, height: 480)

initialize(screenSize, window, renderer):
    var assets = renderer.initAssets()
    let text = initTextBuilder(renderer, addr assets)
    splash(screenSize, renderer, assets, text)
    game(screenSize, renderer, assets, text)
