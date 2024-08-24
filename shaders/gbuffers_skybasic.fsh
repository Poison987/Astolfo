#version 460 compatibility

#define SKY_DAY_A_R 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_A_G 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_A_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_DAY_B_R 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_B_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_B_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_NIGHT_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_NIGHT_B_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_B_B 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SUNSET_A_R 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_A_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_A_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SUNSET_B_R 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_B_G 0.9f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_B_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SE_DAY_A_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_A_B 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_DAY_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_B_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_B_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SE_NIGHT_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_NIGHT_B_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_B_B 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SE_SUNSET_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_A_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_A_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_SUNSET_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_B_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_B_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


varying vec2 TexCoords;

uniform float viewWidth;
uniform float viewHeight;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform vec3 fogColor;
uniform vec3 skyColor;

uniform bool isBiomeEnd;

uniform float blindness;

in vec4 starData;

float fogify(float x, float w) {
    return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos, vec3 currentColorA, vec3 currentColorB) {
    float upDot = dot(pos, gbufferModelView[1].xyz);
    float lerpAmount = fogify(max(clamp(upDot,0,1),0.0), 0.25);
    return mix(currentColorB, currentColorA,lerpAmount);
}

vec3 screenToView(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    return tmp.xyz / tmp.w;
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outputColor;

void main() {
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);

    //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
    vec3 dayColorA;
    vec3 dayColorB;
    //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
    vec3 nightColorA;
    vec3 nightColorB;
    //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
    vec3 transitionColorA;
    vec3 transitionColorB;
    if(isBiomeEnd) {
        //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
        dayColorA = vec3(SKY_SE_DAY_A_R,SKY_SE_DAY_A_G,SKY_SE_DAY_A_B);
        dayColorB = vec3(SKY_SE_DAY_B_R,SKY_SE_DAY_B_G,SKY_SE_DAY_B_B);
        //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
        nightColorA = vec3(SKY_SE_NIGHT_A_R,SKY_SE_NIGHT_A_G,SKY_SE_NIGHT_A_B);
        nightColorB = vec3(SKY_SE_NIGHT_B_R,SKY_SE_NIGHT_B_G,SKY_SE_NIGHT_B_B);
        //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
        transitionColorA = vec3(SKY_SE_SUNSET_A_R,SKY_SE_SUNSET_A_G,SKY_SE_SUNSET_A_B);
        transitionColorB = vec3(SKY_SE_SUNSET_B_R,SKY_SE_SUNSET_B_G,SKY_SE_SUNSET_B_B);
    } else {
        //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
        dayColorA = vec3(SKY_DAY_A_R,SKY_DAY_A_G,SKY_DAY_A_B);
        dayColorB = vec3(SKY_DAY_B_R,SKY_DAY_B_G,SKY_DAY_B_B);
        //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
        nightColorA = vec3(SKY_NIGHT_A_R,SKY_NIGHT_A_G,SKY_NIGHT_A_B);
        nightColorB = vec3(SKY_NIGHT_B_R,SKY_NIGHT_B_G,SKY_NIGHT_B_B);
        //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
        transitionColorA = vec3(SKY_SUNSET_A_R,SKY_SUNSET_A_G,SKY_SUNSET_A_B);
        transitionColorB = vec3(SKY_SUNSET_B_R,SKY_SUNSET_B_G,SKY_SUNSET_B_B);
    }

    vec3 currentColorA;
    vec3 currentColorB;

    /*if(timePhase > 3) {
        timePhase = 0;
    }*/
    //vec3 baseColorA = currentColorA;
    //vec3 baseColorB = currentColorB;

    //vec3 baseOutputColorModifier;
    
    /*if(quadTime < 500f) {
        baseColorA = currentColorA;
        baseColorB = currentColorB;
    }*/

    float dayNightLerp = clamp(quadTime/500,0,1);
    float sunsetLerp = clamp((quadTime - 500)/500,0,1);

    if(worldTime > 500 && worldTime <= 11500) {
        //baseOutputColorModifier = vec3(DAY_I);
        currentColorA = dayColorA;//mix(baseColorA,dayColorA,dayNightLerp);
        currentColorB = mix(transitionColorB,dayColorB,dayNightLerp);//mix(baseColorB,dayColorB,dayNightLerp);
        //outputColor = mix(baseOutputColor, baseOutputColor * baseOutputColorModifier, mod(worldTime/6000f,2f));
        
    } else if(worldTime > 11500 && worldTime <= 12500) {
        currentColorA = mix(dayColorA, nightColorA, sunsetLerp);
        currentColorB = mix(dayColorB, transitionColorB, sunsetLerp);
    } else if((worldTime > 12500 && worldTime <= 23500)) {
        //baseOutputColorModifier = vec3(NIGHT_I * 0.4f);
        currentColorA = nightColorA;//mix(baseColorA, nightColorA, dayNightLerp);
        currentColorB = mix(transitionColorB,nightColorB,dayNightLerp);//mix(baseColorB, nightColorB, dayNightLerp);
        //outputColor = mix(baseOutputColor, baseOutputColor * baseOutputColorModifier,mod(worldTime/6000f,2f));
    } else if(worldTime > 23500 || worldTime <= 500) {
        //baseOutputColorModifier = vec3(SUNSET_I);
        currentColorA = mix(nightColorA, dayColorA, sunsetLerp);
        currentColorB = mix(nightColorB, transitionColorB, sunsetLerp);
        //outputColor = mix(baseOutputColor, baseOutputColor * baseOutputColorModifier, mod(worldTime/6000f,2f));
    }

    //vec3 outputColor;
    if(starData.a > 0.5) {
        outputColor = vec4(1.0);
    } else {
        vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
        //float upDot = dot(pos, gbufferModelView[1].xyz);
        //gl_FragData[0] = vec4(upDot);
        outputColor = vec4(mix(pow(calcSkyColor(normalize(pos), currentColorA, currentColorB),vec3(1/2.2)),vec3(0),blindness),1.0);
        //discard;
    }

    /*if(timePhase < 4 && timePhase > 2) {
        outputColor.xyz *= vec3(0.1f);
    }*/

    //outputColor.xyz = unreal(outputColor.xyz);

    //gl_FragData[0] = vec4(outputColor, 1.0);
}