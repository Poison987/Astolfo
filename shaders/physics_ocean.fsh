#version 460 compatibility

const int PHYSICS_ITERATIONS_OFFSET = 13;
const float PHYSICS_DRAG_MULT = 0.048;
const float PHYSICS_XZ_SCALE = 0.035;
const float PHYSICS_TIME_MULTIPLICATOR = 0.45;
const float PHYSICS_W_DETAIL = 0.75;
const float PHYSICS_FREQUENCY = 6.0;
const float PHYSICS_SPEED = 2.0;
const float PHYSICS_WEIGHT = 0.8;
const float PHYSICS_FREQUENCY_MULT = 1.18;
const float PHYSICS_SPEED_MULT = 1.07;
const float PHYSICS_ITER_INC = 12.0;
const float PHYSICS_NORMAL_STRENGTH = 1.4;

struct WavePixelData {
    vec2 direction;
    vec2 worldPos;
    vec3 normal;
    float foam;
    float height;
};

varying vec2 TexCoords;
varying vec4 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D depthtex1;
uniform sampler2D shadowtex1;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;


uniform int physics_iterationsNormal;
uniform vec2 physics_waveOffset;
uniform ivec2 physics_textureOffset;
uniform float physics_gameTime;
uniform float physics_globalTime;
uniform float physics_oceanHeight;
uniform float physics_oceanWaveHorizontalScale;
uniform vec3 physics_modelOffset;
uniform float physics_rippleRange;
uniform float physics_foamAmount;
uniform float physics_foamOpacity;
uniform sampler2D physics_waviness;
uniform sampler2D physics_ripples;
uniform sampler3D physics_foam;
uniform sampler2D physics_lightmap;

in vec3 physics_localPosition;
in vec3 physics_foamColor;
in float physics_localWaviness;
WavePixelData physics_waveData;

vec2 physics_waveDirection(vec2 position, int iterations, float time) {
    position = (position - physics_waveOffset) * PHYSICS_XZ_SCALE * physics_oceanWaveHorizontalScale;
	float iter = 0.0;
    float frequency = PHYSICS_FREQUENCY;
    float speed = PHYSICS_SPEED;
    float weight = 1.0;
    float waveSum = 0.0;
    float modifiedTime = time * PHYSICS_TIME_MULTIPLICATOR;
    vec2 dx = vec2(0.0);
    
    for (int i = 0; i < iterations; i++) {
        vec2 direction = vec2(sin(iter), cos(iter));
        float x = dot(direction, position) * frequency + modifiedTime * speed;
        float wave = exp(sin(x) - 1.0);
        float result = wave * cos(x);
        vec2 force = result * weight * direction;
        
        dx += force / pow(weight, PHYSICS_W_DETAIL); 
        position -= force * PHYSICS_DRAG_MULT;
        iter += PHYSICS_ITER_INC;
        waveSum += weight;
        weight *= PHYSICS_WEIGHT;
        frequency *= PHYSICS_FREQUENCY_MULT;
        speed *= PHYSICS_SPEED_MULT;
    }
    
    return vec2(dx / pow(waveSum, 1.0 - PHYSICS_W_DETAIL));
}

vec3 physics_waveNormal(const in vec2 position, const in vec2 direction, const in float factor, const in float time) {
    float oceanHeightFactor = physics_oceanHeight / 13.0;
    float totalFactor = oceanHeightFactor * factor;
    vec3 waveNormal = normalize(vec3(direction.x * totalFactor, PHYSICS_NORMAL_STRENGTH, direction.y * totalFactor));
    
    vec2 eyePosition = position + physics_modelOffset.xz;
    vec2 rippleFetch = (eyePosition + vec2(physics_rippleRange)) / (physics_rippleRange * 2.0);
    vec2 rippleTexelSize = vec2(2.0 / textureSize(physics_ripples, 0).x, 0.0);
    float left = texture(physics_ripples, rippleFetch - rippleTexelSize.xy).r;
    float right = texture(physics_ripples, rippleFetch + rippleTexelSize.xy).r;
    float top = texture(physics_ripples, rippleFetch - rippleTexelSize.yx).r;
    float bottom = texture(physics_ripples, rippleFetch + rippleTexelSize.yx).r;
    float totalEffect = left + right + top + bottom;
    
    float normalx = left - right;
    float normalz = top - bottom;
    vec3 rippleNormal = normalize(vec3(normalx, 1.0, normalz));
    return normalize(mix(waveNormal, rippleNormal, pow(totalEffect, 0.5)));
}

