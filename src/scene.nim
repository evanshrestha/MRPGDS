#[
    Created: Jun 14, 2016 [02:06]

    Desc: Manager for the game objects, [level, cameras, player]
]#
import
  level,
  camera,
  entity


#TYPE DECL
type
  Scene* = ref object
    level: Level
    cameras: seq[Camera]
    camera: Camera
    player: Player

#GLOBAL CONSTS

#FUNC DECL
proc createScene*(level: Level, cam: Camera): Scene

proc update*(scene: Scene, delta: float)
proc setMainCamera*(scene: Scene, name: string)
proc getCamera(scene: Scene, name: string): Camera
proc addCamera*(scene: Scene, cam: Camera) {.inline.} = scene.cameras.add(cam)
proc `camera`*(scene: Scene): Camera {.inline.} = scene.camera

proc level*(scene: Scene): Level {.inline.} = scene.level
proc mainCamera*(scene: Scene): Camera {.inline.} = scene.camera
proc player*(scene: Scene): Player {.inline.} = scene.player


#FUNC IMPL
proc createScene(level: Level, cam: Camera): Scene =
  result = Scene(level: level)
  result.addCamera(cam)
  result.camera = cam
  result.player = Player()
  result.player.setSpawn(level.spawn)
  result.camera.setFocus(result.player.bounds)

proc update(scene: Scene, delta: float) =
  scene.level.update(delta)
  scene.player.update(delta)
  scene.camera.update(delta)

proc setMainCamera(scene: Scene, name: string) =
  scene.camera = scene.getCamera(name)

proc getCamera(scene: Scene, name: string): Camera =
  for cam in scene.cameras:
    if cam.name == name: return cam