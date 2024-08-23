#version 120
#include "distort.glsl"
#include "lib/commonFunctions.glsl"
#include "lib/spaceConversion.glsl"
#define SHADOW_SAMPLES 2
#define PI 3.14159265358979323846f
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

#define SE_R 0.7f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_G 0.4f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define SHADOW_RES 4096 // [128 256 512 1024 2048 4096 8192]
#define SHADOW_DIST 16 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]

#define BLOOM

#define BLOOM_QUALITY 48 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
//#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define WATER_REFRACTION
#define WATER_FOAM

varying vec2 TexCoords;
varying float timePhase;
varying float quadTime;

uniform vec3 sunPosition;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D shadowtex0;

uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform sampler2D noise;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform int entityId;
uniform int blockId;
uniform int heldItemId;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 cameraPosition;

uniform float blindness;

const float sunPathRotation = -40.0f;

const float Ambient = 0.1f;

const int shadowMapResolution = SHADOW_RES;

const ivec3 voxelVolumeSize = ivec3(1,0.5, 1);
float effectiveACLdistance = min(1, SHADOW_DIST * 2.0);

uniform float maxBlindnessDarkness;

const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;
varying vec2 LightmapCoords;

attribute vec4 mc_Entity;

uniform bool isBiomeEnd;

in vec3 vaPosition;

in vec3 viewSpaceFragPosition;

float AdjustLightmapTorch(in float torch) {
    const float K = 2.0f;
    const float P = 5.06f;
    return K * pow(torch, P);
}

float AdjustLightmapSky(in float sky){
    float sky_2 = sky * sky;
    return sky_2 * sky_2;
}

vec2 AdjustLightmap(in vec2 Lightmap){
    vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
    NewLightMap.y = AdjustLightmapSky(Lightmap.y);
    return NewLightMap;
}

vec3 translucentMult;

vec3 GetLightmapColor(in vec2 Lightmap){
    Lightmap = AdjustLightmap(Lightmap);
    Lightmap.x = min(Lightmap.x, 0.25);
    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    const vec3 SkyColor = vec3(0.05f, 0.15f, 0.3f);
    vec3 TorchLighting = Lightmap.x * TorchColor;
    vec3 GlowstoneLighting = Lightmap.x * GlowstoneColor;
    vec3 LampLighting = Lightmap.x * LampColor;
    vec3 LanternLighting = Lightmap.x * LanternColor;
    vec3 RedstoneLighting = Lightmap.x * RedstoneColor;
    vec3 RodLighting = Lightmap.x * RodColor;
    vec3 SkyLighting = Lightmap.y * SkyColor;
    if(mc_Entity.x == 10005) {
        TorchLighting = TorchColor;
    } else if(mc_Entity.x == 10006) {
        GlowstoneLighting = GlowstoneColor;
    } else if(mc_Entity.x == 10007) {
        LampLighting = LampColor;
    } else if(mc_Entity.x == 10008) {
        LanternLighting = LanternColor;
    } else if(mc_Entity.x == 10009) {
        RedstoneLighting = RedstoneColor;
    } else if(mc_Entity.x == 10010) {
        RodLighting = RodColor;
    }
    vec3 LightmapLighting = TorchLighting + GlowstoneLighting + LampLighting + LanternLighting + RedstoneLighting + RodLighting + SkyLighting;
    return LightmapLighting;
}

float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

vec3 TransparentShadow(in vec3 SampleCoords){
    float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
    return mix(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
}

vec3 GetShadow(float depth) {
    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
    vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
    vec3 ShadowAccum = vec3(0.0f);
    for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++){
        for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++){
            vec2 Offset = vec2(x, y) / SHADOW_RES;
            vec3 CurrentSampleCoordinate = vec3(SampleCoords.xy + Offset, SampleCoords.z);
            ShadowAccum += TransparentShadow(CurrentSampleCoordinate);
        }
    }
    ShadowAccum /= TotalSamples;
    return ShadowAccum;
}

vec3 SceneToVoxel(vec3 scenePos) {
	return scenePos + fract(cameraPosition) + (0.5 * vec3(voxelVolumeSize));
}

