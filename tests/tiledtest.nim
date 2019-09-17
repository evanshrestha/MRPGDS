import 
  nim_tiled,
  sdl2/sdl,
  sdl2/sdl_image,
  ospaths,
  os

discard sdl.init(InitVideo)
discard sdl.init(InitPng)

var 
  window: Window
  renderer: Renderer
  event: Event
  running: bool
  scale = 2

proc terminate()

assert(createWindowAndRenderer(800, 600, 0, addr(window), addr(renderer)) == 0, "failed to create window/renderer")
if renderer == nil or window == nil: echo sdl.getError()

var path = joinPath(getAppDir(), "assets", "tiled", "16x16base64compressedtest.tmx")

let map = loadTiledMap(path)
let tileset = map.tilesets[0]

let texture = renderer.loadTexture(getCurrentDir().joinPath("bin", "assets", "tiled", tileset.imagePath))

running = true

while running:
  while pollEvent(event.addr) != 0:
    case event.kind
    of Quit: 
      running = false
    else: discard
  
  discard renderer.renderClear()
  
  #echo renderer.renderCopy(texture, nil, nil)
  
  for layer in map.layers:
    for y in 0..<layer.height:
      for x in 0..<layer.width:
        let tileid = layer.tiles[x+y*layer.width]
        if tileid != 0:
          let region = tileset.regions[tileid-1]

          var sregion = sdl.Rect(x: region.x, y: region.y, w: region.width, h: region.height)
          var dregion = sdl.Rect(x: x * map.tilewidth*scale, y: y * map.tileheight*scale, w: map.tilewidth*scale, h: map.tileheight*scale)

          discard renderer.renderCopy(
            texture,
            addr(sregion),
            addr(dregion)
          )

  renderer.renderPresent()

terminate()

proc terminate() =
  destroyWindow(window)
  destroyRenderer(renderer)