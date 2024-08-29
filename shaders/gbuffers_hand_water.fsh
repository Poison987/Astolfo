#version 460 compatibility

#include "program/underwater.glsl"

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D texture;

uniform sampler2D noise;

uniform int heldItemId;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

/* DRAWBUFFERS:0124 */

void main() {
    vec4 noiseMap3 = texture2D(noise, TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f);
    
    //vec4 albedo = vec4(isInWater(texture, Color.xyz, TexCoords, noiseMap3.xy, 0.125), texture2D(texture, TexCoords + noiseMap3.xy).a);
    
    vec4 albedo = texture2D(texture, TexCoords) * Color;

    float a;

    if(albedo.a > 0 && heldItemId == 1) {
        a = 1;
    } else {
        a = 0;
    }
    
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5 + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(a);
}