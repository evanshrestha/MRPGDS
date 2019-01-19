#[
    Created: Jan 8, 2019 [16:06]

    Purpose: TexturePtr Wrapper, primarily need texture size and default texture
]#

import ../util/logger
import renderer

import os, ospaths, terminal

import sdl2

#TYPE DECL
type
    STexture* = tuple
        wtex: WTexture
        srcrect: Rect

    WTexture* = tuple
        texptr: TexturePtr
        width: cint
        height: cint


#GLOBAL CONSTS
#FUNC DECL
proc loadTexture*(path: string; renderer: RendererPtr): WTexture

proc createSubTexture*(texture: WTexture, src: Rect): STexture
proc createSubTexture*(texture: WTexture, x, y, w, h: cint): STexture

#NOTE: is this best way for a defualt texture
proc createTextureOrGetDefault(surf: Surfaceptr, renderer: RendererPtr): WTexture
proc getOrLoadDefaultTexture(renderer: RendererPtr): WTexture

proc render*(tex: STexture; x, y: cint)
proc render*(tex: STexture; x, y, w, h: cint)
proc render*(tex: STexture; dst: Rect)

proc getPtr(tex: STexture): TexturePtr

proc destroy*(tex: WTexture)
proc destroy*(tex: STexture)

#GLOBAL FIELDS
var default: WTexture;

#FUNC IMPL
proc loadTexture(path: string; renderer: RendererPtr): WTexture =
    let surf = 
        if path.isAbsolute: loadBMP(path) 
        else: loadBMP(joinPath(getAppDir(), "assets", path))
    if surf == nil: 
        LOG(ERROR, "failed to find \""&path&"\" using default texture")
    
    result = createTextureOrGetDefault(surf, renderer)

proc createSubTexture*(texture: WTexture, src: Rect): STexture = 
    return (texture, src)

proc createSubTexture*(texture: WTexture, x, y, w, h: cint): STexture = 
    return (texture, rect(x, y, w, h))

proc createTextureOrGetDefault(surf: SurfacePtr, renderer: RendererPtr): WTexture =
    if surf != nil:
        result = (renderer.createTextureFromSurface(surf), surf.w, surf.h)
        if result.texptr == nil: return getOrLoadDefaultTexture(renderer)
    else:
        return getOrLoadDefaultTexture(renderer)

proc getOrLoadDefaultTexture(renderer: RendererPtr): WTexture =
    if default.texptr == nil:
        let surf = loadBMP(joinPath(getAppDir(), "assets", "error.bmp"))
        if surf == nil: LOG(FATAL, "could not find default texture file")
        default = (renderer.createTextureFromSurface(surf), surf.w, surf.h)
        if default.texptr == nil: LOG(FATAL, "failed to create texture from default texture file")
    return default

proc render*(tex: STexture; x, y: cint) =
    let dst = rect(x, y, tex.srcrect.w, tex.srcrect.h)
    tex.getPtr.render(tex.srcrect, dst)

proc render*(tex: STexture; x, y, w, h: cint) =
    let dst = rect(x, y, w, h)
    tex.getPtr.render(tex.srcrect, dst)

proc render*(tex: STexture; dst: Rect) =
    tex.getPtr.render(tex.srcrect, dst)

proc getPtr(tex: STexture): TexturePtr =
    return tex.wtex.texptr

proc destroy*(tex: WTexture) =
    tex.texptr.destroy()

proc destroy*(tex: STexture) =
    tex.wtex.destroy()