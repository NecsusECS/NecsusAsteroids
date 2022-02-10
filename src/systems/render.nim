import necsus, sdl2, sdl2/gfx, ../components, ../assets, vmath, collision

proc drawLine(renderer: RendererPtr, p1, p2: Vec2; r, g, b: uint8) =
    renderer.lineRGBA(p1.x.int16, p1.y.int16, p2.x.int16, p2.y.int16, r, g, b, 255)

iterator lines(points: openarray[Vec2]): (Vec2, Vec2) =
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

proc renderer*(
    renderer: Shared[RendererPtr],
    assets: Shared[Assets],
    sprites: Query[(Sprite, Position)],
    shapes: Query[(Shape, Position)],
    bounds: Query[(Bounds, Position)],
) =
    # Renders the current frame

    renderer.get.setDrawColor(0, 0, 0, 255)
    renderer.get.clear()
    renderer.get.setDrawBlendMode(BlendMode_Blend)

    for (sprite, pos) in sprites:
        let tex = assets.get()[sprite.texture]
        var src = rect(0, 0, tex.width, tex.height)
        var center = point(tex.width / 2, tex.height / 2)
        var target = rect(pos.center.x.cint - center.x, pos.center.y.cint - center.y, tex.width, tex.height)
        renderer.get.copyEx(tex.texture, src, target, angle = pos.angle, center = addr center)

    for (shape, pos) in shapes:
        case shape.kind
        of ShapeKind.Circle:
            renderer.get.circleRGBA(pos.center.x.int16, pos.center.y.int16, shape.radius.int16, 255, 255, 255, 255)
        of ShapeKind.Point:
            renderer.get.pixelRGBA(pos.center.x.int16, pos.center.y.int16, 255, 255, 255, 255)

    # When enabled, render the bounding boxes
    when defined(renderBounds):
        renderBoundingBoxes(renderer.get, bounds)

    renderer.get.present()
