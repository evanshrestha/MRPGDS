import os
import sdl2/sdl, sdl2/sdl_image, glm, opengl

const
  FlipH = 1
  FLipV = 2

var defaultTexture: GLuint
let defaultTexturePath = "res"/"textures"/"container.jpg"

#TODO: Defualt error texture
proc createTexture*(path: string, flip: int = 0): GLuint
proc flip(surf: var Surface, flags: int)

proc DefaultTexture*(): GLuint =
  if not glIsTexture(defaultTexture): defaultTexture = createTexture(defaultTexturePath)
  defaultTexture

proc createTexture*(path: string, flip: int): GLuint =
  glGenTextures(1, addr result)
  glActiveTexture(GL_TEXTURE0)
  glBindTexture(GL_TEXTURE_2D, result)

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)

  var surf = sdl_image.load(path)
  if surf == nil:
    echo "[SDL IMAGE] failed to load texture image"
    #TODO: use def texture
  
  #flip texture
  if flip != 0: surf.flip(flip)

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB.GLint, surf.w, surf.h, 0, GL_RGB, GL_UNSIGNED_BYTE, surf.pixels)
  glGenerateMipmap(GL_TEXTURE_2D)

  glBindTexture(GL_TEXTURE_2D, 0)
  freeSurface(surf)

proc flip(surf: var Surface, flags: int) =
  #let width = surf.w
  let height = surf.h
  let fmt = surf.format

  #echo getPixelFormatName(fmt.format)
  if mustLock(surf): discard lockSurface(surf)

  # pixels is modifable in ptrMath block
  var pixels = cast[ptr uint32](surf.pixels)

  var pbuf: uint32
  var s, e: int
  let p = surf.pitch div 4 # Rima? why'd you turn fake on me?
  case flags
  of FLipV:
    for y in 0..<int(height / 2):
      for x in 0..<p:
        s = x + y * p
        e = x + (height - y - 1) * p
        ptrMath:
          pbuf = pixels[e]
          pixels[e] = pixels[s]
          pixels[s] = pbuf
  of FlipH:
    for y in 0..<height:
      for x in 0..<p:
        s = x + y * p
        e = (p - x - 1) + y * p
        ptrMath:
          pbuf = pixels[e]
          pixels[e] = pixels[s]
          pixels[s] = pbuf
  of FlipH and FLipV:
    for y in 0..<height:
      for x in 0..<p-y:
        s = x + y * p
        e = (p - x - 1) + (height - y - 1) * p
        ptrMath:
          pbuf = pixels[e]
          pixels[e] = pixels[s]
          pixels[s] = pbuf
  else: return

  
  if mustLock(surf): unlockSurface(surf)

  # var key: uint32 
  # if getColorKey(surf, addr key) == 0:
  #   result = createRGBSurface(SWSURFACE,
  #     w, h, fmt.BitsPerPixel.cint,
  #     fmt.Rmask, fmt.Gmask, fmt.Bmask, fmt.Amask)
  #   discard SDLCall(setColorKey(surf, 1, key))
  # else:
  #   result = createRGBSurface(SWSURFACE,
  #     w, h, fmt.BitsPerPixel.cint,
  #     fmt.Rmask, fmt.Gmask, fmt.Bmask, 0)
