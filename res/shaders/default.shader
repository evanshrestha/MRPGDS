#shader vertex
#version 330 core
layout (location = 0) in vec3 vPos;

uniform mat4 uModel;
uniform mat4 uView;
uniform mat4 uProj;
uniform vec4 uQuadColor;

void main() {
  mat4 mvp = uProj * uView * uModel;
  gl_Position = uProj * uView * uModel * vec4(vPos, 1.0);
}

#shader fragment
#version 330 core
out vec4 color;

in vec4 gl_FragCoord;

uniform mat4 uModel;
uniform mat4 uView;
uniform mat4 uProj;
uniform vec4 uQuadColor;


void main() {
  color = uQuadColor;
}