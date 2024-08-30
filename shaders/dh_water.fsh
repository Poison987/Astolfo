#version 460 compatibility

#define WATER_REFRACTION
#define WATER_FOAM

varying vec2 TexCoords;
varying vec4 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D colortex0;

uniform sampler2D depthtex1;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform float viewWidth;
uniform float viewHeight;

uniform bool isBiomeEnd;

/* DRAWBUFFERS:0125 */

void main() {
    //vec4 albedo = texture2D(texture, TexCoords) * Color;

    float isWater = Normal.w;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth,viewHeight);

    vec4 depth = texture2D(depthtex1, TexCoords);
    float depth2 = texture(depthtex0,texCoord).r;

    float discardDepth = 1f;

    if(depth2 != discardDepth) {
        discard;
    }

    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    
    vec4 noiseMap = texture2D(noise, TexCoords + (sin(TexCoords.xy*32f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);
    vec4 noiseMap2 = texture2D(noise, TexCoords - (sin(TexCoords.xy*16f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);

    vec4 albedo = texture2D(texture, TexCoords) * Color;

    albedo.a = 0.5f;
    
    vec4 finalNoise = mix(noiseMap,noiseMap2,0.5f);
    
    if(isWaterBlock == 1) {
        albedo.xyz = mix(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f),0.5f);
        albedo.a = 0.5f;
    }

    /*if(isBiomeEnd) {
        albedo.xyz = mix(albedo.xyz, vec3(dot(albedo.xyz, vec3(0.333))),0.5);
    } /*else {
        albedo.xyz = mix(albedo.xyz,lightColor,0.125f);
    }*/

    //vec4 normalDefine = vec4(noiseMap.xyz * 0.5 + 0.5f, 1.0f);
    //normalDefine = normalDefine + noiseMap;

    vec2 TexCoords2 = texCoord;
    //float Depth = texture2D(depthtex0, texCoord).r;
    //float Depth2 = texture2D(depthtex1, texCoord).r;
    vec3 Albedo;
    float isBlockWater = float(Color.z > Color.y && Color.z > Color.x);
    if(depth.r != depth2 && isBlockWater > 0) {
        #ifdef WATER_REFRACTION
            vec4 noiseMap = texture2D(noise, texCoord + sin(texCoord.y*32f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 noiseMap2 = texture2D(noise, texCoord - sin(texCoord.y*16f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 finalNoise = mix(noiseMap,noiseMap2,0.5f);

            TexCoords2 += finalNoise.xy * vec2(0.125f);
        #endif

        Albedo = pow(mix(texture2D(colortex0, TexCoords2).rgb,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (depth.r - depth2)) * 0.5,0,1)), vec3(2.2f));
        #ifdef WATER_FOAM
            if(abs(depth.r - depth2) < 0.0005f) {
                Albedo = mix(Albedo, vec3(1.0f), clamp(1 - abs(depth.r - depth2),0f,1));
            }
        #endif
        albedo.xyz = Albedo;
        albedo.a = mix(0.5f, 0.5f, clamp(1 - abs(depth.r - depth2),0f,1));
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = Normal;
    gl_FragData[2] = vec4(LightmapCoords.x + Normal.x, LightmapCoords.x + noiseMap.y, LightmapCoords.y + noiseMap.z, 1.0f);
    if(depth != depth2 && isBlockWater > 0) {
        gl_FragData[3] = vec4(1.0);
    } else {
        gl_FragData[3] = vec4(0.0);
    }
}