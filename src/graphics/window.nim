import os, macros, terminal, strformat
import sdl2/sdl, opengl

import ../util/logger
import renderer


var 
  window: Window
  context: GLContext
  viewport: Rect #TODO

proc init*(title: string = "MRPGDS", width = 800, height: int = 600): bool
proc refresh*() {.inline.} = glSwapWindow(window)
proc resize*(width, height: int)
proc terminate*()


proc init(title: string, width, height: int): bool =
  window = createWindow(
    title.cstring,
    WINDOWPOS_CENTERED,
    WINDOWPOS_CENTERED, 
    width.cint,
    height.cint,
    WINDOW_RESIZABLE or WINDOW_OPENGL)

  if SDLNil(window): return false
  LOG(DEBUG, "[SDL] created window")

  discard glSetAttribute(GL_CONTEXT_MAJOR_VERSION, 3)
  discard glSetAttribute(GL_CONTEXT_MINOR_VERSION, 2)
  var major, minor: cint
  discard glGetAttribute(GL_CONTEXT_MAJOR_VERSION, addr major)
  discard glGetAttribute(GL_CONTEXT_MINOR_VERSION, addr minor)
  LOG(DEBUG, &"[OPENGL] version:{major}.{minor}")

  context = glCreateContext(window)
  if SDLNil(window): return false
  LOG(DEBUG, "[SDL] created opengl context")
  
  loadExtensions()
  var ven = $cast[cstring](glGetString(GL_VENDOR))
  var ren = $cast[cstring](glGetString(GL_RENDERER))
  var ver = $cast[cstring](glGetString(GL_VERSION))
  var slv = $cast[cstring](glGetString(GL_SHADING_LANGUAGE_VERSION))
  LOG(DEBUG, &"[OPENGL] sys info:\n\t{ven}\n\t{ren}\n\t{ver}\n\t{slv}")
  
  renderer.init(window)


#TODO: imple
proc resize(width, height: int) = discard

proc terminate() = 
  glDeleteContext(context)
  destroyWindow(window)