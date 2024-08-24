#version 460 compatibility
#include "lib/commonFunctions.glsl"

#define DISTANT_HORIZONS
#define DAY_R 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_B 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define NIGHT_R 0.9f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_B 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define SUNSET_R 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define FOG_DAY_R 0.8f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_DAY_G 0.9f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_DAY_B 1.0f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_DAY_DIST_MIN 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define FOG_DAY_DIST_MAX 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define FOG_NIGHT_R 0.0f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_NIGHT_G 0.1f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_NIGHT_B 0.2f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_NIGHT_DIST_MIN 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define FOG_NIGHT_DIST_MAX 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define FOG_SUNSET_R 1.0f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_SUNSET_G 0.5f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_SUNSET_B 0.0f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f]
#define FOG_SUNSET_DIST_MIN 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define FOG_SUNSET_DIST_MAX 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 fogColor;

uniform sampler2D noises;

uniform sampler2D colortex0;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse;

uniform float blindness;

uniform bool isBiomeEnd;

uniform vec3 cameraPosition;

/* DRAWBUFFERS:0265 */
layout(location = 0) out vec4 outColor0;
layout(location = 1) out vec4 outColor2;
layout(location = 3) out vec4 isWater;

in vec4 blockColor;
in vec2 lightmapCoords;
in vec3 viewSpaceFragPosition;

in vec3 playerPos;

in float isWaterBlock;

