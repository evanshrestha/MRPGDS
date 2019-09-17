#[
    Created: 06 13, 2019 [23:53]

    Desc: entity object wrapper with helper methods and classes
]#
import 
  math

import 
  graphics/texture,
  util/input,
  util/misc

#TYPE DECL
type
  EntityKind = enum
    light, gold

  MobFamily = enum
    ogre, skeleton, soul

  Entity* = ref object of RootObj
    bounds: Bounds
    sprite: STexture
    case kind: EntityKind
    of light:
      dir: uint
    else: discard

  Mob* = ref object of Entity
    family: MobFamily

  Player* = ref object of Mob
    main: bool

#GLOBAL CONSTS


#FUNC DECL
proc update*(ent: Entity, delta: float)
proc update*(mob: Mob, delta: float)
proc update*(player: Player, delta: float)
proc move(ent: Entity, magnitude: float, dir: float)
proc bounds*(ent: Entity): Bounds {.inline.} = ent.bounds
#TODO: actuall sprites lmao
proc sprite*(ent: Entity): STexture {.inline.} = ent.sprite
proc setSprite*(ent: Entity, sprite: STexture) {.inline.} = ent.sprite = sprite

proc x*(ent: Entity): float {.inline.} = ent.bounds.x
proc y*(ent: Entity): float {.inline.} = ent.bounds.y
proc w(ent: var Entity): float {.inline.} = ent.bounds.w
proc h(ent: var Entity): float {.inline.} = ent.bounds.h
proc `x=`(ent: var Entity, x: float) {.inline.} = ent.bounds.x = x
proc `y=`(ent: var Entity, y: float) {.inline.} = ent.bounds.y = y
proc `w=`(ent: var Entity, w: float) {.inline.} = ent.bounds.w = w
proc `h=`(ent: var Entity, h: float) {.inline.} = ent.bounds.h = h

proc setSpawn*(ent: Entity, pos: Point2f)

#GLOBAL FIELDS

#FUNC IMPL
proc update(ent: Entity, delta: float) =
  case ent.kind
  else: discard
  
proc update(mob: Mob, delta: float) = 
  case mob.family
  else: discard

proc update(player: Player, delta: float) =
  var ang: float = -1

  let up = input.UP.active
  let down = input.DOWN.active
  let left = input.LEFT.active
  let right = input.RIGHT.active
  
  if down and right: ang = PI / 4
  elif down and left: ang = PI / 4 * 3
  elif up and left: ang = PI / 4 * 5
  elif up and right: ang = PI / 4 * 7
  elif down: ang = PI / 2
  elif up: ang = PI / 2 * 3
  elif left: ang = PI
  elif right: ang = PI * 2 

  move(player, 100 * delta, ang)
  
proc move(ent: Entity, magnitude: float, dir: float) =
  if dir == -1: return
  var mag = magnitude
  var x = mag * cos(dir)
  var y = mag * sin(dir)

  ent.bounds.x = ent.x + x
  ent.bounds.y = ent.y + y
  #TODO: collision here???

proc setSpawn(ent: Entity, pos: Point2f) =
  ent.bounds = bounds(pos.x, pos.y)
  #TODO: acutally set spawn