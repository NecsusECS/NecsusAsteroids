import sdl2, sdl2/image, sdl2/ttf, os, sdl2util, fusion/smartptrs

type
    TextureType* = enum
        ## The various kinds of textures supported
        ShipTexture
        AsteroidTexture
        SmallAsteroidTexture

    FontType* = enum
        ## The available fonts
        PixelFontLarge
        PixelFontSmall

    TextureData* = object
        texture*: TexturePtr
        width*, height*: cint

    AssetsObj = object
        ## All the possible textures
        textures: array[TextureType, TextureData]
        fonts: array[FontType, FontPtr]

    Assets* = SharedPtr[AssetsObj]

proc readResource(filename: static string): auto =
    const file = staticRead("../resources" / filename)
    return rwFromConstMem(file.cstring, file.len)

proc readTexture(renderer: RendererPtr, filename: static string): TextureData =
    ## Reads a file from the resources directory
    result.texture = renderer.loadTexture_RW(readResource(filename), freesrc = 1)
    discard result.texture.queryTexture(nil, nil, addr result.width, addr result.height)

proc readFont(filename: static string, fontSize: cint): FontPtr =
    ## Reads a file from the resources directory
    result = openFontRW(readResource(filename), freesrc = 1, fontSize)
    sdlFailIf result.isNil: "Failed to load font"

proc initAssets*(renderer: RendererPtr): Assets =
    ## Initializes all the textures used by the game
    var asset: AssetsObj
    asset.textures[ShipTexture] = renderer.readTexture("ship.png")
    asset.textures[AsteroidTexture] = renderer.readTexture("asteroid1.png")
    asset.textures[SmallAsteroidTexture] = renderer.readTexture("asteroid2.png")
    asset.fonts[PixelFontLarge] = readFont("PressStart2P-Regular.ttf", fontSize = 50)
    asset.fonts[PixelFontSmall] = readFont("PressStart2P-Regular.ttf", fontSize = 18)
    return newSharedPtr(asset)

proc `[]`*(assets: Assets, key: TextureType): lent TextureData =
    ## Read a texture
    assets[].textures[key]

proc `[]`*(assets: Assets, key: FontType): lent FontPtr =
    ## Read a font
    assets[].fonts[key]
