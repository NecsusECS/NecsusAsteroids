import sdl2, sdl2/image, os

type
    TextureType* = enum
        ## The various kinds of textures supported
        ShipTexture
        AsteroidTexture
        SmallAsteroidTexture

    TextureData* = object
        texture*: TexturePtr
        width*, height*: cint

    Textures* = object
        ## All the possible textures
        textures: array[TextureType, TextureData]

proc readTexture(renderer: RendererPtr, filename: static string): TextureData =
    ## Reads a file from the resources directory
    const file = staticRead("../resources" / filename)
    let data = rwFromConstMem(file.cstring, file.len)
    result.texture = renderer.loadTexture_RW(data, freesrc = 1)
    discard result.texture.queryTexture(nil, nil, addr result.width, addr result.height)

proc newTextures*(renderer: RendererPtr): Textures =
    ## Initializes all the textures used by the game
    result.textures[ShipTexture] = renderer.readTexture("ship.png")
    result.textures[AsteroidTexture] = renderer.readTexture("asteroid1.png")
    result.textures[SmallAsteroidTexture] = renderer.readTexture("asteroid2.png")

proc `[]`*(textures: Textures, key: TextureType): lent TextureData =
    ## Read a texture
    textures.textures[key]

proc `=destroy`*(textures: var Textures) =
    for tex in low(TextureType)..high(TextureType):
        textures.textures[tex].texture.destroy()
