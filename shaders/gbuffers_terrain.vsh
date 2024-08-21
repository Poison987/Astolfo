#version 120

in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

out vec3 viewSpaceFragPosition;

void main() {
    gl_Position = ftransform();
        
    TexCoords = gl_MultiTexCoord0.st;

    viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
}