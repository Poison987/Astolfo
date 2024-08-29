#version 460 compatibility

#define SHADOWS_ENABLED
#define ENTITY_SHADOWS
#define SHADOW_DIST 16 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]

varying vec2 TexCoords;
varying vec4 Color;

uniform sampler2D texture;

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

uniform int entityId;

in vec3 vaPosition;

in vec3 mc_Entity;

void main() {
    #ifndef SHADOWS_ENABLED
        discard;
    #endif

    vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;
    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);
    
    if(distanceFromCamera > SHADOW_DIST * 16) {
        discard;
    }

    #ifndef ENTITY_SHADOWS
        if(entityId == 10006 || mc_Entity.x == 10005) {
            discard;
        }
        gl_FragData[0] = texture2D(texture, TexCoords) * Color;
    #else
        gl_FragData[0] = texture2D(texture, TexCoords) * Color;
    #endif
}