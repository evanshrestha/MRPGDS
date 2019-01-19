#[
    Created: Jan 7, 2019 [13:08]

    Purpose: rendition interface
]#

import sdl2

#TYPE DECL

#GLOBAL CONSTS

#FUNC DECL

#GLOBAL FIELDS
var surface: SurfacePtr;
var renderer: RendererPtr;

#FUNC IMPL
proc render*(tex: TexturePtr; srcrect, distrect: Rect) =
    renderer.copy(tex, unsafeAddr(srcrect), unsafeAddr(distrect))

#TODO: speed test these render functions
proc render*(tex: TexturePtr; x, y, w, h: cint) =
    let r = rect(x, y, w, h)
    renderer.copy(tex, nil, unsafeAddr(r))

proc render*(tex: TexturePtr; r: Rect) =
    renderer.copy(tex, nil, unsafeAddr(r))

proc render*(tex: TexturePtr; r: ptr Rect) =
    renderer.copy(tex, nil, r)

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

proc getRenderer*(): RendererPtr =
    return renderer
    
proc clear*() = 
    clear renderer

proc setClearColor*(c: Color) = 
    renderer.setDrawColor(c);

proc present*() = 
    present renderer