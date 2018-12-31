#[
  TODO: copyright claim, license if needed
  Created: Dec 31, 2018 [12:31]

  Purpose: main entry point of game
]#

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

#FUTURE DECL
proc start()
proc stop()

proc init()
proc terminate()

# TODO: 
  # do we want to handle the timing of these functions
  # internally or in the main loop
  # internally sounds nice tbh, clean main loop and all
proc render()
proc update()

#PROGRAM
when isMainModule:  
  init()

  start()
  while running:
    # TODO:
    # create event handler
    #   - global event state
    #   - handles sdl2.pollevent
    while sdl2.pollEvent(event):
      if event.kind == sdl2.QuitEvent: stop()

    render()
    update()

  terminate()

#PROC IMPL
proc render() =
  discard

proc update() =
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