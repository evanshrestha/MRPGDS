#[
    Created: Jan 7, 2019 [13:08]

    Purpose: rendition interface
]#

import terminal, os
import nim_tiled, sdl2/sdl, opengl, glm

import
    shader,
    ../level,
    ../camera,
    ../scene,
    ../entity,
    ../util/misc,
    ../util/logger

#TYPE DECL

#GLOBAL CONSTS
var Quad: tuple[VBO, EBO, VAO: GLuint, INDICES: array[6, GLuint], VERTICES: array[4, Vec3f]]
Quad.VERTICES = [
    vec3f(0, 1, 0),
    vec3f(0, 0, 0),
    vec3f(1, 0, 0),
    vec3f(1, 1, 0)
]
Quad.INDICES = [0.GLuint, 1, 2, 0, 2, 3]

var defaultShader: Program

#GLOBAL VARS
var surface: Surface
var renderer: Renderer

var width, height: cint

#FUNC DECL
proc drawQuad*(x, y, w, h, angle: float = 0.0; color: var Vec4f)
proc render*(scene: Scene)

#FUNC IMPL
proc init*(window: Window) =
    surface = getWindowSurface(window)
    renderer = window.createRenderer(-1, Renderer_Accelerated)
    getWindowSize(window, addr width, addr height)

    glClearColor(0, 0.4, 0.4, 1.0)
    #glViewport(0, 0, width, height)

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
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * Quad.INDICES.len, addr Quad.INDICES, GL_STATIC_DRAW)

    glVertexAttribPointer(0, 3, cGL_FLOAT, GL_FALSE, sizeof(Vec3f), nil)
    glEnableVertexAttribArray(0)

proc render*(scene: Scene) =
    defaultShader.use()
    var proj = scene.camera.projection()
    var view = scene.camera.view()
    discard defaultShader.setUniformMat4v("uProj", false, caddr(proj))
    discard defaultShader.setUniformMat4v("uView", false, caddr(view))

proc drawQuad(x, y, w, h, angle: float; color: var Vec4f) =
    # perform transforms on unit mat4
    var model = mat4f(1)
    model = translate(model, vec3f(x, y, 0))
    model = translate(model, vec3f(w * 0.5, h * 0.5, 0))
    model = rotate(model, angle, 0, 0, 1)
    model = translate(model, vec3f(-w * 0.5, -h * 0.5, 0))
    model = scale(model, vec3f(w, h, 1))

    discard defaultShader.setUniformMat4v("uModel", false, caddr(model))

    discard defaultShader.setUniform4v("uQuadColor", caddr(color))
    
    glBindVertexArray(Quad.VAO)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, Quad.EBO)

    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nil)


proc terminate*() =
    destroy(defaultShader)
    
    glDeleteBuffers(1, addr Quad.VBO)
    glDeleteBuffers(1, addr Quad.EBO)
    glDeleteVertexArrays(1, addr Quad.VAO)
    
    freeSurface surface
    destroyRenderer renderer

proc setSurface*(surf: Surface) = 
    surface = surf

proc setRenderer*(rend: Renderer) =
    renderer = rend

proc getRenderer*(): Renderer =
    return renderer
    
proc clear*() = 
    #discard renderClear(renderer)
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)


proc setClearColor*(c: Color) = 
    discard setRenderDrawColor(renderer, c)

proc present*() = 
    renderPresent(renderer)

proc screenwidth*(): cint {.inline.} = width
proc screenheight*(): cint {.inline.} = height