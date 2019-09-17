import os
import sdl2/sdl, opengl, glm, graphics/shader

var pos = WindowPosUndefined
var width = 500
var height = 500
var flags = WINDOW_RESIZABLE or WINDOW_OPENGL

discard sdl.init(INIT_VIDEO)

discard glSetAttribute(GL_CONTEXT_MAJOR_VERSION, 3)
discard glSetAttribute(GL_CONTEXT_MINOR_VERSION, 2)
var major, minor: cint
discard glGetAttribute(GL_CONTEXT_MAJOR_VERSION, addr major)
discard glGetAttribute(GL_CONTEXT_MINOR_VERSION, addr minor)
echo major, minor

discard glSetSwapInterval(0)

var window = createWindow("test", pos, pos, width, height, flags.uint32)
assert window != nil
#var renderer = createRenderer(window, -1, RENDERER_ACCELERATED)

var context = glCreateContext(window)
loadExtensions()
glClearColor(0, 0.5, 0.5, 1) #must call an opengl func or opengl doesn't work


# INIT DATA
var Quad: tuple[VBO, EBO, VAO: GLuint, INDICES: array[6, GLuint], VERTICES: array[4, Vec3f]]
Quad.VERTICES = [
    vec3f(0, 1, 0),
    vec3f(0, 0, 0),
    vec3f(1, 0, 0),
    vec3f(1, 1, 0)
]
Quad.INDICES = [0.GLuint, 1, 2, 0, 3, 2]
const VoidZero = cast[pointer](0)

var defaultShader = createShaderProgram("res"/"shaders"/"default.shader")
# TODO: load these when creating shader
discard defaultShader.loadUniform("uModel")
discard defaultShader.loadUniform("uView")
discard defaultShader.loadUniform("uProj")
discard defaultShader.loadUniform("uQuadColor")

glCreateVertexArrays(1, addr Quad.VAO)
glBindVertexArray(Quad.VAO)

glCreateBuffers(1, addr Quad.VBO)
glBindBuffer(GL_ARRAY_BUFFER, Quad.VBO)
glBufferData(GL_ARRAY_BUFFER, sizeof(Vec3f) * Quad.VERTICES.len, addr Quad.VERTICES, GL_STATIC_DRAW)

glCreateBuffers(1, addr Quad.EBO)
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, Quad.EBO)
glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * Quad.INDICES.len, addr Quad.INDICES, GL_STATIC_DRAW)

glVertexAttribPointer(0, 3, cGL_FLOAT, GL_FALSE, sizeof(Vec3f), nil)
glEnableVertexAttribArray(0)

block mainloop:
  var event: Event

  var x = 100'f32
  var y = 100'f32
  var w = 100'f32
  var h = 100'f32
  var scale = 1'f32
  var angle = 0'f32
  var color = vec4f(0.6, 0.4, 0.4, 1)

  var proj = ortho(-2'f32, 2'f32, -2'f32, 2'f32, -100, 100)
  #var proj = ortho(0.0'f32, width.float, height.float, 0, -100, 100)
  var view = lookAt(vec3f(0,0,-1), vec3f(0,0,0), vec3f(0,1,0))

  while true:
    while pollEvent(addr event) != 0:
      case event.kind
      of Quit: break mainloop
      else: discard
    

    #update

    #render
    glClear(GL_COLOR_BUFFER_BIT)
    defaultShader.use()
    discard defaultShader.setUniformMat4v("uProj", false, caddr(proj))
    discard defaultShader.setUniformMat4v("uView", false, caddr(view))

    # perform transforms on unit mat4
    var model = mat4f(1)
    #model = rotate(model, angle, 0, 0, 1)
    #model = translate(model, vec3f(-x, y, 0))
    #model = scale(model, vec3f(w * scale, h * scale, 1))
    discard defaultShader.setUniformMat4v("uModel", false, caddr(model))
    
    # var loc = glGetUniformLocation(defaultShader.id, "uQuadColor")
    # glUniform4fv(loc, 1, caddr(color))
    discard defaultShader.setUniform4v("uQuadColor", caddr(color))
    
    glBindVertexArray(Quad.VAO)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, Quad.EBO)

    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nil)

    glSwapWindow(window)


glDeleteContext(context)
destroyWIndow(window)
sdl.quit()