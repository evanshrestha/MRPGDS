#[
    Created: May 19, 2019 [01:22]

    Desc: manage position of renderable objects

    Camera
      pos -> postion in the "world"
      offset -> offset from it's focus point, normalized to -1,1
      viewport -> view area in respect to the screen
      focus -> center point
]#

import sdl2/sdl, opengl, glm

import
  util/misc,
  util/input

#TYPE DECL
type
  Camera* = ref object
    name: string
    proj: Mat4f
    view: Mat4f
    pos: Point2f
    offset: tuple[x,y:NormalFloat]
    focus: Point2f

#GLOBAL CONSTS

#FUNC DECL
proc createCamera*(focus: Point2f = nil): Camera

proc update*(cam: var Camera, delta: float)
proc projection*(cam: Camera): Mat4f {.inline.} = cam.proj
proc `view`*(cam: Camera): Mat4f {.inline.} = cam.view
#proc setOffset*(camera: Camera, x, y: float, normalized: bool = true)
proc setFocus*(camera: Camera, pos: Point2f) {.inline.} = camera.focus = pos

#GLOBAL FIELDS

#FUNC IMPL
proc createCamera*(focus: Point2f = nil): Camera =
  result = Camera(
    focus: focus,
    proj: ortho(0'f32, 0, 800, 600, 0.01, 10),
    view: mat4f(0).translate(0,0,1)
  )

proc update*(cam: var Camera, delta: float) = discard

# proc createCamera*(viewport:Rect; focus: Point2f): Camera =
#   result = Camera(
#     viewport: viewport,
#     focus: focus
#   )
#   result.pos = point2f(0, 0)
#   result.setOffset(0.float, 0.float, true)

# proc setOffset*(camera: Camera, x, y: float, normalized: bool = true) = 
#   camera.offset = 
#     if normalized:
#       (nFloat(nval = x, camera.viewport.x.float, camera.viewport.w.float),
#       nFloat(nval = y, camera.viewport.y.float, camera.viewport.h.float))
#     else:
#       (nFloat(val = x, camera.viewport.x.float, camera.viewport.w.float),
#       nFloat(val = y, camera.viewport.y.float, camera.viewport.h.float))

# proc update*(cam: var Camera, delta: float) =
#   if cam.focus != nil:
#     cam.pos.x = cam.focus.x
#     cam.pos.y = cam.focus.y
#     cam.offsetPos.x = -cam.offset.x.val + cam.pos.x
#     cam.offsetPos.y = -cam.offset.y.val + cam.pos.y
#   else:
#     cam.pos.x = 0
#     cam.pos.y = 0


proc x*(cam: Camera): float {.inline.} = cam.pos.x
proc y*(cam: Camera): float {.inline.} = cam.pos.y
#proc w*(cam: Camera): int {.inline.} = cam.viewport.w
#proc h*(cam: Camera): int {.inline.} = cam.viewport.h
proc pos*(cam: Camera): Point2f {.inline.} = cam.pos
proc offset*(cam: Camera): tuple[x,y:NormalFloat] {.inline.} = cam.offset
proc offsetPos*(cam: Camera): tuple[x,y:float] {.inline.} = cam.offsetPos
proc viewport*(cam: Camera): Rect {.inline.} = cam.viewport
proc name*(cam: Camera): string {.inline.} = cam.name