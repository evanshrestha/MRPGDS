#[
    Created: Jan 8, 2019 [16:06]

    Purpose: TexturePtr Wrapper, primarily need texture size and default texture
]#

import ../util/logger

import os, ospaths, terminal

import sdl2

#TYPE DECL
type
    STexture* = tuple
        texptr: TexturePtr
        width: cint
        height: cint

#GLOBAL CONSTS
#FUNC DECL
proc createTexture*(path: string; renderer: RendererPtr): STexture
#TODO: createTexture from section

#NOTE: is this best way for a defualt texture
proc loadTextureOrDefault(surf: Surfaceptr, renderer: RendererPtr): TexturePtr
proc getOrLoadDefaultTexture(renderer: RendererPtr): TexturePtr

#GLOBAL FIELDS
var default: TexturePtr;

#FUNC IMPL
proc createTexture(path: string; renderer: RendererPtr): STexture =
    let surf = if path.isAbsolute: loadBMP(path) else: loadBMP(joinPath(getAppDir(), "assets", path))
    if surf == nil: LOG(ERROR, "failed to find file "&path)
    result = (loadTextureOrDefault(surf, renderer), surf.w, surf.h)

proc loadTextureOrDefault(surf: SurfacePtr, renderer: RendererPtr): TexturePtr =
    result = renderer.createTextureFromSurface(surf)
    if result == nil: return getOrLoadDefaultTexture(renderer)

proc getOrLoadDefaultTexture(renderer: RendererPtr): TexturePtr =
    if default == nil:
        let surf = loadBMP(joinPath(getAppDir(), "assets", "error.bmp"))
        if surf == nil: LOG(FATAL, "could not find default texture file")
        default = renderer.createTextureFromSurface(surf)
        if default == nil: LOG(FATAL, "failed to create texture from default texture file")
    return default

proc destroy*(tex: STexture) =
    tex.texptr.destroy()