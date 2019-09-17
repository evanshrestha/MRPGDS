#[
    Created: 5 18, 2019 [17:08]

    Desc: level logic and controller and wrapper for types need for level 
]#

import
  terminal,
  os

import
  sdl2/sdl,
  nim_tiled

import
  graphics/sprite,
  graphics/texture,
  util/logger,
  util/filesys,
  util/misc

#TYPE DECL
type
  Level* = ref object
    map: TiledMap
    textures: seq[WTexture]
    scale: float
    time: int

  Tile = object
    sprite: Sprite
    solid: bool
    action: proc()

#GLOBAL CONSTS

#FUNC DECL
proc createLevel*(path: string, renderer: Renderer): Level
proc update*(level: Level, delta: float)
proc spawn*(level: Level): Point2f

proc `$`*(level: Level): string

#GLOBAL VARS

#FUNC IMPL
proc createLevel*(path: string, renderer: Renderer): Level =
  let abspath = path.toAbsDir
  LOG(DEBUG, "loading tiled map at "&abspath)
  
  var map = loadTiledMap(abspath)
  
  var textures: seq[WTexture]
  for tileset in map.tilesets:
    let path = joinPath(["assets", "tiled", tileset.imagePath]).toAbsDir
    textures.add(loadTexture(path, renderer))

  result = Level(
    map: map,
    textures: textures,
    scale: 2,
    time: 0
  )
  LOG(DEBUG, $result & "\n")
  LOG(DEBUG, "done!\n")

proc update(level: Level, delta: float) =
  discard

proc spawn(level: Level): Point2f =
  return point2f(100, 100) #TODO: get actual tiled spawn point

proc map*(level: Level): TiledMap {.inline.} = level.map
proc scale*(level: Level): float {.inline.} = level.scale
proc texture*(level: Level, index: int): WTexture {.inline.} = level.textures[index]
proc tileWS*(level: Level): int {.inline.} = int(level.map.tilewidth.float*level.scale)
proc tileHS*(level: Level): int {.inline.} = int(level.map.tileheight.float*level.scale)
#proc time*(level: Level): int {.inline.} = level.time

proc `$`*(level: Level): string =
  result = 
    "TiledMap" &
    "\n\tversion: " & level.map.version &
    "\n\tmapsize: " & $level.map.width & ", " & $level.map.height &
    "\n\ttilesize: " & $level.map.tilewidth & ", " & $level.map.tileheight &
    "\n\tscale: " & $level.scale &
    "\n\tlayers: " & $level.map.layers.len