vec3 aces(vec3 x) {
  float a = 2.51;
  float b = 0.03;
  float c = 2.43;
  float d = 0.59;
  float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 screenToView(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    return tmp.xyz / tmp.w;
}

vec3 screenToWorld(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    tmp = gbufferModelViewInverse * tmp;
    return tmp.xyz / tmp.w;
}

float Noise3D(vec3 p) {
    p.z = fract(p.z) * 128.0;
    float iz = floor(p.z);
    float fz = fract(p.z);
    vec2 a_off = vec2(23.0, 29.0) * (iz) / 128.0;
    vec2 b_off = vec2(23.0, 29.0) * (iz + 1.0) / 128.0;
    float a = texture2D(noises, p.xy + a_off).r;
    float b = texture2D(noises, p.xy + b_off).r;
    return mix(a, b, fz);
}

void main() {
    vec3 lightColor = pow(texture(lightmap, lightmapCoords).rgb,vec3(2.2));

    vec4 outputColorData = pow(blockColor,vec4(2.2));
    vec3 outputColor = outputColorData.rgb; //* lightColor;
    float transparency = outputColorData.a;
    if(transparency < .1) {
        discard;
    }

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0,texCoord).r;

    if(depth != 1.0) {
        discard;
    }

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    float maxFogDistance = 3000;
    float minFogDistance = 2000;
    
    float fogBlendValue = clamp((distanceFromCamera - minFogDistance) / (maxFogDistance - minFogDistance),0,1);

    //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
    vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
    //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
    vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
    //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
    vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

    vec3 currentColor = vec3(1.0);

    vec3 fogDayColor = vec3(FOG_DAY_R,FOG_DAY_G,FOG_DAY_B);
    vec3 fogNightColor = vec3(FOG_NIGHT_R,FOG_NIGHT_G,FOG_NIGHT_B);
    vec3 fogSunsetColor = vec3(FOG_SUNSET_R,FOG_SUNSET_G,FOG_SUNSET_B);

    vec3 currentFogColor = fogDayColor;

    /*if(timePhase > 3) {
        timePhase = 0;
    }*/
    vec3 baseColor = currentColor;
    vec3 baseOutputColor = outputColor;

    vec3 baseOutputColorModifier = vec3(1.0f);
    
    float baseMinFogDistance = minFogDistance;
    float baseMaxFogDistance = maxFogDistance;

    vec3 baseFogColor = fogColor;

    if(worldTime/(timePhase + 1) < 500f) {
        baseColor = currentColor;
        baseOutputColor = outputColor;
        baseMinFogDistance = minFogDistance;
        baseMaxFogDistance = maxFogDistance;
        baseFogColor = currentFogColor;
    }

    vec4 noiseMap = texture2D(noises, screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight),1.0)).yx * 50);

    float dayNightLerp = clamp(quadTime/11500,0,1);
    float sunsetLerp = clamp(quadTime/500,0,1);

    if(worldTime%24000 > 250 && worldTime%24000 <= 11750) {
        baseOutputColorModifier = vec3(DAY_I);
        currentColor = mix(baseColor,dayColor,dayNightLerp);
        outputColor = mix(baseOutputColor, (outputColorData.rgb) * baseOutputColorModifier, dayNightLerp);
        minFogDistance = mix(baseMinFogDistance, FOG_DAY_DIST_MIN * 2000, dayNightLerp);
        maxFogDistance = mix(baseMaxFogDistance, FOG_DAY_DIST_MAX * 3000, dayNightLerp);
        currentFogColor = mix(fogSunsetColor, fogDayColor, dayNightLerp);
        
    } else if(worldTime%24000 > 11750 && worldTime%24000 <= 12250) {
        baseOutputColorModifier = vec3(SUNSET_I);
        currentColor = mix(dayColor, transitionColor, sunsetLerp);
        outputColor = mix(baseOutputColor, (outputColorData.rgb) * baseOutputColorModifier, sunsetLerp);
        minFogDistance = mix(baseMinFogDistance, FOG_SUNSET_DIST_MIN * 1000, sunsetLerp);
        maxFogDistance = mix(baseMaxFogDistance, FOG_SUNSET_DIST_MAX * 2000, sunsetLerp);
        currentFogColor = mix(fogDayColor, fogSunsetColor, sunsetLerp);
    } else if(worldTime%24000 > 12250 && worldTime%24000 <= 23750) {
        baseOutputColorModifier = vec3(NIGHT_I);
        currentColor = mix(baseColor, nightColor, dayNightLerp);
        outputColor = mix(baseOutputColor, (outputColorData.rgb) * baseOutputColorModifier,dayNightLerp);
        minFogDistance = mix(baseMinFogDistance, FOG_NIGHT_DIST_MIN * 1000, dayNightLerp);
        maxFogDistance = mix(baseMaxFogDistance, FOG_NIGHT_DIST_MAX * 2000, dayNightLerp);
        currentFogColor = mix(baseFogColor, fogNightColor, dayNightLerp);
    } else if(worldTime%24000 > 23750 || worldTime%24000 < 250) {
        baseOutputColorModifier = vec3(SUNSET_I);
        currentColor = mix(nightColor, transitionColor, sunsetLerp);
        outputColor = mix(baseOutputColor, (outputColorData.rgb) * baseOutputColorModifier, sunsetLerp);
        minFogDistance = mix(baseMinFogDistance, FOG_SUNSET_DIST_MIN * 750, sunsetLerp);
        maxFogDistance = mix(baseMaxFogDistance, FOG_SUNSET_DIST_MAX * 1750, sunsetLerp);
        currentFogColor = mix(fogNightColor, fogSunsetColor, sunsetLerp);
    }

    if(dot(outputColor.xyz, vec3(0.333)) > 0.9f) {
        outputColor.xyz = vec3(0.6);
    }

    vec3 noisePos = floor((playerPos + cameraPosition) * 4.0 + 0.001) / 32.0;
    
    float noiseTexture = Noise3D(noisePos);
    
    float noiseFactor = max0(1.0 - 0.3 * dot(outputColor, outputColor));
    
    outputColor.rgb *= pow(noiseTexture, 0.6 * noiseFactor);

    //outputColor = mix(outputColor.xyz, vec3(dot(outputColor.xyz, vec3(0.333))), -dot(outputColor.xyz, vec3(0.333)));

    //outputColor *= vec3(noiseAmount);

    outputColor.xyz = mix(outputColor, outputColor * 0.03125f, (1 - clamp(lightmapCoords.g,MIN_LIGHT,MAX_LIGHT)) * lightColor);
    //outputColor.xyz -= (1 - clamp(lightmapCoords.g,MIN_LIGHT,MAX_LIGHT)) * lightColor;
    /*if(lightmapCoords.g < MIN_LIGHT || lightmapCoords.g > MAX_LIGHT) {
        outputColor.xyz = clamp(outputColor.xyz, currentColor * MIN_LIGHT, currentColor * MAX_LIGHT);
    }*/
    outputColor = mix(outputColor, currentFogColor, fogBlendValue);
    outputColor.xyz *= currentColor;
    /*if(isBiomeEnd) {
        outputColor.xyz = mix(outputColor, vec3(dot(outputColor, vec3(0.333))),0.5);*/
    /*if(!isBiomeEnd) {
        outputColor.xyz = mix(outputColor,lightColor,0.125f);
    }*/

    //outputColor.xyz = mix(unreal(outputColor.xyz),aces(outputColor.xyz),0.95);
    
    outputColor.xyz = mix(outputColor.xyz, vec3(0), blindness);

    /*if(timePhase < 3 && timePhase > 1) {
        outputColor.xyz *= vec3(0.75f);
    }*/

    if(!isBiomeEnd) {
        outputColor.xyz = mix(outputColor.xyz,unreal(outputColor.xyz),0.333f);   
    } else {
        outputColor.xyz = mix(outputColor.xyz, vec3(dot(outputColor.xyz, vec3(0.333f))), 1-dot(lightmapCoords.rg, vec2(0.333f)));
    }

    vec2 TexCoords2 = texCoord;
    float Depth = texture2D(depthtex0, texCoord).r;
    float Depth2 = texture2D(depthtex1, texCoord).r;
    /*vec3 Albedo;
    if(Depth != Depth2 && isWaterBlock > 0) {
        #ifdef WATER_REFRACTION
            vec4 noiseMap = texture2D(noise, texCoord + sin(texCoord.y*32f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 noiseMap2 = texture2D(noise, texCoord - sin(texCoord.y*16f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 finalNoise = mix(noiseMap,noiseMap2,0.5f);

            TexCoords2 += finalNoise.xy * vec2(0.125f);
        #endif

        Albedo = pow(mix(texture2D(colortex0, TexCoords2).rgb,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (Depth - Depth2)) * 0.5,0,1)), vec3(2.2f));
        #ifdef WATER_FOAM
            if(abs(Depth - Depth2) < 0.0005f) {
                Albedo = mix(Albedo, vec3(1.0f), clamp(1 - abs(Depth - Depth2),0f,1));
            }
        #endif
        outputColor = Albedo;
    }*/

    outColor0 = vec4(pow(outputColor,vec3(1/2.2)), transparency);
    outColor2 = vec4(lightmapCoords, 0f, 1.0f);
    if(Depth != Depth2 && isWaterBlock > 0) {
        isWater = vec4(1);
    } else {
        isWater = vec4(0);
    }
}