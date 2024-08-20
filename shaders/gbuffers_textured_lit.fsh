#version 120

varying vec2 TexCoords;

varying vec4 Color;

uniform sampler2D colortex0;
uniform sampler2D texture;

varying vec3 Normal;
varying vec2 LightmapCoords;

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
    
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(Normal, 1.0);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    //gl_FragData[3] = vec4(a);
}