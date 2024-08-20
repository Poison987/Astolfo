#version 460 compatibility
#define PI 3.14159265358979323846f

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

varying vec2 TexCoords;
varying vec4 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform vec3 chunkOffset;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
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

uniform sampler2D depthtex0;

attribute vec4 mc_Entity;

out vec3 physics_localPosition;
out vec3 physics_foamColor;
out float physics_localWaviness;

float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = TexCoords.s/freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	//xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(PI*xy));
	float a = 0f;//rand((ij+vec2(0.,0.)));
	float b = 1f;//rand((ij+vec2(1.,0.)));
	float c = 0f;//rand((ij+vec2(0.,1.)));
	float d = 1f;//rand((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
	float persistance = .5;
	float n = 0.;
	float normK = 0.;
	float f = 4.;
	float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		n+=amp*noise(p, f);
		f*=2.;
		normK+=amp;
		amp*=persistance;
		if (iCount == res) break;
		iCount++;
	}
	float nf = n/normK;
	return nf*nf*nf*nf;
}

float physics_waveHeight(vec2 position, int iterations, float factor, float time) {
    position = (position - physics_waveOffset) * PHYSICS_XZ_SCALE * physics_oceanWaveHorizontalScale;
	float iter = 0.0;
    float frequency = PHYSICS_FREQUENCY;
    float speed = PHYSICS_SPEED;
    float weight = 1.0;
    float height = 0.0;
    float waveSum = 0.0;
    float modifiedTime = time * PHYSICS_TIME_MULTIPLICATOR;
    
    for (int i = 0; i < iterations; i++) {
        vec2 direction = vec2(sin(iter), cos(iter));
        float x = dot(direction, position) * frequency + modifiedTime * speed;
        float wave = exp(sin(x) - 1.0);
        float result = wave * cos(x);
        vec2 force = result * weight * direction;
        
        position -= force * PHYSICS_DRAG_MULT;
        height += wave * weight;
        iter += PHYSICS_ITER_INC;
        waveSum += weight;
        weight *= PHYSICS_WEIGHT;
        frequency *= PHYSICS_FREQUENCY_MULT;
        speed *= PHYSICS_SPEED_MULT;
    }
    
    return height / waveSum * physics_oceanHeight * factor - physics_oceanHeight * factor * 0.5;
}

void main() {
	gl_Position = ftransform();
	TexCoords = gl_MultiTexCoord0.st;
	Normal = vec4(normalize(gl_NormalMatrix * gl_Normal), 1.0f);
	LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
	physics_foamColor = textureLod(physics_lightmap, (mat4(vec4(0.00390625, 0.0, 0.0, 0.0), vec4(0.0, 0.00390625, 0.0, 0.0), vec4(0.0, 0.0, 0.00390625, 0.0), vec4(0.03125, 0.03125, 0.03125, 1.0)) * gl_MultiTexCoord1).xy, 0).rgb;
	physics_localWaviness = texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset, 0).r;
	vec4 physics_finalPosition = vec4(gl_Vertex.x, gl_Vertex.y + physics_waveHeight(gl_Vertex.xz, PHYSICS_ITERATIONS_OFFSET, physics_localWaviness, physics_gameTime), gl_Vertex.z, gl_Vertex.w);
	physics_localPosition = physics_finalPosition.xyz;

	mat3 tbnMatrix = mat3(1.0);
	if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0) {
		float depth = texture2D(depthtex0, TexCoords).r;
		vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
		vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
		vec3 View = ViewW.xyz / ViewW.w;
		vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
		Normal.w = 0.0f;
		vec4 waterDistort = vec4((Normal.y*2 - 1) * sin(World.x*32f + ((frameCounter)/90f))*0.025f);
		vec4 waterDistortScreen = gbufferModelViewInverse * vec4(0,waterDistort.y,0,0);
		waterDistortScreen = gbufferProjection * waterDistortScreen;
		//gl_Position.xy += waterDistortScreen.xy;

		//LightmapCoords += gl_Position.xy;

		//gl_Position.y /= ViewW.y;
	}
	#ifdef WAVING_WATER_VERTEX
		vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * physics_finalPosition;

		physics_localPosition = finalPosition.xyz;

		DoWave(position.xyz, mat)

		gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
	#else
		gl_Position = ftransform();
	#endif

	//gl_Position.y += sin(((ViewW.x + worldTime/10.0f) + (ViewW.z + worldTime/5.0f) * (180.0f/PI))) * 0.25f;

    //gl_Position.y += sin(TexCoords + (worldTime*0.001f));

    Color = gl_Color;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}