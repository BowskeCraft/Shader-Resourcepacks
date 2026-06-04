#version 330

uniform sampler2D InSampler;
uniform sampler2D InDepthSampler;
uniform sampler2D MainDepthSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 InDepthSize;
    vec2 MainDepthSize;
};

const int MAX_STEPS = 64;
const float STEP_SCALE = 0.01;

in vec2 texCoord;

out vec4 fragColor;

//#moj_import <minecraft:globals.glsl>
//#moj_import <minecraft:dynamictransforms.glsl>
//#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:screen_space.glsl>

vec3 raytrace(vec3 origin,vec3 dir){
    
    vec2 sampler_size = InDepthSize;

    // position in screen space
    vec3 coord = pos_to_depth(origin, sampler_size);
    vec3 next_coord = pos_to_depth(origin + dir, sampler_size);

    //direction in screen space
    vec3 dir_s = normalize(next_coord - coord) * STEP_SCALE;

    float initial_depth = coord.z;
    float sampler_depth = 0.0;

    for(int i = 0; i < MAX_STEPS; i++){

        sampler_depth = texture(InDepthSampler,coord.xy).r;

        //detect intersection
        if(coord.z > sampler_depth && initial_depth < sampler_depth){
            return coord;
        }
        
        next_coord = coord + dir_s;
        
        if(any(lessThan(next_coord,vec3(0.0)))||any(greaterThan(next_coord,vec3(1.0)))){
            return coord;
        }
        coord = next_coord;
        
    }

    coord = pos_to_depth(dir,InDepthSize);//Treat as infinite far
    return coord;
}


void main(){

    float initial_main_depth = texture(MainDepthSampler, texCoord).r;
    float initial_depth = texture(InDepthSampler, texCoord).r;

    
    vec4 surface_color = texture(InSampler, texCoord);

    
    vec4 reflect_color = vec4(1.0);
    float reflect_ratio = 0.0;

    //if(true){   
    if(initial_depth < initial_main_depth){
        
        vec3 normal = depth_to_normal(InDepthSampler,InDepthSize,texCoord);
        //reflect_color = vec4(normal * 0.5 + 0.5,1.0);

        vec3 ray_origin = depth_to_pos(texCoord,initial_depth,InDepthSize);
        //reflect_color = vec4(fract(ray_origin),1.0);

        vec3 ray_direction = reflect(normalize(ray_origin),normal);
        //reflect_color = vec4(ray_direction * 0.5 + 0.5,1.0);

        vec3 reflect_coord = raytrace(ray_origin,ray_direction);
        reflect_color = texture(InSampler,reflect_coord.xy);
        

        reflect_ratio =  reflect_color.a * 0.7 ;
        
        //reflect_ratio *= length(cross(normal,ray_direction));
        reflect_ratio *= 1.0 - dot(normal,ray_direction);
        //reflect_ratio *= max(dot(normalize(ray_origin),ray_direction),0.0);

        vec2 uvFactor = max(reflect_coord.xy*(vec2(1.0)-reflect_coord.xy),0.0);
        reflect_ratio *= (uvFactor.x * uvFactor.y) * 16.0;

        //float eccentricity = length(reflect_coord - 0.5) * 2;
        //reflect_ratio *= max(1.0 - eccentricity * eccentricity,1.0);

        
        //reflect_color = vec4(ray_direction * 0.5 + 0.5,1.0);
        //reflect_ratio = 1.0;
    }
    

    fragColor = (1.0 - reflect_ratio) * surface_color + reflect_ratio * vec4(reflect_color.rgb,1.0);
    
    //fragColor = initial_depth;
    
}
