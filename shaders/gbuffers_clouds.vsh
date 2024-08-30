#version 460 compatibility

varying vec2 TexCoords;
varying vec3 Normal;

void main() {
    gl_Position = ftransform();
    TexCoords = gl_MultiTexCoord0.st;
    Normal = gl_Normal;
}