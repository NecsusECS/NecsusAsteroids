import necsus, sdl2, ../sdl2util, ../components, ../textures

proc renderer*(
    screen: Shared[ScreenSize],
    renderer: Shared[RendererPtr],
    textures: Shared[Textures],
    sprites: Query[(Sprite, Position)]
) =
    # Renders the current frame

    renderer.get.setDrawColor(0, 0, 0, 255)
    renderer.get.clear()
    renderer.get.setDrawBlendMode(BlendMode_Blend)

    for (sprite, pos) in sprites:
        let tex = textures.get()[sprite.texture]
        var src = rect(0, 0, tex.width, tex.height)
        var center = point(tex.width / 2, tex.height / 2)
        var target = rect(pos.x.cint - center.x, pos.y.cint - center.y, tex.width, tex.height)
        renderer.get.copyEx(tex.texture, src, target, angle = pos.angle, center = addr center)

    renderer.get.present()
