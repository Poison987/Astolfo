#version 460 compatibility

varying vec2 TexCoords;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

in vec3 vaPosition;

in vec2 vaUV0;

out vec4 starData;

void main() {
    float timeOfDay = mod(worldTime,24000);
    quadTime = timeOfDay;
    if(timeOfDay < 250) {
        timePhase = 3;
        quadTime += 250;
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
    vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;
    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);
    gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
    //gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition+chunkOffset - .1 * distanceFromCamera, 1);
    TexCoords = vaUV0;
}