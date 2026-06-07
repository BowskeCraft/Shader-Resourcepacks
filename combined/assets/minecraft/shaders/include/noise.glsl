
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
#ifdef NOISE_DIFFERENTIABLE
    return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
#else
    return x * x * (3.0 - x* 2.0);
#endif
}

vec2 my_smoothstep(vec2 x){
    //return x * x * x * (x * (x * 6. - 15.) + 10.);
    return vec2(my_smoothstep(x.x),my_smoothstep(x.y));
}
vec3 my_smoothstep(vec3 x){
    //return x * x * x * (x * (x * 6. - 15.) + 10.);
    return vec3(my_smoothstep(x.x),my_smoothstep(x.y),my_smoothstep(x.z));
}
vec4 my_smoothstep(vec4 x){
    //return x * x * x * (x * (x * 6. - 15.) + 10.);
    return vec4(my_smoothstep(x.x),my_smoothstep(x.y),my_smoothstep(x.z),my_smoothstep(x.w));
}

float perlin_noise(vec2 p){

    const vec2 corners[] = vec2[](
        vec2( 1, 1),
        vec2(-1, 1),
        vec2( 1,-1),
        vec2(-1,-1)
    );

    vec2 p3   = vec2(floor(p.x) ,floor(p.y) );
    vec2 p3x  = vec2(p3.x + 1.0, p3.y       );
    vec2 p3y  = vec2(p3.x      , p3.y + 1.0 );
    vec2 p3xy = vec2(p3.x + 1.0, p3.y + 1.0 );

    uint h   = pcg_hash(p3)   ;
    uint hx  = pcg_hash(p3x)  ;
    uint hy  = pcg_hash(p3y)  ;
    uint hxy = pcg_hash(p3xy) ;

    vec2 v   = p - p3;
    vec2 vx  = p - p3x;
    vec2 vy  = p - p3y;
    vec2 vxy = p - p3xy;
    
    float c    = dot( v  , corners[h   & 3u] );
    float cx   = dot( vx , corners[hx  & 3u] );
    float cy   = dot( vy , corners[hy  & 3u] );
    float cxy  = dot( vxy, corners[hxy & 3u] );

    vec2 ratio = my_smoothstep(v);

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

    vec3 p3     = floor(p);//vec3(floor(p2.x) ,floor(p2.y) ,floor(p2.z));
    vec3 p3xyz  = p3 + 1.0; //vec3( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );
    vec3 p3x    = vec3( p3xyz.x , p3.y    , p3.z    );
    vec3 p3y    = vec3( p3.x    , p3xyz.y , p3.z    );
    vec3 p3xy   = vec3( p3xyz.x , p3xyz.y , p3.z    );
    vec3 p3z    = vec3( p3.x    , p3.y    , p3xyz.z ); 
    vec3 p3xz   = vec3( p3xyz.x , p3.y    , p3xyz.z );
    vec3 p3yz   = vec3( p3.x    , p3xyz.y , p3xyz.z );

    uint h    = pcg_hash(p3)   ;
    uint hx   = pcg_hash(p3x)  ;
    uint hy   = pcg_hash(p3y)  ;
    uint hxy  = pcg_hash(p3xy) ;
    uint hz   = pcg_hash(p3z)  ;
    uint hxz  = pcg_hash(p3xz) ;
    uint hyz  = pcg_hash(p3yz) ;
    uint hxyz = pcg_hash(p3xyz);

    vec3 v    = p - p3   ;
    vec3 vx   = p - p3x  ;
    vec3 vy   = p - p3y  ;
    vec3 vxy  = p - p3xy ;
    vec3 vz   = p - p3z  ;
    vec3 vxz  = p - p3xz ;
    vec3 vyz  = p - p3yz ;
    vec3 vxyz = p - p3xyz;
    
    float c    = dot( v  ,  corners[h    & 7u] );
    float cx   = dot( vx ,  corners[hx   & 7u] );
    float cy   = dot( vy ,  corners[hy   & 7u] );
    float cxy  = dot( vxy,  corners[hxy  & 7u] );
    float cz   = dot( vz  , corners[hz   & 7u] );
    float cxz  = dot( vxz , corners[hxz  & 7u] );
    float cyz  = dot( vyz , corners[hyz  & 7u] );
    float cxyz = dot( vxyz, corners[hxyz & 7u] );

    vec3 ratio = my_smoothstep(v);

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
vec2 perlin_noise_2d(vec2 p){

    const vec2 corners[] = vec2[](
        vec2( 1, 1),
        vec2(-1, 1),
        vec2( 1,-1),
        vec2(-1,-1)
    );

    vec2 p3   = vec2(floor(p.x) ,floor(p.y)  );
    vec2 p3x  = vec2(p3.x + 1.0, p3.y      );
    vec2 p3y  = vec2(p3.x      , p3.y + 1.0);
    vec2 p3xy = vec2(p3.x + 1.0, p3.y + 1.0);

    uint h   = pcg_hash(p3)   ;
    uint hx  = pcg_hash(p3x)  ;
    uint hy  = pcg_hash(p3y)  ;
    uint hxy = pcg_hash(p3xy) ;
    
    vec2 v   = p - p3;
    vec2 vx  = p - p3x;
    vec2 vy  = p - p3y;
    vec2 vxy = p - p3xy;

    vec2 c    = vec2( dot( v  , corners[h   & 3u] ), dot( v  , corners[(h  >> 2) & 3u] ) );
    vec2 cx   = vec2( dot( vx , corners[hx  & 3u] ), dot( vx , corners[(hx >> 2) & 3u] ) );
    vec2 cy   = vec2( dot( vy , corners[hy  & 3u] ), dot( vy , corners[(hy >> 2) & 3u] ) );
    vec2 cxy  = vec2( dot( vxy, corners[hxy & 3u] ), dot( vxy, corners[(hxy>> 2) & 3u] ) );

    vec2 ratio = my_smoothstep(v);

    vec2 val = mix(mix(c,cx,ratio.x),mix(cy,cxy,ratio.x),ratio.y);

    return val;
}

vec2 perlin_noise_2d(vec3 p){

    const vec3 corners[] = vec3[](
        vec3( 1, 1, 1),vec3(-1, 1, 1),
        vec3( 1,-1, 1),vec3(-1,-1, 1),
        vec3( 1, 1,-1),vec3(-1, 1,-1),
        vec3( 1,-1,-1),vec3(-1,-1,-1)
    );

    vec3 p3     = floor(p);//vec3(floor(p2.x) ,floor(p2.y) ,floor(p2.z));
    vec3 p3xyz  = p3 + 1.0; //vec3( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );
    vec3 p3x    = vec3( p3xyz.x , p3.y    , p3.z    );
    vec3 p3y    = vec3( p3.x    , p3xyz.y , p3.z    );
    vec3 p3xy   = vec3( p3xyz.x , p3xyz.y , p3.z    );
    vec3 p3z    = vec3( p3.x    , p3.y    , p3xyz.z ); 
    vec3 p3xz   = vec3( p3xyz.x , p3.y    , p3xyz.z );
    vec3 p3yz   = vec3( p3.x    , p3xyz.y , p3xyz.z );

    uint h    = pcg_hash(p3)   ;
    uint hx   = pcg_hash(p3x)  ;
    uint hy   = pcg_hash(p3y)  ;
    uint hxy  = pcg_hash(p3xy) ;
    uint hz   = pcg_hash(p3z)  ;
    uint hxz  = pcg_hash(p3xz) ;
    uint hyz  = pcg_hash(p3yz) ;
    uint hxyz = pcg_hash(p3xyz);

    vec3 v    = p - p3   ;
    vec3 vx   = p - p3x  ;
    vec3 vy   = p - p3y  ;
    vec3 vxy  = p - p3xy ;
    vec3 vz   = p - p3z  ;
    vec3 vxz  = p - p3xz ;
    vec3 vyz  = p - p3yz ;
    vec3 vxyz = p - p3xyz;

    
    vec2 c    = vec2( dot( v  ,  corners[h    & 7u] ),dot( v  ,  corners[(h    >> 3) & 7u] ) );
    vec2 cx   = vec2( dot( vx ,  corners[hx   & 7u] ),dot( vx ,  corners[(hx   >> 3) & 7u] ) );
    vec2 cy   = vec2( dot( vy ,  corners[hy   & 7u] ),dot( vy ,  corners[(hy   >> 3) & 7u] ) );
    vec2 cxy  = vec2( dot( vxy,  corners[hxy  & 7u] ),dot( vxy,  corners[(hxy  >> 3) & 7u] ) );
    vec2 cz   = vec2( dot( vz  , corners[hz   & 7u] ),dot( vz  , corners[(hz   >> 3) & 7u] ) );
    vec2 cxz  = vec2( dot( vxz , corners[hxz  & 7u] ),dot( vxz , corners[(hxz  >> 3) & 7u] ) );
    vec2 cyz  = vec2( dot( vyz , corners[hyz  & 7u] ),dot( vyz , corners[(hyz  >> 3) & 7u] ) );
    vec2 cxyz = vec2( dot( vxyz, corners[hxyz & 7u] ),dot( vxyz, corners[(hxyz >> 3) & 7u] ) );

    vec3 ratio = my_smoothstep(v);

    vec2 val = mix(
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

vec3 perlin_noise_3d(vec2 p){

    const vec2 corners[] = vec2[](
        vec2( 1, 1),
        vec2(-1, 1),
        vec2( 1,-1),
        vec2(-1,-1)
    );

    vec2 p3   = vec2(floor(p.x) ,floor(p.y)  );
    vec2 p3x  = vec2(p3.x + 1.0, p3.y      );
    vec2 p3y  = vec2(p3.x      , p3.y + 1.0);
    vec2 p3xy = vec2(p3.x + 1.0, p3.y + 1.0);

    uint h   = pcg_hash(p3)   ;
    uint hx  = pcg_hash(p3x)  ;
    uint hy  = pcg_hash(p3y)  ;
    uint hxy = pcg_hash(p3xy) ;

    vec2 v   = p - p3;
    vec2 vx  = p - p3x;
    vec2 vy  = p - p3y;
    vec2 vxy = p - p3xy;
    
    vec3 c    = vec3( dot( v  , corners[h   & 3u] ), dot( v  , corners[(h  >> 2) & 3u] ), dot( v  , corners[(h  >> 4) & 3u] ) );
    vec3 cx   = vec3( dot( vx , corners[hx  & 3u] ), dot( vx , corners[(hx >> 2) & 3u] ), dot( vx , corners[(hx >> 4) & 3u] ) );
    vec3 cy   = vec3( dot( vy , corners[hy  & 3u] ), dot( vy , corners[(hy >> 2) & 3u] ), dot( vy , corners[(hy >> 4) & 3u] ) );
    vec3 cxy  = vec3( dot( vxy, corners[hxy & 3u] ), dot( vxy, corners[(hxy>> 2) & 3u] ), dot( vxy, corners[(hxy>> 4) & 3u] ) );

    vec2 ratio = my_smoothstep(v);

    vec3 val = mix(mix(c,cx,ratio.x),mix(cy,cxy,ratio.x),ratio.y);

    return val;
}

vec3 perlin_noise_3d(vec3 p){

    const vec3 corners[] = vec3[](
        vec3( 1, 1, 1),vec3(-1, 1, 1),
        vec3( 1,-1, 1),vec3(-1,-1, 1),
        vec3( 1, 1,-1),vec3(-1, 1,-1),
        vec3( 1,-1,-1),vec3(-1,-1,-1)
    );

    vec3 p3     = floor(p);//vec3(floor(p2.x) ,floor(p2.y) ,floor(p2.z));
    vec3 p3xyz  = p3 + 1.0; //vec3( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );
    vec3 p3x    = vec3( p3xyz.x , p3.y    , p3.z    );
    vec3 p3y    = vec3( p3.x    , p3xyz.y , p3.z    );
    vec3 p3xy   = vec3( p3xyz.x , p3xyz.y , p3.z    );
    vec3 p3z    = vec3( p3.x    , p3.y    , p3xyz.z ); 
    vec3 p3xz   = vec3( p3xyz.x , p3.y    , p3xyz.z );
    vec3 p3yz   = vec3( p3.x    , p3xyz.y , p3xyz.z );

    uint h    = pcg_hash(p3)   ;
    uint hx   = pcg_hash(p3x)  ;
    uint hy   = pcg_hash(p3y)  ;
    uint hxy  = pcg_hash(p3xy) ;
    uint hz   = pcg_hash(p3z)  ;
    uint hxz  = pcg_hash(p3xz) ;
    uint hyz  = pcg_hash(p3yz) ;
    uint hxyz = pcg_hash(p3xyz);

    vec3 v    = p - p3   ;
    vec3 vx   = p - p3x  ;
    vec3 vy   = p - p3y  ;
    vec3 vxy  = p - p3xy ;
    vec3 vz   = p - p3z  ;
    vec3 vxz  = p - p3xz ;
    vec3 vyz  = p - p3yz ;
    vec3 vxyz = p - p3xyz;
    
    vec3 c    = vec3( dot( v  ,  corners[h    & 7u] ),dot( v  ,  corners[(h    >> 3) & 7u] ),dot( v  ,  corners[(h    >> 6) & 7u] ) );
    vec3 cx   = vec3( dot( vx ,  corners[hx   & 7u] ),dot( vx ,  corners[(hx   >> 3) & 7u] ),dot( vx ,  corners[(hx   >> 6) & 7u] ) );
    vec3 cy   = vec3( dot( vy ,  corners[hy   & 7u] ),dot( vy ,  corners[(hy   >> 3) & 7u] ),dot( vy ,  corners[(hy   >> 6) & 7u] ) );
    vec3 cxy  = vec3( dot( vxy,  corners[hxy  & 7u] ),dot( vxy,  corners[(hxy  >> 3) & 7u] ),dot( vxy,  corners[(hxy  >> 6) & 7u] ) );
    vec3 cz   = vec3( dot( vz  , corners[hz   & 7u] ),dot( vz  , corners[(hz   >> 3) & 7u] ),dot( vz  , corners[(hz   >> 6) & 7u] ) );
    vec3 cxz  = vec3( dot( vxz , corners[hxz  & 7u] ),dot( vxz , corners[(hxz  >> 3) & 7u] ),dot( vxz , corners[(hxz  >> 6) & 7u] ) );
    vec3 cyz  = vec3( dot( vyz , corners[hyz  & 7u] ),dot( vyz , corners[(hyz  >> 3) & 7u] ),dot( vyz , corners[(hyz  >> 6) & 7u] ) );
    vec3 cxyz = vec3( dot( vxyz, corners[hxyz & 7u] ),dot( vxyz, corners[(hxyz >> 3) & 7u] ),dot( vxyz, corners[(hxyz >> 6) & 7u] ) );

    vec3 ratio = my_smoothstep(v);

    vec3 val = mix(
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

const float DaySec = 1200.0;

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

    float daylength = DaySec * freqency;

    vec3 p2 = vec3(p.xy,GameTime * daylength + phase);

    vec3 p3     = floor(p2);//vec3(floor(p2.x) ,floor(p2.y) ,floor(p2.z));
    vec3 p3xyz  = p3 + 1.0; //vec3( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );
    vec3 p3x    = vec3( p3xyz.x , p3.y    , p3.z    );
    vec3 p3y    = vec3( p3.x    , p3xyz.y , p3.z    );
    vec3 p3xy   = vec3( p3xyz.x , p3xyz.y , p3.z    );
    vec3 p3z    = vec3( p3.x    , p3.y    , p3xyz.z ); 
    vec3 p3xz   = vec3( p3xyz.x , p3.y    , p3xyz.z );
    vec3 p3yz   = vec3( p3.x    , p3xyz.y , p3xyz.z );

    float time0 = loop( p3.z    , daylength);
    float time1 = loop( p3xyz.z , daylength);

    uint h     = pcg_hash(vec4( p3.xyz,     time0 ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    time0 ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    time0 ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   time0 ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    time1 ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   time1 ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   time1 ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  time1 ));
    
    vec3 v    = p2 - p3   ;
    vec3 vx   = p2 - p3x  ;
    vec3 vy   = p2 - p3y  ;
    vec3 vxy  = p2 - p3xy ;
    vec3 vz   = p2 - p3z  ;
    vec3 vxz  = p2 - p3xz ;
    vec3 vyz  = p2 - p3yz ;
    vec3 vxyz = p2 - p3xyz;

    float c    = dot( v   , corners[h    & 7u] );
    float cx   = dot( vx  , corners[hx   & 7u] );
    float cy   = dot( vy  , corners[hy   & 7u] );
    float cxy  = dot( vxy , corners[hxy  & 7u] );
    float cz   = dot( vz  , corners[hz   & 7u] );
    float cxz  = dot( vxz , corners[hxz  & 7u] );
    float cyz  = dot( vyz , corners[hyz  & 7u] );
    float cxyz = dot( vxyz, corners[hxyz & 7u] );

    vec3 ratio = my_smoothstep(v);

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

    float daylength = DaySec * freqency;

    vec4 p2 = vec4(p, GameTime * daylength + phase);

    vec4 p3     = floor(p2);//vec4(floor(p2.x) ,floor(p2.y) ,floor(p2.z), floor(p2.w));
    vec4 p3xyzw = p3 + 1.0;//vec4( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 , p3.w + 1.0 );
    vec4 p3x    = vec4( p3xyzw.x , p3.y     , p3.z     , p3.w     );
    vec4 p3y    = vec4( p3.x     , p3xyzw.y , p3.z     , p3.w     );
    vec4 p3xy   = vec4( p3xyzw.x , p3xyzw.y , p3.z     , p3.w     );
    vec4 p3z    = vec4( p3.x     , p3.y     , p3xyzw.z , p3.w     ); 
    vec4 p3xz   = vec4( p3xyzw.x , p3.y     , p3xyzw.z , p3.w     );
    vec4 p3yz   = vec4( p3.x     , p3xyzw.y , p3xyzw.z , p3.w     );
    vec4 p3xyz  = vec4( p3xyzw.x , p3xyzw.y , p3xyzw.z , p3.w     );
    vec4 p3w    = vec4( p3.x     , p3.y     , p3.z     , p3xyzw.w );
    vec4 p3xw   = vec4( p3xyzw.x , p3.y     , p3.z     , p3xyzw.w );
    vec4 p3yw   = vec4( p3.x     , p3xyzw.y , p3.z     , p3xyzw.w );
    vec4 p3xyw  = vec4( p3xyzw.x , p3xyzw.y , p3.z     , p3xyzw.w );
    vec4 p3zw   = vec4( p3.x     , p3.y     , p3xyzw.z , p3xyzw.w ); 
    vec4 p3xzw  = vec4( p3xyzw.x , p3.y     , p3xyzw.z , p3xyzw.w );
    vec4 p3yzw  = vec4( p3.x     , p3xyzw.y , p3xyzw.z , p3xyzw.w );

    float time0 = loop( p3.w     , daylength);
    float time1 = loop( p3xyzw.w , daylength);

    uint h     = pcg_hash(vec4( p3.xyz,     time0 ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    time0 ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    time0 ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   time0 ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    time0 ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   time0 ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   time0 ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  time0 ));
    uint hw    = pcg_hash(vec4( p3w.xyz,    time1 ));
    uint hxw   = pcg_hash(vec4( p3xw.xyz,   time1 ));
    uint hyw   = pcg_hash(vec4( p3yw.xyz,   time1 ));
    uint hxyw  = pcg_hash(vec4( p3xyw.xyz,  time1 ));
    uint hzw   = pcg_hash(vec4( p3zw.xyz,   time1 ));
    uint hxzw  = pcg_hash(vec4( p3xzw.xyz,  time1 ));
    uint hyzw  = pcg_hash(vec4( p3yzw.xyz,  time1 ));
    uint hxyzw = pcg_hash(vec4( p3xyzw.xyz, time1 ));
    
    vec4 v     = p2 - p3    ;
    vec4 vx    = p2 - p3x   ;
    vec4 vy    = p2 - p3y   ;
    vec4 vxy   = p2 - p3xy  ;
    vec4 vz    = p2 - p3z   ;
    vec4 vxz   = p2 - p3xz  ;
    vec4 vyz   = p2 - p3yz  ;
    vec4 vxyz  = p2 - p3xyz ;
    vec4 vw    = p2 - p3w   ;
    vec4 vxw   = p2 - p3xw  ;
    vec4 vyw   = p2 - p3yw  ;
    vec4 vxyw  = p2 - p3xyw ;
    vec4 vzw   = p2 - p3zw  ;
    vec4 vxzw  = p2 - p3xzw ;
    vec4 vyzw  = p2 - p3yzw ;
    vec4 vxyzw = p2 - p3xyzw;

    float c     = dot( v     , corners[h     & 15u] );
    float cx    = dot( vx    , corners[hx    & 15u] );
    float cy    = dot( vy    , corners[hy    & 15u] );
    float cxy   = dot( vxy   , corners[hxy   & 15u] );
    float cz    = dot( vz    , corners[hz    & 15u] );
    float cxz   = dot( vxz   , corners[hxz   & 15u] );
    float cyz   = dot( vyz   , corners[hyz   & 15u] );
    float cxyz  = dot( vxyz  , corners[hxyz  & 15u] );
    float cw    = dot( vw    , corners[hw    & 15u] );
    float cxw   = dot( vxw   , corners[hxw   & 15u] );
    float cyw   = dot( vyw   , corners[hyw   & 15u] );
    float cxyw  = dot( vxyw  , corners[hxyw  & 15u] );
    float czw   = dot( vzw   , corners[hzw   & 15u] );
    float cxzw  = dot( vxzw  , corners[hxzw  & 15u] );
    float cyzw  = dot( vyzw  , corners[hyzw  & 15u] );
    float cxyzw = dot( vxyzw , corners[hxyzw & 15u] );

    vec4 ratio = my_smoothstep(v);

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

vec2 perlin_noise_2d_t(vec2 p,float freqency,float phase){

    const vec3 corners[] = vec3[](
        vec3( 1, 1, 1),vec3(-1, 1, 1),
        vec3( 1,-1, 1),vec3(-1,-1, 1),
        vec3( 1, 1,-1),vec3(-1, 1,-1),
        vec3( 1,-1,-1),vec3(-1,-1,-1)
    );

    float daylength = DaySec * freqency;

    vec3 p2 = vec3(p.xy,GameTime * daylength + phase);

    vec3 p3     = floor(p2);//vec3(floor(p2.x) ,floor(p2.y) ,floor(p2.z));
    vec3 p3xyz  = p3 + 1.0; //vec3( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );
    vec3 p3x    = vec3( p3xyz.x , p3.y    , p3.z    );
    vec3 p3y    = vec3( p3.x    , p3xyz.y , p3.z    );
    vec3 p3xy   = vec3( p3xyz.x , p3xyz.y , p3.z    );
    vec3 p3z    = vec3( p3.x    , p3.y    , p3xyz.z ); 
    vec3 p3xz   = vec3( p3xyz.x , p3.y    , p3xyz.z );
    vec3 p3yz   = vec3( p3.x    , p3xyz.y , p3xyz.z );

    float time0 = loop( p3.z    , daylength);
    float time1 = loop( p3xyz.z , daylength);

    uint h     = pcg_hash(vec4( p3.xyz,     time0 ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    time0 ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    time0 ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   time0 ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    time1 ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   time1 ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   time1 ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  time1 ));

    vec3 v    = p2 - p3   ;
    vec3 vx   = p2 - p3x  ;
    vec3 vy   = p2 - p3y  ;
    vec3 vxy  = p2 - p3xy ;
    vec3 vz   = p2 - p3z  ;
    vec3 vxz  = p2 - p3xz ;
    vec3 vyz  = p2 - p3yz ;
    vec3 vxyz = p2 - p3xyz;

    vec2 c    = vec2( dot( v   , corners[h    & 7u] ), dot( v   , corners[(h    >> 3 ) & 7u] ) );
    vec2 cx   = vec2( dot( vx  , corners[hx   & 7u] ), dot( vx  , corners[(hx   >> 3 ) & 7u] ) );
    vec2 cy   = vec2( dot( vy  , corners[hy   & 7u] ), dot( vy  , corners[(hy   >> 3 ) & 7u] ) );
    vec2 cxy  = vec2( dot( vxy , corners[hxy  & 7u] ), dot( vxy , corners[(hxy  >> 3 ) & 7u] ) );
    vec2 cz   = vec2( dot( vz  , corners[hz   & 7u] ), dot( vz  , corners[(hz   >> 3 ) & 7u] ) );
    vec2 cxz  = vec2( dot( vxz , corners[hxz  & 7u] ), dot( vxz , corners[(hxz  >> 3 ) & 7u] ) );
    vec2 cyz  = vec2( dot( vyz , corners[hyz  & 7u] ), dot( vyz , corners[(hyz  >> 3 ) & 7u] ) );
    vec2 cxyz = vec2( dot( vxyz, corners[hxyz & 7u] ), dot( vxyz, corners[(hxyz >> 3 ) & 7u] ) );

    vec3 ratio = my_smoothstep(v);

    vec2 val = mix(
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

vec2 perlin_noise_2d_t(vec3 p,float freqency,float phase){

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

    float daylength = DaySec * freqency;

    vec4 p2 = vec4(p, GameTime * daylength + phase);

    vec4 p3     = floor(p2);//vec4(floor(p2.x) ,floor(p2.y) ,floor(p2.z), floor(p2.w));
    vec4 p3xyzw = p3 + 1.0;//vec4( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 , p3.w + 1.0 );
    vec4 p3x    = vec4( p3xyzw.x , p3.y     , p3.z     , p3.w     );
    vec4 p3y    = vec4( p3.x     , p3xyzw.y , p3.z     , p3.w     );
    vec4 p3xy   = vec4( p3xyzw.x , p3xyzw.y , p3.z     , p3.w     );
    vec4 p3z    = vec4( p3.x     , p3.y     , p3xyzw.z , p3.w     ); 
    vec4 p3xz   = vec4( p3xyzw.x , p3.y     , p3xyzw.z , p3.w     );
    vec4 p3yz   = vec4( p3.x     , p3xyzw.y , p3xyzw.z , p3.w     );
    vec4 p3xyz  = vec4( p3xyzw.x , p3xyzw.y , p3xyzw.z , p3.w     );
    vec4 p3w    = vec4( p3.x     , p3.y     , p3.z     , p3xyzw.w );
    vec4 p3xw   = vec4( p3xyzw.x , p3.y     , p3.z     , p3xyzw.w );
    vec4 p3yw   = vec4( p3.x     , p3xyzw.y , p3.z     , p3xyzw.w );
    vec4 p3xyw  = vec4( p3xyzw.x , p3xyzw.y , p3.z     , p3xyzw.w );
    vec4 p3zw   = vec4( p3.x     , p3.y     , p3xyzw.z , p3xyzw.w ); 
    vec4 p3xzw  = vec4( p3xyzw.x , p3.y     , p3xyzw.z , p3xyzw.w );
    vec4 p3yzw  = vec4( p3.x     , p3xyzw.y , p3xyzw.z , p3xyzw.w );

    float time0 = loop( p3.w     , daylength);
    float time1 = loop( p3xyzw.w , daylength);

    uint h     = pcg_hash(vec4( p3.xyz,     time0 ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    time0 ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    time0 ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   time0 ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    time0 ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   time0 ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   time0 ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  time0 ));
    uint hw    = pcg_hash(vec4( p3w.xyz,    time1 ));
    uint hxw   = pcg_hash(vec4( p3xw.xyz,   time1 ));
    uint hyw   = pcg_hash(vec4( p3yw.xyz,   time1 ));
    uint hxyw  = pcg_hash(vec4( p3xyw.xyz,  time1 ));
    uint hzw   = pcg_hash(vec4( p3zw.xyz,   time1 ));
    uint hxzw  = pcg_hash(vec4( p3xzw.xyz,  time1 ));
    uint hyzw  = pcg_hash(vec4( p3yzw.xyz,  time1 ));
    uint hxyzw = pcg_hash(vec4( p3xyzw.xyz, time1 ));

    vec4 v     = p2 - p3    ;
    vec4 vx    = p2 - p3x   ;
    vec4 vy    = p2 - p3y   ;
    vec4 vxy   = p2 - p3xy  ;
    vec4 vz    = p2 - p3z   ;
    vec4 vxz   = p2 - p3xz  ;
    vec4 vyz   = p2 - p3yz  ;
    vec4 vxyz  = p2 - p3xyz ;
    vec4 vw    = p2 - p3w   ;
    vec4 vxw   = p2 - p3xw  ;
    vec4 vyw   = p2 - p3yw  ;
    vec4 vxyw  = p2 - p3xyw ;
    vec4 vzw   = p2 - p3zw  ;
    vec4 vxzw  = p2 - p3xzw ;
    vec4 vyzw  = p2 - p3yzw ;
    vec4 vxyzw = p2 - p3xyzw;
    
    vec2 c     = vec2( dot( v     , corners[h     & 15u] ), dot( v     , corners[(h     >> 4) & 15u] ) );
    vec2 cx    = vec2( dot( vx    , corners[hx    & 15u] ), dot( vx    , corners[(hx    >> 4) & 15u] ) );
    vec2 cy    = vec2( dot( vy    , corners[hy    & 15u] ), dot( vy    , corners[(hy    >> 4) & 15u] ) );
    vec2 cxy   = vec2( dot( vxy   , corners[hxy   & 15u] ), dot( vxy   , corners[(hxy   >> 4) & 15u] ) );
    vec2 cz    = vec2( dot( vz    , corners[hz    & 15u] ), dot( vz    , corners[(hz    >> 4) & 15u] ) );
    vec2 cxz   = vec2( dot( vxz   , corners[hxz   & 15u] ), dot( vxz   , corners[(hxz   >> 4) & 15u] ) );
    vec2 cyz   = vec2( dot( vyz   , corners[hyz   & 15u] ), dot( vyz   , corners[(hyz   >> 4) & 15u] ) );
    vec2 cxyz  = vec2( dot( vxyz  , corners[hxyz  & 15u] ), dot( vxyz  , corners[(hxyz  >> 4) & 15u] ) );
    vec2 cw    = vec2( dot( vw    , corners[hw    & 15u] ), dot( vw    , corners[(hw    >> 4) & 15u] ) );
    vec2 cxw   = vec2( dot( vxw   , corners[hxw   & 15u] ), dot( vxw   , corners[(hxw   >> 4) & 15u] ) );
    vec2 cyw   = vec2( dot( vyw   , corners[hyw   & 15u] ), dot( vyw   , corners[(hyw   >> 4) & 15u] ) );
    vec2 cxyw  = vec2( dot( vxyw  , corners[hxyw  & 15u] ), dot( vxyw  , corners[(hxyw  >> 4) & 15u] ) );
    vec2 czw   = vec2( dot( vzw   , corners[hzw   & 15u] ), dot( vzw   , corners[(hzw   >> 4) & 15u] ) );
    vec2 cxzw  = vec2( dot( vxzw  , corners[hxzw  & 15u] ), dot( vxzw  , corners[(hxzw  >> 4) & 15u] ) );
    vec2 cyzw  = vec2( dot( vyzw  , corners[hyzw  & 15u] ), dot( vyzw  , corners[(hyzw  >> 4) & 15u] ) );
    vec2 cxyzw = vec2( dot( vxyzw , corners[hxyzw & 15u] ), dot( vxyzw , corners[(hxyzw >> 4) & 15u] ) );

    vec4 ratio = my_smoothstep(v);

    vec2 val = mix(
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

vec3 perlin_noise_3d_t(vec2 p,float freqency,float phase){

    const vec3 corners[] = vec3[](
        vec3( 1, 1, 1),vec3(-1, 1, 1),
        vec3( 1,-1, 1),vec3(-1,-1, 1),
        vec3( 1, 1,-1),vec3(-1, 1,-1),
        vec3( 1,-1,-1),vec3(-1,-1,-1)
    );

    float daylength = DaySec * freqency;

    vec3 p2 = vec3(p.xy,GameTime * daylength + phase);

    vec3 p3     = floor(p2);//vec3(floor(p2.x) ,floor(p2.y) ,floor(p2.z));
    vec3 p3xyz  = p3 + 1.0; //vec3( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );
    vec3 p3x    = vec3( p3xyz.x , p3.y    , p3.z    );
    vec3 p3y    = vec3( p3.x    , p3xyz.y , p3.z    );
    vec3 p3xy   = vec3( p3xyz.x , p3xyz.y , p3.z    );
    vec3 p3z    = vec3( p3.x    , p3.y    , p3xyz.z ); 
    vec3 p3xz   = vec3( p3xyz.x , p3.y    , p3xyz.z );
    vec3 p3yz   = vec3( p3.x    , p3xyz.y , p3xyz.z );

    float time0 = loop( p3.z    , daylength);
    float time1 = loop( p3xyz.z , daylength);

    uint h     = pcg_hash(vec4( p3.xyz,     time0 ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    time0 ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    time0 ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   time0 ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    time1 ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   time1 ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   time1 ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  time1 ));
    
    vec3 v    = p2 - p3   ;
    vec3 vx   = p2 - p3x  ;
    vec3 vy   = p2 - p3y  ;
    vec3 vxy  = p2 - p3xy ;
    vec3 vz   = p2 - p3z  ;
    vec3 vxz  = p2 - p3xz ;
    vec3 vyz  = p2 - p3yz ;
    vec3 vxyz = p2 - p3xyz;

    vec3 c    = vec3( dot( v   , corners[h    & 7u] ), dot( v   , corners[(h    >> 3 ) & 7u] ), dot( v   , corners[(h    >> 6 ) & 7u] ) );
    vec3 cx   = vec3( dot( vx  , corners[hx   & 7u] ), dot( vx  , corners[(hx   >> 3 ) & 7u] ), dot( vx  , corners[(hx   >> 6 ) & 7u] ) );
    vec3 cy   = vec3( dot( vy  , corners[hy   & 7u] ), dot( vy  , corners[(hy   >> 3 ) & 7u] ), dot( vy  , corners[(hy   >> 6 ) & 7u] ) );
    vec3 cxy  = vec3( dot( vxy , corners[hxy  & 7u] ), dot( vxy , corners[(hxy  >> 3 ) & 7u] ), dot( vxy , corners[(hxy  >> 6 ) & 7u] ) );
    vec3 cz   = vec3( dot( vz  , corners[hz   & 7u] ), dot( vz  , corners[(hz   >> 3 ) & 7u] ), dot( vz  , corners[(hz   >> 6 ) & 7u] ) );
    vec3 cxz  = vec3( dot( vxz , corners[hxz  & 7u] ), dot( vxz , corners[(hxz  >> 3 ) & 7u] ), dot( vxz , corners[(hxz  >> 6 ) & 7u] ) );
    vec3 cyz  = vec3( dot( vyz , corners[hyz  & 7u] ), dot( vyz , corners[(hyz  >> 3 ) & 7u] ), dot( vyz , corners[(hyz  >> 6 ) & 7u] ) );
    vec3 cxyz = vec3( dot( vxyz, corners[hxyz & 7u] ), dot( vxyz, corners[(hxyz >> 3 ) & 7u] ), dot( vxyz, corners[(hxyz >> 6 ) & 7u] ) );

    vec3 ratio = my_smoothstep(v);

    vec3 val = mix(
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

vec3 perlin_noise_3d_t(vec3 p,float freqency,float phase){

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

    float daylength = DaySec * freqency;

    vec4 p2 = vec4(p, GameTime * daylength + phase);

    vec4 p3     = floor(p2);//vec4(floor(p2.x) ,floor(p2.y) ,floor(p2.z), floor(p2.w));
    vec4 p3xyzw = p3 + 1.0;//vec4( p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 , p3.w + 1.0 );
    vec4 p3x    = vec4( p3xyzw.x , p3.y     , p3.z     , p3.w     );
    vec4 p3y    = vec4( p3.x     , p3xyzw.y , p3.z     , p3.w     );
    vec4 p3xy   = vec4( p3xyzw.x , p3xyzw.y , p3.z     , p3.w     );
    vec4 p3z    = vec4( p3.x     , p3.y     , p3xyzw.z , p3.w     ); 
    vec4 p3xz   = vec4( p3xyzw.x , p3.y     , p3xyzw.z , p3.w     );
    vec4 p3yz   = vec4( p3.x     , p3xyzw.y , p3xyzw.z , p3.w     );
    vec4 p3xyz  = vec4( p3xyzw.x , p3xyzw.y , p3xyzw.z , p3.w     );
    vec4 p3w    = vec4( p3.x     , p3.y     , p3.z     , p3xyzw.w );
    vec4 p3xw   = vec4( p3xyzw.x , p3.y     , p3.z     , p3xyzw.w );
    vec4 p3yw   = vec4( p3.x     , p3xyzw.y , p3.z     , p3xyzw.w );
    vec4 p3xyw  = vec4( p3xyzw.x , p3xyzw.y , p3.z     , p3xyzw.w );
    vec4 p3zw   = vec4( p3.x     , p3.y     , p3xyzw.z , p3xyzw.w ); 
    vec4 p3xzw  = vec4( p3xyzw.x , p3.y     , p3xyzw.z , p3xyzw.w );
    vec4 p3yzw  = vec4( p3.x     , p3xyzw.y , p3xyzw.z , p3xyzw.w );

    float time0 = loop( p3.w     , daylength);
    float time1 = loop( p3xyzw.w , daylength);

    uint h     = pcg_hash(vec4( p3.xyz,     time0 ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    time0 ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    time0 ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   time0 ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    time0 ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   time0 ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   time0 ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  time0 ));
    uint hw    = pcg_hash(vec4( p3w.xyz,    time1 ));
    uint hxw   = pcg_hash(vec4( p3xw.xyz,   time1 ));
    uint hyw   = pcg_hash(vec4( p3yw.xyz,   time1 ));
    uint hxyw  = pcg_hash(vec4( p3xyw.xyz,  time1 ));
    uint hzw   = pcg_hash(vec4( p3zw.xyz,   time1 ));
    uint hxzw  = pcg_hash(vec4( p3xzw.xyz,  time1 ));
    uint hyzw  = pcg_hash(vec4( p3yzw.xyz,  time1 ));
    uint hxyzw = pcg_hash(vec4( p3xyzw.xyz, time1 ));

    vec4 v     = p2 - p3    ;
    vec4 vx    = p2 - p3x   ;
    vec4 vy    = p2 - p3y   ;
    vec4 vxy   = p2 - p3xy  ;
    vec4 vz    = p2 - p3z   ;
    vec4 vxz   = p2 - p3xz  ;
    vec4 vyz   = p2 - p3yz  ;
    vec4 vxyz  = p2 - p3xyz ;
    vec4 vw    = p2 - p3w   ;
    vec4 vxw   = p2 - p3xw  ;
    vec4 vyw   = p2 - p3yw  ;
    vec4 vxyw  = p2 - p3xyw ;
    vec4 vzw   = p2 - p3zw  ;
    vec4 vxzw  = p2 - p3xzw ;
    vec4 vyzw  = p2 - p3yzw ;
    vec4 vxyzw = p2 - p3xyzw;
    
    vec3 c     = vec3( dot( v     , corners[h     & 15u] ), dot( v     , corners[(h     >> 4) & 15u] ), dot( v     , corners[(h     >> 8) & 15u] ) );
    vec3 cx    = vec3( dot( vx    , corners[hx    & 15u] ), dot( vx    , corners[(hx    >> 4) & 15u] ), dot( vx    , corners[(hx    >> 8) & 15u] ) );
    vec3 cy    = vec3( dot( vy    , corners[hy    & 15u] ), dot( vy    , corners[(hy    >> 4) & 15u] ), dot( vy    , corners[(hy    >> 8) & 15u] ) );
    vec3 cxy   = vec3( dot( vxy   , corners[hxy   & 15u] ), dot( vxy   , corners[(hxy   >> 4) & 15u] ), dot( vxy   , corners[(hxy   >> 8) & 15u] ) );
    vec3 cz    = vec3( dot( vz    , corners[hz    & 15u] ), dot( vz    , corners[(hz    >> 4) & 15u] ), dot( vz    , corners[(hz    >> 8) & 15u] ) );
    vec3 cxz   = vec3( dot( vxz   , corners[hxz   & 15u] ), dot( vxz   , corners[(hxz   >> 4) & 15u] ), dot( vxz   , corners[(hxz   >> 8) & 15u] ) );
    vec3 cyz   = vec3( dot( vyz   , corners[hyz   & 15u] ), dot( vyz   , corners[(hyz   >> 4) & 15u] ), dot( vyz   , corners[(hyz   >> 8) & 15u] ) );
    vec3 cxyz  = vec3( dot( vxyz  , corners[hxyz  & 15u] ), dot( vxyz  , corners[(hxyz  >> 4) & 15u] ), dot( vxyz  , corners[(hxyz  >> 8) & 15u] ) );
    vec3 cw    = vec3( dot( vw    , corners[hw    & 15u] ), dot( vw    , corners[(hw    >> 4) & 15u] ), dot( vw    , corners[(hw    >> 8) & 15u] ) );
    vec3 cxw   = vec3( dot( vxw   , corners[hxw   & 15u] ), dot( vxw   , corners[(hxw   >> 4) & 15u] ), dot( vxw   , corners[(hxw   >> 8) & 15u] ) );
    vec3 cyw   = vec3( dot( vyw   , corners[hyw   & 15u] ), dot( vyw   , corners[(hyw   >> 4) & 15u] ), dot( vyw   , corners[(hyw   >> 8) & 15u] ) );
    vec3 cxyw  = vec3( dot( vxyw  , corners[hxyw  & 15u] ), dot( vxyw  , corners[(hxyw  >> 4) & 15u] ), dot( vxyw  , corners[(hxyw  >> 8) & 15u] ) );
    vec3 czw   = vec3( dot( vzw   , corners[hzw   & 15u] ), dot( vzw   , corners[(hzw   >> 4) & 15u] ), dot( vzw   , corners[(hzw   >> 8) & 15u] ) );
    vec3 cxzw  = vec3( dot( vxzw  , corners[hxzw  & 15u] ), dot( vxzw  , corners[(hxzw  >> 4) & 15u] ), dot( vxzw  , corners[(hxzw  >> 8) & 15u] ) );
    vec3 cyzw  = vec3( dot( vyzw  , corners[hyzw  & 15u] ), dot( vyzw  , corners[(hyzw  >> 4) & 15u] ), dot( vyzw  , corners[(hyzw  >> 8) & 15u] ) );
    vec3 cxyzw = vec3( dot( vxyzw , corners[hxyzw & 15u] ), dot( vxyzw , corners[(hxyzw >> 4) & 15u] ), dot( vxyzw , corners[(hxyzw >> 8) & 15u] ) );

    vec4 ratio = my_smoothstep(v);

    vec3 val = mix(
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