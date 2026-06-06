
/*
If you want to use animated perlin noise,
import this file after declaring "uniform float GameTime;" and define PERLIN_TIME.
*/

uint pcg_hash(uint x){
    uint state = x * 747796405u + 2891336453u;
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    return (word >> 22u) ^ word;
}

uint pcg_hash(vec2 v){
    return pcg_hash( uint(abs(dot(v.xy ,vec2(12.9898,78.233))*43758.5453)));
}

uint pcg_hash(vec3 v){
    return pcg_hash( uint(abs(dot(v.zyx ,vec3(16.5963,74.2449,100.5296))*59327.3996)));
}

uint pcg_hash(vec4 v){
    return pcg_hash( uint(abs(dot(v.zwxy ,vec4(16.5963,74.2449,100.5296,84.3979))*59327.3996)));
    //return pcg_hash( uint(abs( (((v.x + v.y) * v.y) * v.z) * v.w )));
}

float my_smoothstep(float x){
    //return x * x * x * (x * (x * 6. - 15.) + 10.);
    return x * x * (3.0 - x* 2.0);
}

float perlin_noise(vec2 p){

    const vec2 corners[] = vec2[](
        vec2( 1, 1),
        vec2(-1, 1),
        vec2( 1,-1),
        vec2(-1,-1),
        vec2(1,0),
        vec2(-1,0),
        vec2(0.,1),
        vec2(0.,-1)
    );

    vec2 p3   = vec2(floor(p.x) ,floor(p.y)  );
    vec2 p3x  = vec2(p3.x + 1.0, p3.y      );
    vec2 p3y  = vec2(p3.x      , p3.y + 1.0);
    vec2 p3xy = vec2(p3.x + 1.0, p3.y + 1.0);

    vec2 v   = corners[pcg_hash(p3)   % 4u];
    vec2 vx  = corners[pcg_hash(p3x)  % 4u];
    vec2 vy  = corners[pcg_hash(p3y)  % 4u];
    vec2 vxy = corners[pcg_hash(p3xy) % 4u];
    
    float c    = dot(p - p3  , v );
    float cx   = dot(p - p3x , vx );
    float cy   = dot(p - p3y , vy );
    float cxy  = dot(p - p3xy, vxy );

    vec2 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.xy = vec2(my_smoothstep(fract(p.x)),my_smoothstep(fract(p.y)));

    float val = mix(mix(c,cx,ratio.x),mix(cy,cxy,ratio.x),ratio.y);

    return val;
}

float perlin_noise(vec3 p){

    const vec3 corners[] = vec3[](
        vec3( 1, 1, 1),vec3(-1, 1, 1),
        vec3( 1,-1, 1),vec3(-1,-1, 1),
        vec3( 1, 1,-1),vec3(-1, 1,-1),
        vec3( 1,-1,-1),vec3(-1,-1,-1)
    );

    vec3 p3    = vec3(floor(p.x) ,floor(p.y) ,floor(p.z) );
    vec3 p3x   = vec3(p3.x + 1.0, p3.y      , p3.z );
    vec3 p3y   = vec3(p3.x      , p3.y + 1.0, p3.z );
    vec3 p3xy  = vec3(p3.x + 1.0, p3.y + 1.0, p3.z );
    vec3 p3z   = vec3(p3.x      , p3.y      , p3.z + 1.0 ); 
    vec3 p3xz  = vec3(p3.x + 1.0, p3.y      , p3.z + 1.0 );
    vec3 p3yz  = vec3(p3.x      , p3.y + 1.0, p3.z + 1.0 );
    vec3 p3xyz = vec3(p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );

    vec3 v    = corners[pcg_hash(p3)    % 8u];
    vec3 vx   = corners[pcg_hash(p3x)   % 8u];
    vec3 vy   = corners[pcg_hash(p3y)   % 8u];
    vec3 vxy  = corners[pcg_hash(p3xy)  % 8u];
    vec3 vz   = corners[pcg_hash(p3z)   % 8u];
    vec3 vxz  = corners[pcg_hash(p3xz)  % 8u];
    vec3 vyz  = corners[pcg_hash(p3yz)  % 8u];
    vec3 vxyz = corners[pcg_hash(p3xyz) % 8u];
    
    float c    = dot(p - p3  , v );
    float cx   = dot(p - p3x , vx );
    float cy   = dot(p - p3y , vy );
    float cxy  = dot(p - p3xy, vxy );
    float cz   = dot(p - p3z  , vz );
    float cxz  = dot(p - p3xz , vxz );
    float cyz  = dot(p - p3yz , vyz );
    float cxyz = dot(p - p3xyz, vxyz );

    vec3 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.xyz = vec3(my_smoothstep(fract(p.x)),my_smoothstep(fract(p.y)),my_smoothstep(fract(p.z)));

    float val = mix(
        mix(
            mix(c,cx,ratio.x),
            mix(cy,cxy,ratio.x),
            ratio.y),
        mix(
            mix(cz,cxz,ratio.x),
            mix(cyz,cxyz,ratio.x),
            ratio.y),
        ratio.z);

    return val;
}

