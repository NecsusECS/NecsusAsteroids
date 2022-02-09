import necsus, sdl2util, sdl2, textures, systems/[sdl2events, ship, physics, render, bullet, asteroids]

proc asteroids(screenSize: ScreenSize, renderer: RendererPtr, textures: Textures) {.necsus(
    [~spawnShip, ~spawnAsteroids],
    [~emitEvents, ~rotateShip, ~accelerateShip, ~rotation, ~shoot, ~simulatePhysics, ~edgeWrap, ~renderer],
    [],
    newNecsusConf()
).}

let screenSize = (width: 640, height: 480)

initialize(screenSize, window, renderer):
    let textures = renderer.newTextures()
    asteroids(screenSize, renderer, textures)
