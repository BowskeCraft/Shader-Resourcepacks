#version 330

uniform sampler2D BaseSampler;
uniform sampler2D OverlaySampler;

layout(std140) uniform MixConfig {
    float MixAlpha;
};

in vec2 texCoord;

out vec4 fragColor;

void main(){
    vec4 bottom_color = texture(BaseSampler,texCoord);
    vec4 top_color = texture(OverlaySampler,texCoord);

    float mix_ratio = MixAlpha * top_color.a;

    fragColor = mix(bottom_color,top_color,mix_ratio);
}