#ifdef PERLIN_TIME

float loop(float value,float loop_length){
    return fract(value / loop_length) * loop_length;
}

float perlin_noise_t(vec2 p,float freqency,float phase){

    const vec3 corners[] = vec3[](
        vec3( 1, 1, 1),vec3(-1, 1, 1),
        vec3( 1,-1, 1),vec3(-1,-1, 1),
        vec3( 1, 1,-1),vec3(-1, 1,-1),
        vec3( 1,-1,-1),vec3(-1,-1,-1)
    );

    float daylength = 1200.0 * freqency;

    vec3 p2 = vec3(p.xy,GameTime * daylength + phase);

    vec3 p3    = vec3(floor(p2.x) ,floor(p2.y) , floor(p2.z) );
    vec3 p3x   = vec3(p3.x + 1.0, p3.y      , p3.z );
    vec3 p3y   = vec3(p3.x      , p3.y + 1.0, p3.z );
    vec3 p3xy  = vec3(p3.x + 1.0, p3.y + 1.0, p3.z );
    vec3 p3z   = vec3(p3.x      , p3.y      , p3.z + 1.0 ); 
    vec3 p3xz  = vec3(p3.x + 1.0, p3.y      , p3.z + 1.0 );
    vec3 p3yz  = vec3(p3.x      , p3.y + 1.0, p3.z + 1.0 );
    vec3 p3xyz = vec3(p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );

    vec3 v    = corners[pcg_hash(vec3( p3.xy,    loop( p3.z    , daylength ) ) ) % 8u];
    vec3 vx   = corners[pcg_hash(vec3( p3x.xy,   loop( p3x.z   , daylength ) ) ) % 8u];
    vec3 vy   = corners[pcg_hash(vec3( p3y.xy,   loop( p3y.z   , daylength ) ) ) % 8u];
    vec3 vxy  = corners[pcg_hash(vec3( p3xy.xy,  loop( p3xy.z  , daylength ) ) ) % 8u];
    vec3 vz   = corners[pcg_hash(vec3( p3z.xy,   loop( p3z.z   , daylength ) ) ) % 8u];
    vec3 vxz  = corners[pcg_hash(vec3( p3xz.xy,  loop( p3xz.z  , daylength ) ) ) % 8u];
    vec3 vyz  = corners[pcg_hash(vec3( p3yz.xy,  loop( p3yz.z  , daylength ) ) ) % 8u];
    vec3 vxyz = corners[pcg_hash(vec3( p3xyz.xy, loop( p3xyz.z , daylength ) ) ) % 8u];
    
    float c    = dot(p2 - p3   , v    );
    float cx   = dot(p2 - p3x  , vx   );
    float cy   = dot(p2 - p3y  , vy   );
    float cxy  = dot(p2 - p3xy , vxy  );
    float cz   = dot(p2 - p3z  , vz   );
    float cxz  = dot(p2 - p3xz , vxz  );
    float cyz  = dot(p2 - p3yz , vyz  );
    float cxyz = dot(p2 - p3xyz, vxyz );

    vec3 ratio;

    ratio.x = my_smoothstep(fract(p2.x));
    ratio.y = my_smoothstep(fract(p2.y));
    ratio.z = my_smoothstep(fract(p2.z));

    float val = mix(
        mix(
            mix(c,cx,ratio.x),
            mix(cy,cxy,ratio.x),
            ratio.y),
        mix(
            mix(cz,cxz,ratio.x),
            mix(cyz,cxyz,ratio.x),
            ratio.y),
        ratio.z);

    return val;
}

