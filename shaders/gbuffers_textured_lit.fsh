#version 120

varying vec2 TexCoords;

varying vec4 Color;

uniform sampler2D colortex0;
uniform sampler2D texture;

uniform float blindness;

varying vec3 Normal;
varying vec2 LightmapCoords;

in vec3 viewSpaceFragPosition;

float minBlindnessDistance = 2.5;
float maxBlindDistance = 5;

/* DRAWBUFFERS:0126 */
void main() {
    vec4 color = texture2D(texture, TexCoords) * Color;

    //Color = vec3(dot(Color, vec3(0.333f)));

    float a;

    /*if(color.a > 0) {
        a = 1;
    } else {
        a = 0;
    }*/

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        color.xyz = mix(color.xyz,vec3(0),(distanceFromCamera - minBlindnessDistance)/(maxBlindDistance - minBlindnessDistance) * blindness);
    }
    
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(Normal, 1.0);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    //gl_FragData[3] = vec4(a);
}