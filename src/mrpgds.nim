#[
    TODO: copyright claim, license if needed
    Created: Dec 31, 2018 [12:31]

    Purpose: main entry point of game
]#

import util/timing
import util/eventhandler
import util/input
import util/filesys
import util/logger

import graphics/texture
import graphics/renderer

import ospaths, macros, terminal
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
    framerate: Rate = rate(-120)
    tickrate: Rate = rate(40)

#FUNC DECL
proc start()
proc stop()

proc init()
proc terminate()

proc render(delta: float)
proc update(delta: float)


#[
    TODO:
        window wrapper #NOTE: maybe
        create sprite, w /animations
        look at organization of renderer render functions
]#


#PROGRAM
when isMainModule:
    init()

    start()

    let tex = loadTexture("gemm.bmp", window.getRenderer) # typo for testing 

    var last = time()
    while running:
        while sdl2.pollEvent(event):
            if event.kind == sdl2.QuitEvent: stop()
            else: event.handle()
        
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
    renderer.clear()
    
    renderer.setClearColor color(255, 0, 255, 255)

    tex.render(100, 100, 300, 300)
    renderer.present()

proc update(delta: float) =
    input.update()

    if UP.active: echo "UP"
    if DOWN.active: echo "DOWN"
    if LEFT.active: echo "LEFT"
    if RIGHT.active: echo "RIGHT"
    if ATTACK1.active: echo "ATTACK1"
    if ATTACK2.active: echo "ATTACK2"

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
    LOG(DEBUG, "created sdl2 windowptr")

    filesys.init()
    input.init(ESDF_BINDINGS)
    renderer.init(window)

proc terminate() =
    tex.destroy()
    renderer.destroy()
    window.destroy()

    # this shouldn't be need, but better safe than sorry, right?
    system.addQuitProc(resetAttributes)
    
    sdl2.quit()

proc start() =
    running = true

proc stop() = 
    running = false