float perlin_noise_t(vec3 p,float freqency,float phase){

    const vec4 corners[] = vec4[](
        vec4( 1, 1, 1, 1),vec4(-1, 1, 1, 1),
        vec4( 1,-1, 1, 1),vec4(-1,-1, 1, 1),
        vec4( 1, 1,-1, 1),vec4(-1, 1,-1, 1),
        vec4( 1,-1,-1, 1),vec4(-1,-1,-1, 1),
        vec4( 1, 1, 1,-1),vec4(-1, 1, 1,-1),
        vec4( 1,-1, 1,-1),vec4(-1,-1, 1,-1),
        vec4( 1, 1,-1,-1),vec4(-1, 1,-1,-1),
        vec4( 1,-1,-1,-1),vec4(-1,-1,-1,-1)
    );

    float daylength = 2400.0 * freqency;

    vec4 p2 = vec4(p, GameTime * daylength + phase);

    vec4 p3     = vec4(floor(p2.x) ,floor(p2.y) ,floor(p2.z), floor(p2.w));
    vec4 p3x    = vec4( p3.x + 1.0, p3.y      , p3.z       , p3.w       );
    vec4 p3y    = vec4( p3.x      , p3.y + 1.0, p3.z       , p3.w       );
    vec4 p3xy   = vec4( p3.x + 1.0, p3.y + 1.0, p3.z       , p3.w       );
    vec4 p3z    = vec4( p3.x      , p3.y      , p3.z + 1.0 , p3.w       ); 
    vec4 p3xz   = vec4( p3.x + 1.0, p3.y      , p3.z + 1.0 , p3.w       );
    vec4 p3yz   = vec4( p3.x      , p3.y + 1.0, p3.z + 1.0 , p3.w       );
    vec4 p3xyz  = vec4( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 , p3.w       );
    vec4 p3w    = vec4( p3.x      , p3.y      , p3.z       , p3.w + 1.0 );
    vec4 p3xw   = vec4( p3.x + 1.0, p3.y      , p3.z       , p3.w + 1.0 );
    vec4 p3yw   = vec4( p3.x      , p3.y + 1.0, p3.z       , p3.w + 1.0 );
    vec4 p3xyw  = vec4( p3.x + 1.0, p3.y + 1.0, p3.z       , p3.w + 1.0 );
    vec4 p3zw   = vec4( p3.x      , p3.y      , p3.z + 1.0 , p3.w + 1.0 ); 
    vec4 p3xzw  = vec4( p3.x + 1.0, p3.y      , p3.z + 1.0 , p3.w + 1.0 );
    vec4 p3yzw  = vec4( p3.x      , p3.y + 1.0, p3.z + 1.0 , p3.w + 1.0 );
    vec4 p3xyzw = vec4( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 , p3.w + 1.0 );

    vec4 v     = corners[pcg_hash(vec4( p3.xyz,     loop( p3.w     , daylength) )) % 8u];
    vec4 vx    = corners[pcg_hash(vec4( p3x.xyz,    loop( p3x.w    , daylength) )) % 8u];
    vec4 vy    = corners[pcg_hash(vec4( p3y.xyz,    loop( p3y.w    , daylength) )) % 8u];
    vec4 vxy   = corners[pcg_hash(vec4( p3xy.xyz,   loop( p3xy.w   , daylength) )) % 8u];
    vec4 vz    = corners[pcg_hash(vec4( p3z.xyz,    loop( p3z.w    , daylength) )) % 8u];
    vec4 vxz   = corners[pcg_hash(vec4( p3xz.xyz,   loop( p3xz.w   , daylength) )) % 8u];
    vec4 vyz   = corners[pcg_hash(vec4( p3yz.xyz,   loop( p3yz.w   , daylength) )) % 8u];
    vec4 vxyz  = corners[pcg_hash(vec4( p3xyz.xyz,  loop( p3xyz.w  , daylength) )) % 8u];
    vec4 vw    = corners[pcg_hash(vec4( p3w.xyz,    loop( p3w.w    , daylength) )) % 8u];
    vec4 vxw   = corners[pcg_hash(vec4( p3xw.xyz,   loop( p3xw.w   , daylength) )) % 8u];
    vec4 vyw   = corners[pcg_hash(vec4( p3yw.xyz,   loop( p3yw.w   , daylength) )) % 8u];
    vec4 vxyw  = corners[pcg_hash(vec4( p3xyw.xyz,  loop( p3xyw.w  , daylength) )) % 8u];
    vec4 vzw   = corners[pcg_hash(vec4( p3zw.xyz,   loop( p3zw.w   , daylength) )) % 8u];
    vec4 vxzw  = corners[pcg_hash(vec4( p3xzw.xyz,  loop( p3xzw.w  , daylength) )) % 8u];
    vec4 vyzw  = corners[pcg_hash(vec4( p3yzw.xyz,  loop( p3yzw.w  , daylength) )) % 8u];
    vec4 vxyzw = corners[pcg_hash(vec4( p3xyzw.xyz, loop( p3xyzw.w , daylength) )) % 8u];
    
    float c     = dot(p2 - p3     , v     );
    float cx    = dot(p2 - p3x    , vx    );
    float cy    = dot(p2 - p3y    , vy    );
    float cxy   = dot(p2 - p3xy   , vxy   );
    float cz    = dot(p2 - p3z    , vz    );
    float cxz   = dot(p2 - p3xz   , vxz   );
    float cyz   = dot(p2 - p3yz   , vyz   );
    float cxyz  = dot(p2 - p3xyz  , vxyz  );
    float cw    = dot(p2 - p3w    , vw    );
    float cxw   = dot(p2 - p3xw   , vxw   );
    float cyw   = dot(p2 - p3yw   , vyw   );
    float cxyw  = dot(p2 - p3xyw  , vxyw  );
    float czw   = dot(p2 - p3zw   , vzw   );
    float cxzw  = dot(p2 - p3xzw  , vxzw  );
    float cyzw  = dot(p2 - p3yzw  , vyzw  );
    float cxyzw = dot(p2 - p3xyzw , vxyzw );

    vec4 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.x = my_smoothstep(fract(p2.x));
    ratio.y = my_smoothstep(fract(p2.y));
    ratio.z = my_smoothstep(fract(p2.z));
    ratio.w = my_smoothstep(fract(p2.w));

    float val = mix(
        mix(
            mix(
                mix(c,    cx,    ratio.x),
                mix(cy,   cxy,   ratio.x),
                ratio.y),
            mix(
                mix(cz,   cxz,   ratio.x),
                mix(cyz,  cxyz,  ratio.x),
                ratio.y),
        ratio.z),
        mix(
            mix(
                mix(cw,   cxw,   ratio.x),
                mix(cyw,  cxyw,  ratio.x),
                ratio.y),
            mix(
                mix(czw,  cxzw,  ratio.x),
                mix(cyzw, cxyzw, ratio.x),
                ratio.y),
        ratio.z),
    ratio.w);

    return val;
}

#endif