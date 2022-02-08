import sdl2, necsus

proc emitEvents*(
    sendInput: Outbox[KeyboardEventObj],
    exit: var Shared[NecsusRun]
) =
    ## Reads SDL2 events and emits them as ECS events
    var event = defaultEvent
    while pollEvent(event):
        case event.kind
        of QuitEvent:
            exit.set(ExitLoop)
        of KeyUp, KeyDown:
            sendInput(event.key[])
        else:
            discard
