#[
    TODO: copyright claim, license if needed
    Created: Dec 31, 2018 [12:31]

    Purpose: main entry point of game
]#

import os, macros, terminal
import sdl2/sdl, sdl2/sdl_image, opengl, glm

import 
    util/timing,
    util/eventhandler,
    util/input,
    util/filesys,
    util/logger,
    util/misc,
    graphics/window,
    graphics/texture,
    graphics/renderer,
    level as mLevel,
    camera,
    entity,
    scene

#GLOBAL CONSTS

#GLOBAL VARS
var
    running: bool
    title: string = "MRPGDS"
    width: int = 800
    height: int = 600
    context: GLContext
    event: Event
    framerate: Rate = rate(0)
    tickrate: Rate = rate(60)

var
    mainScene: Scene

#FUNC DECL
proc start() {.inline.} = running = true
proc stop() {.inline.} = running = false

proc init()
proc fin()

proc render(delta: float)
proc update(delta: float)


#[
    TODO:
        window wrapper #NOTE: maybe
        sprite, w /animations
        spritesheets
        camera
        stage/leveling
        world events
        FIX SCENE RENDITION / PLAYER SPAWN POINT!!!!!!
]#


#PROGRAM
when isMainModule:
    init()

    start()


    var last = time()
    while running:
        while pollEvent(addr(event)) != 0:
            if event.kind == Quit: stop()
            else: event.handle()
        
        # NOTE: do we like this???
        limit(update, tickrate)
        limit(render, framerate)

        if time() - last > 1:
            echo framerate.count, " fps"
            echo tickrate.count, " ticks"
            framerate.count = 0
            tickrate.count = 0
            last = time()

    fin()

#FUNC IMPL
proc render(delta: float) =
    # delta probably wont be used
    renderer.clear()
    
    renderer.setClearColor color(120, 0, 120, 255)

    render(mainScene)

    #render(stex, 400, 300)

    renderer.present()
    window.refresh()

proc update(delta: float) =
    input.update()
    
    mainScene.update(delta)

proc init() =
    discard sdl.init(INIT_EVERYTHING)
    discard sdl_image.init(INIT_PNG or INIT_JPG)
    discard glSetSwapInterval(0)

    discard window.init()
    filesys.init()
    input.init(ESDF_BINDINGS)

    mainScene = createScene(nil, createCamera())
    var color = vec4f(1, 0, 0, 0)
    drawQuad(100, 100, 100, 100, color = color)

    #NOTE: Legacy
    # let viewport = rect(0, 0, width, height)
    # let pCamera = createCamera(viewport = viewport)
    # pCamera.setOffset(0'f, 0'f)
    # let level: Level = createLevel(joinPath(["assets","tiled","maptest.tmx"]), getRenderer())
    # mainScene = createScene(level, pCamera)
    # let tex = loadTexture("assets\\gemm.png", getRenderer()) # typo for testing
    # let stex = createSubTexture(tex, rect(0,0,32,32))
    # mainScene.player.setSprite(stex)

proc fin() =
    #destroy(tex)
    renderer.terminate()
    window.terminate()

    # this shouldn't be needed, but better safe than sorry, right?
    system.addQuitProc(resetAttributes)
    
    sdl.quit()