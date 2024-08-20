#version 120

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

attribute vec4 mc_Entity;

/* DRAWBUFFERS:0123*/

void main() {
    vec3 lightColor = texture(lightmap, LightmapCoords).rgb;
    vec4 albedo = texture2D(gtexture, TexCoords) * Color;
    albedo.xyz = pow(albedo.xyz, vec3(2.2));
    //albedo.rgb *= lightColor;
    
    if(albedo.a < .1) {
        discard;
    }

    if(mc_Entity.x < 10005 || mc_Entity.x > 10010) {
        lightColor = vec3(0);
    }

    albedo.xyz = pow(albedo.xyz, vec3(1/2.2));

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5 + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0f, 1.0f);
    //gl_FragData[3] = vec4(LightmapCoords, 0.0f, 1.0f);
}