#version 330

uniform sampler2D MainSampler;
uniform sampler2D MainDepthSampler;
uniform sampler2D TranslucentSampler;
uniform sampler2D TranslucentDepthSampler;
uniform sampler2D ItemEntitySampler;
uniform sampler2D ItemEntityDepthSampler;
uniform sampler2D ParticlesSampler;
uniform sampler2D ParticlesDepthSampler;
uniform sampler2D WeatherSampler;
uniform sampler2D WeatherDepthSampler;
uniform sampler2D CloudsSampler;
uniform sampler2D CloudsDepthSampler;

in vec2 texCoord;

vec4 color_layers[6] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
float depth_layers[6] = float[](0, 0, 0, 0, 0, 0);
int active_layers = 0;

const float alphaCorrectionLimit = 0.92;
const float alphaCorrectionSlope = 0.05;

out vec4 fragColor;

void try_insert(vec4 color, float depth) {
    if (color.a == 0.0) {
        return;
    }

    color_layers[active_layers] = color;
    depth_layers[active_layers] = depth;

    int jj = active_layers++;
    int ii = jj - 1;
    while (jj > 0 && depth_layers[jj] < depth_layers[ii]) {
        float depthTemp = depth_layers[ii];
        depth_layers[ii] = depth_layers[jj];
        depth_layers[jj] = depthTemp;

        vec4 colorTemp = color_layers[ii];
        color_layers[ii] = color_layers[jj];
        color_layers[jj] = colorTemp;

        jj = ii--;
    }
}

vec3 blend(vec3 dst, vec4 src) {
    return (dst * (1.0 - src.a)) + src.rgb;
}

vec3 blend2(vec3 dst, vec4 src,float depth_dst,float depth_src) {
    if(src.a == 0.0){
        return dst;
    }
    if(src.a >= 0.9){
        return src.rgb;
    }

    //float depth_dst2 = -1 + 1/(1 - depth_dst);
    //float depth_src2 = -1 + 1/(1 - depth_src);

    //float thickness = 1 - (1 / (1 + 0.05 * (depth_dst2 - depth_src2)));
    float thickness = 1.0 - (alphaCorrectionLimit / (1.0 + alphaCorrectionSlope * (1.0 / depth_dst - 1.0 / depth_src)));
    //float thickness = min(0.05 * ( 1/(1 - depth_dst) - 1/(1 - depth_src)),1.0); 

    return (dst * (1.0 - (src.a * thickness))) + (src.rgb * thickness);
}

void main() {
    color_layers[0] = vec4(texture(MainSampler, texCoord).rgb, 1.0);
    depth_layers[0] = texture(MainDepthSampler, texCoord).r;
    active_layers = 1;

    try_insert(texture(TranslucentSampler, texCoord), texture(TranslucentDepthSampler, texCoord).r);
    try_insert(texture(ItemEntitySampler, texCoord), texture(ItemEntityDepthSampler, texCoord).r);
    try_insert(texture(ParticlesSampler, texCoord), texture(ParticlesDepthSampler, texCoord).r);
    try_insert(texture(WeatherSampler, texCoord), texture(WeatherDepthSampler, texCoord).r);
    try_insert(texture(CloudsSampler, texCoord), texture(CloudsDepthSampler, texCoord).r);

    vec3 texelAccum = color_layers[0].rgb;
    for (int ii = 1; ii < active_layers; ++ii) {
        //texelAccum = blend(texelAccum, color_layers[ii]);
        texelAccum = blend2(texelAccum, color_layers[ii], depth_layers[ii-1], depth_layers[ii]);
    }
    //texelAccum.rgb *= 0.5;

    fragColor = vec4(texelAccum.rgb, 1.0);
}
