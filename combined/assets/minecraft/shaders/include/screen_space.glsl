const float FOV_SCALE = 1.4;

float depth_to_z(float depth){
    return -0.05 / (depth - 1.0) ;
}

float z_to_depth(float z){
    return 1.0 - 0.05 / z;
}

vec3 screen_to_pos(vec2 coord,float depth, vec2 sampler_size){
    
    float pos_z = depth_to_z(depth);

    vec2 pos_xy = (coord - 0.5); // middle-centered
    pos_xy *= (depth == 1.0) ? 1.0 : pos_z; //persepective
    pos_xy *= vec2(sampler_size.x / sampler_size.y, 1.0); //aspect ratio
    pos_xy *= FOV_SCALE; //fov

    return vec3(pos_xy, pos_z);
}

vec3 pos_to_screen(vec3 pos, vec2 sampler_size){

    vec2 coord = pos.xy;
    coord /= (vec2(sampler_size.x / sampler_size.y,1.0) * FOV_SCALE * pos.z);
    coord += 0.5;

    float depth = z_to_depth(pos.z);

    return vec3(coord,depth);
}

vec3 depth_buffer_to_pos(sampler2D depth_sampler,vec2 sampler_size,vec2 coord){
    float depth = texture(depth_sampler,coord).r;
    return screen_to_pos(coord,depth,sampler_size);
}

vec3 depth_buffer_to_normal(sampler2D depth_sampler,vec2 sampler_size,vec2 uv_pos){
    vec3 diff_x = depth_buffer_to_pos(depth_sampler, sampler_size, (uv_pos + vec2(1.0,0.0) / sampler_size)) - depth_buffer_to_pos(depth_sampler, sampler_size, (uv_pos - vec2(1.0,0.0) / sampler_size));
    vec3 diff_y = depth_buffer_to_pos(depth_sampler, sampler_size, (uv_pos + vec2(0.0,1.0) / sampler_size)) - depth_buffer_to_pos(depth_sampler, sampler_size, (uv_pos - vec2(0.0,1.0) / sampler_size));

    return normalize(cross(diff_y,diff_x)); //left,up,forward is positive
}