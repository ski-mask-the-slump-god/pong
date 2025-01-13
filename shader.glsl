extern sampler2D tex;         // Texture sampler (input image)
extern vec2 resolution;       // Screen resolution
extern float millis;          // Time in seconds

vec2 curve(vec2 uv) {
    uv = (uv - 0.5) * 2.0;     // Center the UV coordinates
    uv *= 1.1;                 // Slight zoom for a rounded effect
    uv.x *= 1.0 + pow(abs(uv.y) / 5.0, 2.0);
    uv.y *= 1.0 + pow(abs(uv.x) / 4.0, 2.0);
    uv = (uv / 2.0) + 0.5;     // Back to normalized coordinates
    uv = uv * 0.92 + 0.04;     // Add padding
    return uv;
}

float scanline(vec2 uv) {
    return 0.5 + 0.5 * sin(uv.y * resolution.y * 3.0 + millis * 10.0);
}

float vignette(vec2 uv) {
    uv = uv * 2.0 - 1.0;       // Normalize to [-1, 1]
    float radius = length(uv);
    return smoothstep(0.8, 0.4, radius);  // Darken edges
}

vec4 effect(vec4 color, Image tex, vec2 TexCoord, vec2 screenCoord) {
    vec2 uv = TexCoord / resolution;
    uv = curve(uv);             // Apply screen curvature

    // Sample the texture
    vec3 col = Texel(tex, uv).rgb;

    // Add scanlines
    col *= scanline(uv);

    // Add color distortion (slight chromatic aberration)
    col.r = Texel(tex, uv + vec2(0.002, 0.0)).r;
    col.g = Texel(tex, uv + vec2(-0.002, 0.002)).g;
    col.b = Texel(tex, uv + vec2(0.0, -0.002)).b;

    // Apply vignette
    col *= vignette(uv);

    // Slight flicker effect
    col *= 1.0 + 0.02 * sin(millis * 50.0);

    return vec4(col, 1.0);
}

