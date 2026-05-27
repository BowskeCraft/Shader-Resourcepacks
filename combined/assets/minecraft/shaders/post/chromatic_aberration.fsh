#version 330

uniform sampler2D InSampler;

/*
layout(std140) uniform BlitConfig {
    vec4 ColorModulate;
};
*/

layout(std140) uniform ChromAbbrConfig {
    float ResizeScale;
    vec3 DistortStrength;
};



in vec2 texCoord;

out vec4 fragColor;


vec2 lens_distort(vec2 coord_in, float strength,float scale){
    vec2 pos_in = coord_in - vec2(0.5);
    float eccentricity = length(pos_in);
    //vec2 pos_out = normalize(pos_in) * (eccentricity + strength * eccentricity * eccentricity) / scale;
    vec2 pos_out = pos_in * (1.0 + strength * eccentricity * eccentricity) / scale;
    return (pos_out + vec2(0.5));
}

void main(){

    float colorR = texture(InSampler, lens_distort(texCoord, DistortStrength.r, ResizeScale)).r;
    float colorG = texture(InSampler, lens_distort(texCoord, DistortStrength.g, ResizeScale)).g;
    float colorB = texture(InSampler, lens_distort(texCoord, DistortStrength.b, ResizeScale)).b;

    fragColor = vec4(colorR,colorG,colorB,1.0);
}
