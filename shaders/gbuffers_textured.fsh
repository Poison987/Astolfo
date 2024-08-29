#version 460 compatibility

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D lightmap;
uniform sampler2D texture;

uniform int heldItemId;

uniform float blindness;

in vec3 viewSpaceFragPosition;

float minBlindnessDistance = 2.5;
float maxBlindDistance = 5;

/* DRAWBUFFERS:0126 */

void main() {
    vec4 albedo = texture2D(texture, TexCoords) * Color;
    
    float a;

    /*if(albedo.a > 0 && heldItemId == 1) {
        a = 1;
    } else {
        a = 0;
    }*/

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        albedo.xyz = mix(albedo.xyz,vec3(0),(distanceFromCamera - minBlindnessDistance)/(maxBlindDistance - minBlindnessDistance) * blindness);
    }
    
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5 + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    //gl_FragData[3] = vec4(a);
}