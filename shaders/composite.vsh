#version 120

varying vec2 TexCoords;
varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;
varying vec2 LightmapCoords;

in ivec2 vaUV2;

out vec3 viewSpaceFragPosition;

uniform sampler2D noise;

void main() {
    gl_Position = ftransform();
    viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;
    LightmapCoords = vaUV2;
    float timeOfDay = mod(worldTime,24000);
    quadTime = timeOfDay;
    if(timeOfDay < 250) {
        timePhase = 3;
        quadTime += 500;
    } else if(timeOfDay < 11750) {
        timePhase = 0;
        quadTime -= 250;
    } else if(timeOfDay < 12250) {
        timePhase = 1;
        quadTime -= 11750;
    } else if(timeOfDay < 23750) {
        timePhase = 2;
        quadTime -= 12250;
    } else if(timeOfDay < 24000) {
        timePhase = 3;
        quadTime -= 23250;
    }
    if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0) {
        vec4 noiseMap = texture2D(noise, TexCoords + sin(gl_Position.y*32f + ((frameCounter)/90f)*0.25f));
        vec4 noiseMap2 = texture2D(noise, TexCoords + sin(gl_Position.y*16f + ((frameCounter)/90f)*0.25f));
        vec4 finalNoise = mix(noiseMap,noiseMap2,0.5f);

        gl_Position.xy += finalNoise.xy;
        //vec3 Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f) + finalNoise.xyz;
    }
    TexCoords = gl_MultiTexCoord0.st;
}