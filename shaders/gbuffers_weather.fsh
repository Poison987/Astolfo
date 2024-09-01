#version 460 compatibility

#define TILTED_RAIN

uniform sampler2D lightmap;
uniform sampler2D gtexture;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

in vec3 viewSpaceFragPosition;

/* DRAWBUFFERS:035 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 isRain;
layout(location = 2) out vec4 isWater;

void main() {
    #ifdef TILTED_RAIN
        color = texture(gtexture, vec2(texcoord.x - texcoord.y, texcoord.y)) * glcolor;
    #else
        color = texture(gtexture, texcoord) * glcolor;
    #endif
    color *= texture(lightmap, lmcoord);
    
	if (color.a < 0.1) {
		discard;
	}

    if(color.b > color.g && color.b > color.a) {
        isWater = vec4(1f);
        isRain = vec4(1f);
    } else {
        isWater = vec4(0f);
        isRain = vec4(0f);
    }

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    float maxFogDistance = 3000;
    float minFogDistance = 2000;
    
    float fogBlendValue = clamp((distanceFromCamera - minFogDistance) / (maxFogDistance - minFogDistance),0,1);

    color.a = mix(0f, 1f, fogBlendValue);
    color.rgb = mix(color.rgb, vec3(0.5f),fogBlendValue);
}