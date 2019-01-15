#[
    Created: Jan 7, 2019 [13:08]

    Purpose: rendition interface
]#

import texture

import sdl2

#TYPE DECL

#GLOBAL CONSTS

#FUNC DECL

#GLOBAL FIELDS
var surface: SurfacePtr;
var renderer: RendererPtr;

#FUNC IMPL
proc render*(tex: STexture; x, y, w, h: cint) =
    let r = rect(x, y, w, h)
    renderer.copy(tex.texptr, nil, r.unsafeAddr)

proc render*(tex: STexture; r: Rect) =
    renderer.copy(tex.texptr, nil, r.unsafeAddr)

proc render*(tex: STexture; r: ptr Rect) =
    renderer.copy(tex.texptr, nil, r)

proc render*(tex: STexture; x, y: int) =
    render(tex, x.cint, y.cint, tex.width, tex.height)
    
proc init*(window: WindowPtr) =
    surface = window.getSurface
    renderer = window.createRenderer(-1, Renderer_Accelerated)

proc destroy*() =
    destroy surface
    destroy renderer

proc setSurface*(surf: SurfacePtr) = 
    surface = surf

proc setRenderer*(rend: RendererPtr) =
    renderer = rend

proc clear*() = 
    clear renderer

proc setClearColor*(c: Color) = 
    renderer.setDrawColor(c);

proc present*() = 
    present renderer