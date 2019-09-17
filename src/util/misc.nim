import macros
import sdl2/sdl
import strformat

type
  NormalFloat* = object
    val, nval, min, max, nmin, nmax: float

  Point2f* = ref object of RootObj
    x, y: float

  Bounds* = ref object of Point2f
    w, h: float

proc normalize*(val, min, max, nmin, nmax: float): float =
  (val - min) * (nmax - nmin) / (max - min) + nmin

proc nFloat*(val, min, max:float, nmin:float = -1, nmax:float = 1): NormalFloat =
  NormalFloat(
    val: val, 
    nval: normalize(val, min, max, nmin, nmax),
    min: min, 
    max: max, 
    nmin: nmin, 
    nmax: nmax
  )

proc nFLoat*(nval, min, max:float, nmin:float = -1, nmax:float = 1): NormalFloat =
  NormalFloat(
    val: normalize(nval, nmin, nmax, min, max), 
    nval: nval,
    min: min, 
    max: max,
    nmin: nmin, 
    nmax: nmax
  )

proc min*(nfloat: NormalFloat): float {.inline.} = nfloat.min
proc max*(nfloat: NormalFloat): float {.inline.} = nfloat.max
proc val*(nfloat: NormalFloat): float {.inline.} = nfloat.val
proc nval*(nfloat: NormalFloat): float {.inline.} = nfloat.nval
proc `$`*(nfloat: NormalFloat): string {.inline.} = &"{nfloat.val} [{nfloat.min}, {nfloat.max}]\n{nfloat.nval} [{nfloat.nmin}, {nfloat.nmax}]"

proc point2f*(x = 0'f, y = 0'f ): Point2f {.inline.} = Point2f(x: x, y: y)
proc x*(p: Point2f): float {.inline.} = p.x
proc y*(p: Point2f): float {.inline.} = p.y
proc `x=`*(p: var Point2f, x: float) {.inline.} = p.x = x 
proc `y=`*(p: var Point2f, y: float) {.inline.} = p.y = y 

proc bounds*(x = 0'f, y = 0'f, w = 0'f, h = 0'f): Bounds {.inline.} = Bounds(x: x, y: y, w: w, h: h)
proc w*(b: Bounds): float {.inline.} = b.w
proc h*(b: Bounds): float {.inline.} = b.h
proc `x=`*(b: var Bounds, x: float) {.inline.} = b.x = x 
proc `y=`*(b: var Bounds, y: float) {.inline.} = b.y = y 
proc `w=`*(b: var Bounds, w: float) {.inline.} = b.w = w
proc `h=`*(b: var Bounds, h: float) {.inline.} = b.h = h

macro rect*(x, y, w, h: int): Rect =
  result =
    nnkStmtList.newTree(
      nnkObjConstr.newTree(
        newIdentNode("Rect"),
        nnkExprColonExpr.newTree(
          newIdentNode("x"), x
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("y"), y
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("w"), w
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("h"), h
        )
      )
    )

macro point*(x, y: int): untyped =
  result =
    nnkStmtList.newTree(
      nnkObjConstr.newTree(
        newIdentNode("Point"),
        nnkExprColonExpr.newTree(
          newIdentNode("x"), x
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("y"), y
        )
      )
    )

macro point2f*(x, y: int): untyped =
  result =
    nnkStmtList.newTree(
      nnkObjConstr.newTree(
        newIdentNode("Point2f"),
        nnkExprColonExpr.newTree(
          newIdentNode("x"), x
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("y"), y
        )
      )
    )

macro color*(r, g, b, a: uint8): untyped =
  result = 
    nnkStmtList.newTree(
      nnkObjConstr.newTree(
        newIdentNode("Color"),
        nnkExprColonExpr.newTree(
          newIdentNode("r"), r
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("g"), g
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("b"), b
        ),
        nnkExprColonExpr.newTree(
          newIdentNode("a"), a
        )
      )
    )

proc `+`*(rect: Rect, vec: tuple[x, y:cint]): Rect =
  result.x = rect.x + vec.x
  result.y = rect.y + vec.y

proc `-`*(rect: Rect, vec: tuple[x, y:cint]): Rect =
  result.x = rect.x - vec.x
  result.y = rect.y - vec.y

proc `+=`*(rect: var Rect, vec: tuple[x, y:cint]) =
  rect.x += vec.x
  rect.y += vec.y

proc `-=`*(rect: var Rect, vec: tuple[x, y:cint]) =
  rect.x -= vec.x
  rect.y -= vec.y