#version 330

uniform sampler2D InSampler;
uniform sampler2D InDepthSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};


layout(std140) uniform DoFOptions{
    float DoFStrength;
    float FocusMin;
    float FocusMax;
};

in vec2 texCoord;

out vec4 fragColor;

vec2 offsetPos(vec2 origin,vec2 offset){
    return origin + offset / InSize;
}

void main(){
    
    float focal_depth = clamp(texture(InDepthSampler, vec2(0.5)).r,FocusMin,FocusMax);

    float current_depth = texture(InDepthSampler,texCoord).r;

    float depth_diff = (1.0 - min(current_depth,focal_depth) / max(current_depth,focal_depth)) * DoFStrength;

    vec3 color = vec3(0.0);
    color += texture(InSampler, offsetPos(texCoord,vec2( 1.0, 0.0 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2( 0.7, 0.7 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2( 0.0, 1.0 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2(-0.7, 0.7 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2(-1.0, 0.0 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2(-0.7,-0.7 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2( 0.0,-1.0 )*depth_diff)).rgb;
    color += texture(InSampler, offsetPos(texCoord,vec2( 0.7,-0.7 )*depth_diff)).rgb;
    color *= 0.125;

    //fragColor = texture(InSampler, texCoord);

    fragColor = vec4(color,1.0);
}
