import sdl2, sdl2/ttf, sdl2util, assets

type
    TextBuilder* {.byref.} = object
        ## Builder class for creating rendered text
        renderer: RendererPtr
        assets: ptr Assets

    RenderedText* = ref object
        ## Prerendered text
        texture*: TexturePtr
        width*, height*: cint

proc initTextBuilder*(renderer: RendererPtr, assets: ptr Assets): TextBuilder =
    ## Initializes the system for rendering text
    result.renderer = renderer
    result.assets = assets

proc renderText*(builder: TextBuilder, font: FontType, text: string, color: Color): RenderedText =
    ## Renders some text to a texture
    let surface = builder.assets[][font].renderUtf8Blended(text.cstring, color)
    sdlFailIf surface.isNil: "Could not render text surface"

    discard surface.setSurfaceAlphaMod(color.a)

    result.new
    result.width = surface.w
    result.height = surface.h
    result.texture = builder.renderer.createTextureFromSurface(surface)
    sdlFailIf result.texture.isNil: "Could not create texture from rendered text"

    surface.freeSurface()
