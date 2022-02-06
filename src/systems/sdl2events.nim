import sdl2, necsus, ../components/inputEvents

proc emitEvents*(sendInput: Outbox[InputEvent], sendExit: Outbox[ExitEvent]) =
    ## Reads SDL2 events and emits them as ECS events
    var event = defaultEvent
    while pollEvent(event):
        case event.kind
        of QuitEvent:
            sendExit(ExitEvent())
        else:
            discard

proc exiter*(event: Inbox[ExitEvent], exit: var Shared[NecsusRun]) =
    ## Exits the app
    for _ in event:
        exit.set(ExitLoop)
