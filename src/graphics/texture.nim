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
proc loadTexture*(path: string; renderer: RendererPtr): STexture
#TODO: createTexture from section

#NOTE: is this best way for a defualt texture
proc createTextureOrGetDefault(surf: Surfaceptr, renderer: RendererPtr): STexture
proc getOrLoadDefaultTexture(renderer: RendererPtr): STexture

#GLOBAL FIELDS
var default: STexture;

#FUNC IMPL
proc loadTexture(path: string; renderer: RendererPtr): STexture =
    let surf = if path.isAbsolute: loadBMP(path) else: loadBMP(joinPath(getAppDir(), "assets", path))
    if surf == nil: LOG(ERROR, "failed to find \""&path&"\" using default texture")
    result = createTextureOrGetDefault(surf, renderer)

proc createTextureOrGetDefault(surf: SurfacePtr, renderer: RendererPtr): STexture =
    if surf != nil:
        result = (renderer.createTextureFromSurface(surf), surf.w, surf.h)
        if result.texptr == nil: return getOrLoadDefaultTexture(renderer)
    else:
        return getOrLoadDefaultTexture(renderer)

proc getOrLoadDefaultTexture(renderer: RendererPtr): STexture =
    if default.texptr == nil:
        let surf = loadBMP(joinPath(getAppDir(), "assets", "error.bmp"))
        if surf == nil: LOG(FATAL, "could not find default texture file")
        default = (renderer.createTextureFromSurface(surf), surf.w, surf.h)
        if default.texptr == nil: LOG(FATAL, "failed to create texture from default texture file")
    return default

proc destroy*(tex: STexture) =
    tex.texptr.destroy()