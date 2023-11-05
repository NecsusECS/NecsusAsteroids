import necsus, sdl2, sdl2/gfx, ../sdl2util, ../components, ../assets, vmath, collision

proc reorient(point: Vec2, centroid: Position): Vec2 =
    ## Adjusts the location of a point based on a centroid
    (point + centroid.center).rotateAround(centroid.center, centroid.angle)

proc renderBoundingBoxes(renderer: RendererPtr, bounds: Query[(Bounds, Position)]) {.used.} =
    ## Renders the given bounding boxes
    for (bound, pos) in bounds:
        case bound.kind
        of BoundsKind.Circle:
            renderer.circleRGBA(pos.center.x.int16, pos.center.y.int16, bound.radius.int16, 255, 0, 0, 255)
        of BoundsKind.Hull:
            for (a, b) in bound.points.lines:
                renderer.drawLine(a.reorient(pos), b.reorient(pos), 255, 0, 0)

proc render(renderer: RendererPtr, pos: Position, tex: TexturePtr, width, height: cint) =
    var src = rect(0, 0, width, height)
    var center = point(width / 2, height / 2)
    var target = rect(pos.center.x.cint - center.x, pos.center.y.cint - center.y, width, height)
    renderer.copyEx(tex, src, target, angle = pos.angle, center = addr center)

proc renderer*(
    renderer: Shared[RendererPtr],
    assets: Shared[Assets],
    renderables: Query[(Renderable, Position)],
    bounds: Query[(Bounds, Position)],
) =
    # Renders the current frame

    renderer.getOrRaise.setDrawColor(0, 0, 0, 255)
    renderer.getOrRaise.clear()
    renderer.getOrRaise.setDrawBlendMode(BlendMode_Blend)

    for (renderable, pos) in renderables:
        case renderable.kind
        of RenderKind.Sprite:
            let tex = assets.getOrRaise()[renderable.texture]
            renderer.getOrRaise.render(pos, tex.texture, tex.width, tex.height)
        of RenderKind.Circle:
            renderer.getOrRaise.circleRGBA(pos.center.x.int16, pos.center.y.int16, renderable.radius.int16, 255, 255, 255, 255)
        of RenderKind.Point:
            renderer.getOrRaise.pixelRGBA(pos.center.x.int16, pos.center.y.int16, 255, 255, 255, 255)
        of RenderKind.Text:
            renderer.getOrRaise.render(pos, renderable.text.texture, renderable.text.width, renderable.text.height)

    # When enabled, render the bounding boxes
    when defined(renderBounds):
        renderBoundingBoxes(renderer.getOrRaise, bounds)

    renderer.getOrRaise.present()
