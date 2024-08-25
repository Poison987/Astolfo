#version 120
#define PI 3.14159265358979323846f

varying vec2 TexCoords;
varying vec4 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

varying float isWaterBlock;

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

uniform sampler2D depthtex0;

attribute vec4 mc_Entity;

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

void main() {
	gl_Position = ftransform();
	TexCoords = gl_MultiTexCoord0.st;
	Normal = vec4(normalize(gl_NormalMatrix * gl_Normal), 1.0f);
	LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
	/*if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0) {
		float depth = texture2D(depthtex0, TexCoords).r;
		vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
		vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
		vec3 View = ViewW.xyz / ViewW.w;
		vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
		Normal.w = 0.0f;
		vec4 waterDistort = vec4(clamp(sin(World.x*32f + ((frameCounter)/90f)),0,1)*0.025f);
		vec4 waterDistortScreen = gbufferModelViewInverse * vec4(0,waterDistort.y,0,0);
		waterDistortScreen = gbufferProjection * waterDistortScreen;
		Normal.xy += waterDistortScreen.xy;

		LightmapCoords += gl_Position.xy;*/
		
		//isWaterBlock = 1;

		//gl_Position.y /= ViewW.y;
	/*} else {
		isWaterBlock = 0;
	}*/

	//gl_Position.y += sin(((ViewW.x + worldTime/10.0f) + (ViewW.z + worldTime/5.0f) * (180.0f/PI))) * 0.25f;

    //gl_Position.y += sin(TexCoords + (worldTime*0.001f));

    Color = gl_Color;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}