vec3 aces(vec3 x) {
  float a = 2.51;
  float b = 0.03;
  float c = 2.43;
  float d = 0.59;
  float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 lottes(vec3 x) {
  vec3 a = vec3(1.6);
  vec3 d = vec3(0.977);
  vec3 hdrMax = vec3(8.0);
  vec3 midIn = vec3(0.18);
  vec3 midOut = vec3(0.267);

  vec3 b =
      (-pow(midIn, a) + pow(hdrMax, a) * midOut) /
      ((pow(hdrMax, a * d) - pow(midIn, a * d)) * midOut);
  vec3 c =
      (pow(hdrMax, a * d) * pow(midIn, a) - pow(hdrMax, a) * pow(midIn, a * d) * midOut) /
      ((pow(hdrMax, a * d) - pow(midIn, a * d)) * midOut);

  return pow(x, a) / (pow(x, a * d) * b + c);
}

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 bloom() {
    float radius = 2f;
    vec3 sum = vec3(0.0);
    float blur = radius/viewHeight;
    float hstep = 1f;
    sum += GetLightmapColor(texture2D(colortex2, TexCoords).rg) * 1;

    /*if(texture2D(colortex2, TexCoords).r < 0.85 || texture2D(colortex2, TexCoords).g < 0.85) {
        GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    /*if(abs(sum.r - sum.g) > 0.25) {
        return GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        float sampleDepth = mix(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep)).rg) * sampleDepth;
    }

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        float sampleDepth = mix(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep)).rg) * sampleDepth;
    }

    sum /= BLOOM_QUALITY/8;
    sum *= BLOOM_INTENSITY;

    /*sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 8.0 * blur * hstep, TexCoords.y - 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 7.0 * blur * hstep, TexCoords.y - 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 6.0 * blur * hstep, TexCoords.y - 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 5.0 * blur * hstep, TexCoords.y - 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 4.0 * blur * hstep, TexCoords.y - 4.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 3.0 * blur * hstep, TexCoords.y - 3.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 2.0 * blur * hstep, TexCoords.y - 2.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 1.0 * blur * hstep, TexCoords.y - 1.0 * blur * hstep)).rg) * 0.985135135;

    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 8.0 * blur * hstep, TexCoords.y + 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 7.0 * blur * hstep, TexCoords.y + 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 6.0 * blur * hstep, TexCoords.y + 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 5.0 * blur * hstep, TexCoords.y + 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 4.0 * blur * hstep, TexCoords.y + 1.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 3.0 * blur * hstep, TexCoords.y + 2.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 2.0 * blur * hstep, TexCoords.y + 3.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 1.0 * blur * hstep, TexCoords.y + 4.0 * blur * hstep)).rg) * 0.985135135;*/

    /*if(dot(sum, vec3(0.333)) > 2) {
        sum *= mix(vec3(2),vec3(0.5),clamp(dot(sum, vec3(0.333)),0,1.2));
    }*/
    return pow(sum,vec3(2.2)) * vec3(0.0625);
}

float far = 1f;

vec4 GetLightVolume(vec3 pos) {
    vec4 lightVolume;

    #ifdef COMPOSITE
        #undef ACL_CORNER_LEAK_FIX
    #endif

    #ifdef ACL_CORNER_LEAK_FIX
        float minMult = 1.5;
        ivec3 posTX = ivec3(pos * voxelVolumeSize);

        ivec3[6] adjacentOffsets = ivec3[](
            ivec3( 1, 0, 0),
            ivec3(-1, 0, 0),
            ivec3( 0, 1, 0),
            ivec3( 0,-1, 0),
            ivec3( 0, 0, 1),
            ivec3( 0, 0,-1)
        );

        int adjacentCount = 0;
        for (int i = 0; i < 6; i++) {
            int voxel = int(texelFetch(voxel_sampler, posTX.xy + adjacentOffsets[i].xy, 0).r);
            if (voxel == 1 || voxel >= 200) adjacentCount++;
        }

        if (int(texelFetch(voxel_sampler, posTX.xy, 0).r) >= 200) adjacentCount = 6;
    #endif

    if ((frameCounter & 1) == 0) {
        lightVolume = texture(colortex4, pos.xy);
        #ifdef ACL_CORNER_LEAK_FIX
            if (adjacentCount >= 3) {
                vec4 lightVolumeTX = texelFetch(colortex4, posTX.xy, 0);
                if (dot(lightVolumeTX, lightVolumeTX) > 0.01)
                lightVolume.rgb = min(lightVolume.rgb, lightVolumeTX.rgb * minMult);
            }
        #endif
    } else {
        lightVolume = texture(colortex4, pos.xy);
        #ifdef ACL_CORNER_LEAK_FIX
            if (adjacentCount >= 3) {
                vec4 lightVolumeTX = texelFetch(colortex4, posTX.xy, 0);
                if (dot(lightVolumeTX, lightVolumeTX) > 0.01)
                lightVolume.rgb = min(lightVolume.rgb, lightVolumeTX.rgb * minMult);
            }
        #endif
    }

    return lightVolume;
}

vec3 GetColoredLightFog(vec3 nPlayerPos, vec3 translucentMult, float lViewPos, float lViewPos1, float dither, float caveFactor) {
    vec3 lightFog = vec3(0.0);

    float stepMult = 8.0;

    float maxDist = min(effectiveACLdistance * 0.5, far);
    float halfMaxDist = maxDist * 0.5;
    int sampleCount = int(maxDist / stepMult + 0.001);
    vec3 traceAdd = nPlayerPos * stepMult;
    vec3 tracePos = traceAdd * dither;

    for (int i = 0; i < sampleCount; i++) {
        tracePos += traceAdd;

        float lTracePos = length(tracePos);
        if (lTracePos > lViewPos1) break;

        vec3 voxelPos = SceneToVoxel(tracePos);
        voxelPos = clamp01(voxelPos / vec3(voxelVolumeSize));

        vec4 lightVolume = GetLightVolume(voxelPos);
        vec3 lightSample = lightVolume.rgb;

        float lTracePosM = length(vec3(tracePos.x, tracePos.y * 2.0, tracePos.z));
        lightSample *= max0(1.0 - lTracePosM / maxDist);
        lightSample *= pow2(min1(lTracePos * 0.03125));

        #ifdef CAVE_SMOKE
            if (caveFactor > 0.00001) {
                vec3 smokePos = 0.0025 * (tracePos + cameraPosition);
                vec3 smokeWind = frameTimeCounter * vec3(0.006, 0.003, 0.0);
                float smoke = Noise3D(smokePos + smokeWind)
                            * Noise3D(smokePos * 3.0 - smokeWind)
                            * Noise3D(smokePos * 9.0 + smokeWind);
                smoke = smoothstep1(smoke);
                lightSample *= mix(1.0, smoke * 16.0, caveFactor);
                lightSample += caveFogColor * pow2(smoke) * 0.05 * caveFactor;
            }
        #endif

        if (lTracePos > lViewPos) lightSample *= translucentMult;
        lightFog += lightSample;
    }

    #ifdef NETHER
        lightFog *= netherColor * 5.0;
    #endif

    lightFog *= 1.0 - maxBlindnessDarkness;

    return pow(lightFog / sampleCount, vec3(0.25));
}

void main() {
    float aspectRatio = float(viewWidth)/float(viewHeight);
    float waterTest = texture2D(colortex5, TexCoords).r;
    vec2 TexCoords2 = TexCoords;
    float Depth = texture2D(depthtex0, TexCoords).r;
    float Depth2 = texture2D(depthtex1, TexCoords).r;
    vec3 Albedo;
    if(Depth != Depth2 && waterTest > 0) {
        #ifdef WATER_REFRACTION
            vec4 noiseMap = texture2D(noise, TexCoords + sin(TexCoords.y*32f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 noiseMap2 = texture2D(noise, TexCoords - sin(TexCoords.y*16f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 finalNoise = mix(noiseMap,noiseMap2,0.5f);

            TexCoords2 += finalNoise.xy * vec2(0.125f);
        #endif

        Albedo = pow(mix(texture2D(colortex0, TexCoords2).rgb,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (Depth - Depth2)) * 0.5,0,1)), vec3(2.2f));
        #ifdef WATER_FOAM
            if(abs(Depth - Depth2) < 0.0005f) {
                Albedo = mix(Albedo, vec3(1.0f), clamp(1 - abs(Depth - Depth2),0f,1));
            }
        #endif
    } else {
        Albedo = pow(texture2D(colortex0, TexCoords2).rgb, vec3(2.2f));
    }
    vec3 Normal = normalize(texture2D(colortex1, TexCoords2).rgb * 2.0f -1.0f);

    /*if(Depth != Depth2 && waterTest > 0) {
        Albedo = mix(Albedo,mix(Albedo,vec3(0.0f,0.22f,0.55f),0.25), clamp((1 - (Depth - Depth2)),0,1)*0.5);
    }*/
    
    //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
    vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
    //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
    vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
    //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
    vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

    vec3 seColor = vec3(SE_R,SE_G,SE_B);

    vec3 currentColor = dayColor;

    /*if(timePhase > 3) {
        timePhase = 0;
    }*/
    vec3 Diffuse = Albedo;

    vec3 baseColor = currentColor;
    vec3 baseDiffuse = Diffuse;

    vec3 baseDiffuseModifier;
    
    if(worldTime/(timePhase + 1) < 500f) {
        baseColor = currentColor;
        baseDiffuse = Diffuse;
    }
    
    float dayNightLerp = clamp(quadTime/11500,0,1);
    float sunsetLerp = clamp(quadTime/500,0,1);

    if(isBiomeEnd) {
        currentColor = seColor;
    } else if(timePhase < 1) {
        baseDiffuseModifier = vec3(DAY_I);
        currentColor = mix(baseColor,dayColor,dayNightLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        
    } else if(timePhase < 2) {
        baseDiffuseModifier = vec3(SUNSET_I);
        currentColor = mix(dayColor, transitionColor, sunsetLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    } else if(timePhase < 3) {
        baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
        currentColor = mix(baseColor, nightColor, dayNightLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
    } else if(timePhase < 4) {
        baseDiffuseModifier = vec3(SUNSET_I);
        currentColor = mix(nightColor, transitionColor, sunsetLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    }

    //Diffuse *= currentColor;

    if(Depth == 1.0f){
        /*float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

        float maxBlindnessDistance = 30;
        float minBlindnessDistance = 20;

        float blindnessBlendValue = clamp((distanceFromCamera - minBlindnessDistance) / (maxBlindnessDistance - minBlindnessDistance),0,1);*/
        
        Diffuse.xyz = mix(Diffuse.xyz, vec3(0), blindness);

        gl_FragData[0] = vec4(Albedo * currentColor, 1.0f);
        return;
    }

    float minLight = MIN_LIGHT;
    
    vec3 LightmapColor;
    //vec3 Lightmap = bloom();
    #ifdef BLOOM
        LightmapColor = bloom();
        /*if(dot(LightmapColor,vec3(0.333f)) < BLOOM_THRESHOLD) {
            LightmapColor = GetLightmapColor(texture2D(colortex2, TexCoords).rg);
        }*/
    #else
        LightmapColor = GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    #endif
    vec3 LightmapColor2 = texture2D(colortex7,TexCoords).rgb;

    if(dot(LightmapColor, vec3(0.333f)) < minLight) {
        LightmapColor = vec3(minLight);
    }

    float NdotL = max(dot(Normal, normalize(sunPosition)), 0.0f);

    /*if((Lightmap.r + Lightmap.g + Lightmap.b)/3 < 0) {
        Diffuse = Albedo * LightmapColor;
    } else {
        Diffuse = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
    }*/

    float isParticle = texture2D(colortex6, TexCoords).r;

    /*if(isLiquidEmerald > 0.0) {
        Diffuse = Albedo;
    } else {
        Diffuse = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
    }*/
    //ivec2 texelCoord = ivec2(gl_FragCoord.xy);
    //translucentMult = 1.0 - texelFetch(colortex4, texelCoord, 0).rgb;
    //vec3 lightFog = GetColoredLightFog(vec3(0), translucentMult, 0, 1, 0, 0);
    /*if(dot(LightmapColor, vec3(0.333f)) < 1.0) {
        Diffuse.xyz = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
    } else {
        Diffuse.xyz = mix(Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor),LightmapColor,Lightmap.r * vec3(0.0625));
    }*/

    float maxLight = MAX_LIGHT;

    if(isBiomeEnd) {
        Diffuse.xyz = mix(Albedo * ((mix(LightmapColor,vec3(dot(LightmapColor,vec3(0.333f))),0.75)*0.125 + NdotL * GetShadow(Depth) + Ambient) * currentColor),Albedo * ((NdotL * GetShadow(Depth) + Ambient) * currentColor),0.25);
        //Diffuse = mix(Diffuse, seColor, 0.01);
        Diffuse = mix(Diffuse,vec3(dot(Diffuse,vec3(0.333f))),1.0625-clamp(vec3(dot(LightmapColor.rg,vec2(0.333f))),0.5,1));
        Diffuse.xyz = mix(unreal(Diffuse.xyz),aces(Diffuse.xyz),0.95);
    } else {
        /*if(dot(LightmapColor,vec3(0.333)) > maxLight) {
            LightmapColor = LightmapColor/vec3(dot(LightmapColor,vec3(0.333)));
        }*/
        if(maxLight < 4.1f) {
            LightmapColor = clamp(LightmapColor,vec3(0f), (LightmapColor/dot(LightmapColor,vec3(0.333))) * maxLight);
        }
        Diffuse.xyz = mix(Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor),Albedo * ((NdotL * GetShadow(Depth) + Ambient) * currentColor),0.25);
        Diffuse.xyz = mix(unreal(Diffuse.xyz),aces(Diffuse.xyz),0.75);
    }

    //vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;
    
    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    float maxBlindnessDistance = 30;
    float minBlindnessDistance = 20;

    float blindnessBlendValue = clamp((distanceFromCamera - minBlindnessDistance) / (maxBlindnessDistance - minBlindnessDistance),0,1);
    
    //Diffuse.xyz = mix(Diffuse.xyz, vec3(0), blindness);

    //Diffuse.xyz = mix(Diffuse.xyz,vec3(0),blindnessBlendValue);
    
    /*if(isLiquidEmerald > 0.0) {
        Diffuse *= vec3(1);
    }*/

    /*if(timePhase < 4 && timePhase > 2) {
        Diffuse.xyz *= vec3(0.4f);
    }*/

    gl_FragData[0] = vec4(pow(Diffuse,vec3(1/2.2)), 1.0f);
}