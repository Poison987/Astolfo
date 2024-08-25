#version 120

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

out vec3 viewSpaceFragPosition;

void main() {
    gl_Position = ftransform();

    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

    TexCoords = gl_MultiTexCoord0.st;
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
    //LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}