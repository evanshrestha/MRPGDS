#[
    TODO: copyright claim, license if needed
    Created: Dec 31, 2018 [12:31]

    Purpose: main entry point of game
]#

import util/timing
import sdl2

# TODO: logging macro

#GLOBAL CONSTS

#GLOBAL FIELDS
var 
    running: bool
    title: string = "MRPGDS"
    width: int = 800
    height: int = 600
    window: WindowPtr
    event: Event = sdl2.defaultEvent
    framerate: Rate = rate(120)
    tickrate: Rate = rate(40)

#FUNC DECL
proc start()
proc stop()

proc init()
proc terminate()

proc render(delta: float)
proc update(delta: float)

#PROGRAM
when isMainModule:  
    init()

    start()
    
    var last = time()
    while running:
        # TODO:
        # create event handler
        #   - global event state
        #   - handles sdl2.pollevent
        while sdl2.pollEvent(event):
            if event.kind == sdl2.QuitEvent: stop()
        
        # NOTE: do we like this???
        framerate.limit(render)
        tickrate.limit(update)

        if time() - last > 1:
            echo framerate.count, " fps"
            echo tickrate.count, " ticks"
            framerate.count = 0
            tickrate.count = 0
            last = time()

    terminate()

#FUNC IMPL
proc render(delta: float) =
    # delta probably wont be used
    discard

proc update(delta: float) =
    # update here
    discard

proc init() =
    sdl2.init(INIT_EVERYTHING)
    window = 
        sdl2.createWindow(
        title.cstring,
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED, 
        width.cint, 
        height.cint,
        SDL_WINDOW_RESIZABLE)

proc terminate() =
    destroy window

    sdl2.quit()

proc start() =
    running = true

proc stop() = 
    running = false