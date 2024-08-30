#version 460 compatibility

varying vec2 TexCoords;
varying vec3 Normal;

uniform sampler2D colortex0;

uniform sampler2D noises;

void main() {
    vec3 Color = texture2D(colortex0, TexCoords).rgb;

    //Color = vec3(dot(Color, vec3(0.333f)));

    float cloudNoise = texture2D(colortex0, TexCoords * 55f).g;

    gl_FragData[0] = vec4(Color, 1.0f);
}