#version 120

varying vec2 TexCoords;

varying vec4 Color;

varying vec3 Normal;
varying vec2 LightmapCoords;

void main() {
    gl_Position = ftransform();
    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    TexCoords = gl_MultiTexCoord0.st;
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}