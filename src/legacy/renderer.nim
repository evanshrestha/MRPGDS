#[
    Created: Jan 7, 2019 [13:08]

    Purpose: rendition interface
]#

import terminal, os
import nim_tiled, sdl2/sdl, opengl, glm

import
    texture,
    shader,
    ../level,
    ../camera,
    ../scene,
    ../entity,
    ../util/misc,
    ../util/logger

#TYPE DECL

#GLOBAL CONSTS
var Quad: tuple[VBO, EBO, VAO: GLuint, INDICES: array[6, GLbyte], VERTICES: array[4, Vec3f]]
Quad.VERTICES = [
    vec3f(-1, 1, 1),
    vec3f(-1, -1, 1),
    vec3f(1, -1, 1),
    vec3f(1, 1, 1)
]
Quad.INDICES = [0.GLbyte, 1, 2, 0, 2, 3]
const VoidZero = cast[pointer](0)

var defaultShader: Program

#GLOBAL VARS
var surface: Surface
var renderer: Renderer

var width, height: cint

#FUNC DECL
proc drawQuad*(x, y, width, height, angle = 0.0, scale: float = 1; color: var Vec4f)
proc render*(scene: Scene)

#FUNC IMPL
proc init*(window: Window) =
    surface = getWindowSurface(window)
    renderer = window.createRenderer(-1, Renderer_Accelerated)
    getWindowSize(window, addr width, addr height)

    glClearColor(0, 0.4, 0.4, 1.0)
    glViewport(0, 0, width, height)

    defaultShader = createShaderProgram("res"/"shaders"/"default.shader")
    # TODO: load these when creating shader
    discard defaultShader.loadUniform("uModel")
    discard defaultShader.loadUniform("uView")
    discard defaultShader.loadUniform("uProj")
    discard defaultShader.loadUniform("uQuadColor")
    
    glCreateVertexArrays(1, addr Quad.VAO)
    glBindVertexArray(Quad.VAO)

    glCreateBuffers(2, addr Quad[0])
    glBindBuffer(GL_ARRAY_BUFFER, Quad.VBO)
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vec3f) * Quad.VERTICES.len, addr Quad.VERTICES, GL_STATIC_DRAW)

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, Quad.EBO)
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(uint8) * Quad.INDICES.len, addr Quad.EBO, GL_STATIC_DRAW)

    glVertexAttribPointer(0, 3, cGL_FLOAT, GL_FALSE, sizeof(Vec3f), VoidZero)
    glEnableVertexAttribArray(0)

proc render*(scene: Scene) =
    var proj = scene.camera.projection()
    var view = scene.camera.view()
    discard defaultShader.setUniformMat4v("uProj", false, caddr(proj))
    discard defaultShader.setUniformMat4v("uProj", false, caddr(view))

proc drawQuad(x, y, width, height, angle, scale: float; color: var Vec4f) =
    # perform transforms on unit mat4
    var umat = mat4f(1)
    var rot = rotate(umat, angle, 0, 0, 1)
    var trans = translate(umat, vec3f(x, y, 0))
    var scale = scale(umat, vec3f(width * scale, height * scale, 1))
    var model = rot * scale * trans
    discard defaultShader.setUniformMat4v("uModel", false, caddr(model))
    
    discard defaultShader.setUniform4v("uQuadColor", caddr(color))
    
    glBindVertexArray(Quad.VAO)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, Quad.EBO)

    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, VoidZero)


proc render*(tex: Texture; srcrect, distrect: Rect) =
    discard renderCopy(renderer, tex, unsafeAddr(srcrect), unsafeAddr(distrect))

proc render*(tex: Texture; x, y, w, h: cint) =
    var r: Rect = rect(x, y, w, h)
    discard renderCopy(renderer, tex, nil, addr(r))

proc render*(tex: Texture; r: Rect) =
    discard renderCopy(renderer, tex, nil, unsafeAddr(r))

proc render*(stex: STexture, dst: Rect) =
    discard renderCopy(renderer, stex.wtex.src, stex.srcrectptr(), unsafeAddr(dst))

proc render*(stex: STexture, x, y: cint) =
    var r: Rect = rect(x, y, stex.srcrect.w, stex.srcrect.h)
    discard renderCopy(renderer, stex.wtex.src, stex.srcrectptr(), addr(r))
    
proc render*(stex: STexture, x, y: float, cam: Camera, fixed:bool = true) =
    var r: Rect =
        if fixed:
            rect(x.int, y.int, stex.srcrect.w, stex.srcrect.h)
        else:
            rect(x.int - int(cam.offsetPos.x), y.int - int(cam.offsetPos.y), stex.srcrect.w, stex.srcrect.h)
    discard renderCopy(renderer, stex.wtex.src, stex.srcrectptr(), addr(r))

proc render*(stex: STexture, x, y: NormalFloat, cam: Camera, fixed:bool = true) =
    var r: Rect =
        if fixed:
            rect(x.val.int, y.val.int, stex.srcrect.w, stex.srcrect.h)
        else:
            rect(x.val.int - int(cam.offsetPos.x), y.val.int - int(cam.offsetPos.y), stex.srcrect.w, stex.srcrect.h)
    discard renderCopy(renderer, stex.wtex.src, stex.srcrectptr(), addr(r))

# proc render(level: Level, cam: Camera) =
#     for layer in level.map.layers:
#         for y in 0..<layer.height:
#             let ys = int(cam.y.int / level.tileHS)
#             let ye = int((cam.y.int + cam.h) / level.tileHS)
#             if y < ys or y > ye: continue

#             for x in 0..<layer.width:
#                 let xs = int(cam.x.int / level.tileWS)
#                 let xe = int((cam.x.int + cam.w) / level.tileWS)
#                 if x < xs or x > xe: continue

#                 let tileid = layer.tiles[x + y * layer.width]
#                 if tileid <= 0: continue
                
#                 let region = level.map.tilesets[0].regions[tileid-1]
#                 let xo = x * level.tileWS - cam.pos.x.int
#                 let yo = y * level.tileHS - cam.pos.y.int
#                 var sregion = sdl.Rect(x: region.x, y: region.y, w: region.width, h: region.height)
#                 var dregion = sdl.Rect(x: xo, y: yo, w: level.tileWS, h: level.tileHS)
#                 level.texture(0).src.render(sregion, dregion)

# proc render*(scene: Scene) = 
#     render(scene.level, scene.mainCamera)
#     render(scene.player.sprite, (scene.player.x), (scene.player.y), scene.mainCamera, false)

proc terminate*() =
    freeSurface surface
    destroyRenderer renderer

proc setSurface*(surf: Surface) = 
    surface = surf

proc setRenderer*(rend: Renderer) =
    renderer = rend

proc getRenderer*(): Renderer =
    return renderer
    
proc clear*() = 
    discard renderClear(renderer)
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)


proc setClearColor*(c: Color) = 
    discard setRenderDrawColor(renderer, c)

proc present*() = 
    renderPresent(renderer)

proc screenwidth*(): cint {.inline.} = width
proc screenheight*(): cint {.inline.} = height