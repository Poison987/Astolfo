uniform int isEyeInWater;

vec3 isInWater(sampler2D mainTex, vec3 color, vec2 coord, vec2 distortionAmount, float colorFactor) {
    if(isEyeInWater != 1) {
        return texture2D(mainTex, coord).rgb;
    }

    vec3 underwaterColor = texture2D(mainTex, coord + distortionAmount).rgb;
    underwaterColor = mix(underwaterColor, color, colorFactor);
    return underwaterColor;
}