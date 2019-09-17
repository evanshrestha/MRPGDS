import strutils, os, tables, strformat
import opengl, glm

#TODO: shadertype enum

type
  Shader* = GLuint
  Program* = object
    id: GLuint
    uniforms: Table[string, GLint]


proc `id`*(program: Program): Gluint {.inline.} = program.id
proc use*(program: Program) {.inline.} = glUseProgram(program.id)
proc destroy*(program: Program) {.inline.} = glDeleteProgram(program.id)

proc loadUniform*(program: var Program, name: string): GLint =
  let loc = glGetUniformLocation(program.id, name)
  when defined debug:
    if loc < 0: echo &"[SHADER] uniform ({name}) not found"
  program.uniforms.mgetOrPut(name, loc)

proc getUniform*(program: Program, name: string): GLint =
  glGetUniformLocation(program.id, name)

# TODO: uniform lists
# TODO: please god a macro would be sick nasty here 🙏
proc setUniform1*[T](program: Program, location: GLint, args: varargs[T]): bool
proc setUniform2*[T](program: Program, location: GLint, args: varargs[T]): bool
proc setUniform3*[T](program: Program, location: GLint, args: varargs[T]): bool = discard
proc setUniform4*[T](program: Program, location: GLint, args: varargs[T]): bool = discard
proc setUniform3v*[T](program: Program, location: GLint, val: ptr T): bool
proc setUniform4v*[T](program: Program, location: GLint, val: ptr T): bool
proc setUniformMat4v*[T](program: Program, location: GLint, trans: bool, mat: ptr T): bool
proc setUniform1*[T](program: Program, name: string, args: varargs[T]): bool = setUniform1[T](program, program.uniforms[name], args)
proc setUniform2*[T](program: Program, name: string, args: varargs[T]): bool = setUniform2[T](program, program.uniforms[name], args)
proc setUniform3*[T](program: Program, name: string, args: varargs[T]): bool = setUniform3[T](program, program.uniforms[name], args)
proc setUniform4*[T](program: Program, name: string, args: varargs[T]): bool = setUniform1[T](program, program.uniforms[name], args)
proc setUniform3v*[T](program: Program, name: string, val: ptr T): bool = setUniform3v[T](program, program.uniforms[name], val)
proc setUniform4v*[T](program: Program, name: string, val: ptr T): bool = setUniform4v[T](program, program.uniforms[name], val)
proc setUniformMat4v*[T](program: Program, name: string, trans: bool, mat: ptr T): bool = setUniformMat4v[T](program, program.uniforms[name], trans, mat)
# proc setUniform1*[T](program: var Program, name: string, args: varargs[T]): bool = setUniform1[T](program, loadUniform(name), args)
# proc setUniform2*[T](program: var Program, name: string, args: varargs[T]): bool = setUniform2[T](program, loadUniform(name), args)
# proc setUniform3*[T](program: var Program, name: string, args: varargs[T]): bool = setUniform3[T](program, loadUniform(name), args)
# proc setUniform4*[T](program: var Program, name: string, args: varargs[T]): bool = setUniform4[T](program, loadUniform(name), args)

proc setUniform1*[T](program: Program, location: GLint, args: varargs[T]): bool =
  result = true
  if args.len < 1 or location < 0: return false
  use(program)
  when T is int32: glUniform1i(location, args[0])
  elif T is uint32: glUniform1ui(location, args[0])
  elif T is float32: glUniform1f(location, args[0])
  elif T is float64: glUniform1d(location, args[0])

proc setUniform2*[T](program: Program, location: GLint, args: varargs[T]): bool =
  result = true
  if args.len < 2 or location < 0: return false
  use(program)
  when T is int32: glUniform2i(location, args[0], args[1])
  elif T is uint32: glUniform2ui(location, args[0], args[1])
  elif T is float32: glUniform2f(location, args[0], args[1])
  elif T is float64: glUniform2d(location, args[0], args[1])

proc setUniform3v*[T](program: Program, location: GLint, val: ptr T): bool =
  result = true
  if location < 0: return false
  use(program)
  when T is int32: glUniform3iv(location, 3, val)
  elif T is uint32: glUniform3uiv(location, 3, val)
  elif T is float32: glUniform3fv(location, 3, val)
  elif T is float64: glUniform3dv(location, 3, val)

proc setUniform4v*[T](program: Program, location: GLint, val: ptr T): bool =
  result = true
  if location < 0: return false
  use(program)
  when T is int32: glUniform4iv(location, 1, val)
  elif T is uint32: glUniform4uiv(location, 1, val)
  elif T is float32: glUniform4fv(location, 1, val)
  elif T is float64: glUniform4dv(location, 1, val)

proc setUniformMat4v*[T](program: Program, location: GLint, trans: bool, mat: ptr T): bool =
  result = true
  if location < 0: return false
  use(program)
  when T is int32: glUniformMatrix4iv(location, 1, trans, mat)
  elif T is uint32: glUniformMatrix4uiv(location, 1, trans, mat)
  elif T is float32: glUniformMatrix4fv(location, 1, trans, mat)
  elif T is float64: glUniformMatrix4dv(location, 1, trans, mat)
  

proc createShaderProgram*(path: string): Program
proc compileAndAttachShader(stype: GLenum, src: string, program: GLuint): Gluint
proc loadSource(path: string): tuple[vertexSrc, fragmentSrc: string]

proc createShaderProgram(path: string): Program =
  let (vertSrc, fragSrc) = loadSource(path)
  when defined printShaders: echo vertSrc, fragSrc
  
  result.id = glCreateProgram()
  result.uniforms = initTable[string, GLint]()

  discard compileAndAttachShader(GL_VERTEX_SHADER, vertSrc, result.id)
  discard compileAndAttachShader(GL_FRAGMENT_SHADER, fragSrc, result.id)
  glLinkProgram(result.id)
  glValidateProgram(result.id)

proc compileAndAttachShader(stype: GLenum, src: string, program: GLuint): Gluint =
  result = glCreateShader(stype)
  let cstr = allocCStringArray([src])
  glShaderSource(result, 1.GLsizei, cstr, nil)
  deallocCStringArray(cstr)
  glCompileShader(result)
  var status: GLint
  glGetShaderiv(result, GL_COMPILE_STATUS, addr status)
  if status.GL_boolean == GL_FALSE:
    when defined debug: echo "[SHADER] COMPILE STATUS: FAILED"
    var len : GLint
    glGetShaderiv(result, GL_INFO_LOG_LENGTH, addr len)
    var log = cast[ptr GLchar](alloc(len))
    glGetShaderInfoLog(result,len, addr len, log)
    echo log
    dealloc(log)
  else:
    echo "[SHADER] COMPILE STATUS: PASSED"
    glAttachShader(program, result)
    glDeleteShader(result)

proc loadSource(path: string): tuple[vertexSrc, fragmentSrc: string] =
  var shaderType: string
  let file = open(path, fmRead)
  while not endOfFile(file):
    let line = readLine(file)
    if line.startsWith("#shader vertex"): shaderType = "vertex"
    elif line.startsWith("#shader fragment"): shaderType = "fragment" 
    else:
      case shaderType
      of "vertex": result.vertexSrc &= line&"\n" 
      of "fragment": result.fragmentSrc &= line&"\n"
      else: continue 
  close(file)