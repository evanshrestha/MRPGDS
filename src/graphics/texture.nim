#[
    Created: Jan 8, 2019 [16:06]

    Purpose: TexturePtr Wrapper, primarily need texture size and default texture
]#

import
    ../util/logger,
    ../util/misc,
    ../util/filesys

import 
    os,
    terminal

import
    sdl2/sdl,
    sdl2/sdl_image

#TYPE DECL
type
    STexture* = ref object
        wtex: WTexture
        srcrect: Rect

    WTexture* = ref object
        src: Texture
        width: cint
        height: cint

#GLOBAL CONSTS
#FUNC DECL
proc loadTexture*(path: string; renderer: Renderer): WTexture

proc createSubTexture*(texture: WTexture, src: Rect): STexture
proc createSubTexture*(texture: WTexture, x, y, w, h: cint): STexture

#NOTE: is this best way for a defualt texture
proc createTextureOrGetDefault(surf: Surface, renderer: Renderer): WTexture
proc getOrLoadDefaultTexture*(renderer: Renderer): WTexture

proc destroy*(tex: WTexture)
proc destroy*(tex: STexture)

#GLOBAL FIELDS
var default: WTexture = WTexture(src:nil);

#FUNC IMPL
proc loadTexture(path: string; renderer: Renderer): WTexture =
    let abspath = path.toAbsDir()
    let ext = abspath.splitFile.ext
    var surf: Surface = 
        if ext == ".bmp": loadBMP(abspath)
        elif ext == ".png" or
             ext == ".png" or 
             ext == ".jpg" or 
             ext == ".jpeg" or 
             ext == ".jpe": load(abspath)
        else: nil
        
    if surf == nil:
        LOG(ERROR, "failed to load \""&abspath&"\" using default texture")
    result = createTextureOrGetDefault(surf, renderer)

proc createSubTexture*(texture: WTexture, src: Rect): STexture = 
    return STexture(wtex: texture, srcrect: src)

proc createSubTexture*(texture: WTexture, x, y, w, h: cint): STexture = 
    return STexture(wtex: texture, srcrect: rect(x, y, w, h))

proc createTextureOrGetDefault(surf: Surface, renderer: Renderer): WTexture =
    if surf != nil:
        result = WTexture(src: renderer.createTextureFromSurface(surf), width: surf.w, height: surf.h)
        if result.src == nil: return getOrLoadDefaultTexture(renderer)
    else:
        return getOrLoadDefaultTexture(renderer)

proc getOrLoadDefaultTexture(renderer: Renderer): WTexture =
    if default.src == nil:
        let surf = loadBMP(joinPath(getAppDir(), "assets", "error.bmp"))
        if surf == nil: LOG(FATAL, "could not find default texture file")
        default = WTexture(src: renderer.createTextureFromSurface(surf), width: surf.w, height: surf.h)
        if default.src == nil: LOG(FATAL, "failed to create texture from default texture file")
    return default

proc srcrect*(tex: STexture): Rect {.inline.} = tex.srcrect
proc srcrectptr*(tex: STexture): ptr Rect {.inline.} = addr(tex.srcrect)
proc wtex*(tex: STexture): WTexture {.inline.} = tex.wtex

proc src*(tex: WTexture): Texture {.inline.} = tex.src
proc width*(tex: WTexture): int {.inline.} = tex.width
proc height*(tex: WTexture): int {.inline.} = tex.height

proc destroy*(tex: WTexture) =
    destroyTexture(tex.src)

proc destroy*(tex: STexture) =
    tex.wtex.destroy()