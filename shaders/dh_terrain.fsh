#version 460 compatibility

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

uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 fogColor;

uniform sampler2D noise;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse;

uniform bool isBiomeEnd;

/* DRAWBUFFERS:026 */
layout(location = 0) out vec4 outColor0;
layout(location = 1) out vec4 outColor2;

in vec4 blockColor;
in vec2 lightmapCoords;
in vec3 viewSpaceFragPosition;

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

    vec4 noiseMap = texture2D(noise, screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight),1.0)).yx * 50);

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

    outputColor = mix(outputColor, currentFogColor, fogBlendValue);
    outputColor.xyz *= currentColor;
    /*if(isBiomeEnd) {
        outputColor.xyz = mix(outputColor, vec3(dot(outputColor, vec3(0.333))),0.5);*/
    if(!isBiomeEnd) {
        outputColor.xyz = mix(outputColor,lightColor,0.125f);
    }

    /*if(timePhase < 3 && timePhase > 1) {
        outputColor.xyz *= vec3(0.75f);
    }*/

    //outputColor.xyz = unreal(outputColor.xyz);

    outColor0 = vec4(pow(outputColor,vec3(1/2.2)), transparency);
    outColor2 = vec4(lightmapCoords, 0f, 1.0f);
}