WavePixelData physics_wavePixel(const in vec2 position, const in float factor, const in float iterations, const in float time) {
    vec2 wavePos = (position.xy - physics_waveOffset) * PHYSICS_XZ_SCALE * physics_oceanWaveHorizontalScale;
    float iter = 0.0;
    float frequency = PHYSICS_FREQUENCY;
    float speed = PHYSICS_SPEED;
    float weight = 1.0;
    float height = 0.0;
    float waveSum = 0.0;
    float modifiedTime = time * PHYSICS_TIME_MULTIPLICATOR;
    vec2 dx = vec2(0.0);
    
    for (int i = 0; i < iterations; i++) {
        vec2 direction = vec2(sin(iter), cos(iter));
        float x = dot(direction, wavePos) * frequency + modifiedTime * speed;
        float wave = exp(sin(x) - 1.0);
        float result = wave * cos(x);
        vec2 force = result * weight * direction;
        
        dx += force / pow(weight, PHYSICS_W_DETAIL); 
        wavePos -= force * PHYSICS_DRAG_MULT;
        height += wave * weight;
        iter += PHYSICS_ITER_INC;
        waveSum += weight;
        weight *= PHYSICS_WEIGHT;
        frequency *= PHYSICS_FREQUENCY_MULT;
        speed *= PHYSICS_SPEED_MULT;
    }
    
    WavePixelData data;
    data.direction = -vec2(dx / pow(waveSum, 1.0 - PHYSICS_W_DETAIL));
    data.worldPos = wavePos / physics_oceanWaveHorizontalScale / PHYSICS_XZ_SCALE;
    data.height = height / waveSum * physics_oceanHeight * factor - physics_oceanHeight * factor * 0.5;
    
    data.normal = physics_waveNormal(position, data.direction, factor, time);

    float waveAmplitude = data.height * pow(max(data.normal.y, 0.0), 4.0);
    vec2 waterUV = mix(position - physics_waveOffset, data.worldPos, clamp(factor * 2.0, 0.2, 1.0));
    
    vec2 s1 = textureLod(physics_foam, vec3(waterUV * 0.26, physics_globalTime / 360.0), 0).rg;
    vec2 s2 = textureLod(physics_foam, vec3(waterUV * 0.02, physics_globalTime / 360.0 + 0.5), 0).rg;
    vec2 s3 = textureLod(physics_foam, vec3(waterUV * 0.1, physics_globalTime / 360.0 + 1.0), 0).rg;
    
    float waterSurfaceNoise = s1.r * s2.r * s3.r * 2.8 * physics_foamAmount;
    waveAmplitude = clamp(waveAmplitude * 1.2, 0.0, 1.0);
    waterSurfaceNoise = (1.0 - waveAmplitude) * waterSurfaceNoise + waveAmplitude * physics_foamAmount;
    
    float worleyNoise = 0.2 + 0.8 * s1.g * (1.0 - s2.g);
    float waterFoamMinSmooth = 0.45;
    float waterFoamMaxSmooth = 2.0;
    waterSurfaceNoise = smoothstep(waterFoamMinSmooth, 1.0, waterSurfaceNoise) * worleyNoise;
    
    data.foam = clamp(waterFoamMaxSmooth * waterSurfaceNoise * physics_foamOpacity, 0.0, 1.0);
    
    if (!gl_FrontFacing) {
    	data.normal = -data.normal;
    }
    
    return data;
}

/* DRAWBUFFERS: 0125 */

void main() {
    physics_waveData = physics_wavePixel(physics_localPosition.xz, physics_localWaviness, physics_iterationsNormal, physics_gameTime);
    vec3 physics_normal = normalize(gl_NormalMatrix * physics_waveData.normal);
	
    if (!gl_FrontFacing) {
        physics_waveData.normal = -physics_waveData.normal;
    }
    //vec4 albedo = texture2D(texture, TexCoords) * Color;

    float isWater = Normal.w;

    vec4 noiseMap = texture2D(noise, TexCoords);

    vec4 albedo = texture2D(texture, TexCoords) * Color;

    vec3 normalM = physics_normal;

    albedo.a = 0.0f;

    vec4 depth = texture2D(depthtex1, TexCoords);
    //vec4 depth2 = texture2D(depthtex0, TexCoords);

    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

    if(isWater < 0.1f) {
        albedo.xyz = mix(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f), physics_waveData.foam);
        //albedo.a = mix(0.5f, 1.0f, depth.w);
        albedo.a = mix(0.5f, 1.0f, physics_waveData.foam);
    }

    //vec4 normalDefine = vec4(noiseMap.xyz * 0.5 + 0.5f, 1.0f);
    //normalDefine = normalDefine + noiseMap;

    WavePixelData wave = physics_wavePixel(physics_localPosition.xz, physics_localWaviness, physics_iterationsNormal, physics_gameTime);

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(normalM,1);
    gl_FragData[2] = vec4(LightmapCoords.x + noiseMap.x, LightmapCoords.x + noiseMap.y, LightmapCoords.y + noiseMap.z, 1.0f);
    gl_FragData[3] = vec4(1.0);
}