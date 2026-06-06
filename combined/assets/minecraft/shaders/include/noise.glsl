
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

    uint h   = pcg_hash(p3)   ;
    uint hx  = pcg_hash(p3x)  ;
    uint hy  = pcg_hash(p3y)  ;
    uint hxy = pcg_hash(p3xy) ;
    
    float c    = dot(p - p3  , corners[h   & 3u] );
    float cx   = dot(p - p3x , corners[hx  & 3u] );
    float cy   = dot(p - p3y , corners[hy  & 3u] );
    float cxy  = dot(p - p3xy, corners[hxy & 3u] );

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

    uint h    = pcg_hash(p3)   ;
    uint hx   = pcg_hash(p3x)  ;
    uint hy   = pcg_hash(p3y)  ;
    uint hxy  = pcg_hash(p3xy) ;
    uint hz   = pcg_hash(p3z)  ;
    uint hxz  = pcg_hash(p3xz) ;
    uint hyz  = pcg_hash(p3yz) ;
    uint hxyz = pcg_hash(p3xyz);
    
    float c    = dot(p - p3  ,  corners[h    & 7u] );
    float cx   = dot(p - p3x ,  corners[hx   & 7u] );
    float cy   = dot(p - p3y ,  corners[hy   & 7u] );
    float cxy  = dot(p - p3xy,  corners[hxy  & 7u] );
    float cz   = dot(p - p3z  , corners[hz   & 7u] );
    float cxz  = dot(p - p3xz , corners[hxz  & 7u] );
    float cyz  = dot(p - p3yz , corners[hyz  & 7u] );
    float cxyz = dot(p - p3xyz, corners[hxyz & 7u] );

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
vec2 perlin_noise_2d(vec2 p){

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

    uint h   = pcg_hash(p3)   ;
    uint hx  = pcg_hash(p3x)  ;
    uint hy  = pcg_hash(p3y)  ;
    uint hxy = pcg_hash(p3xy) ;
    
    vec2 c    = vec2( dot(p - p3  , corners[h   & 3u] ), dot(p - p3  , corners[(h  >> 2) & 3u] ) );
    vec2 cx   = vec2( dot(p - p3x , corners[hx  & 3u] ), dot(p - p3x , corners[(hx >> 2) & 3u] ) );
    vec2 cy   = vec2( dot(p - p3y , corners[hy  & 3u] ), dot(p - p3y , corners[(hy >> 2) & 3u] ) );
    vec2 cxy  = vec2( dot(p - p3xy, corners[hxy & 3u] ), dot(p - p3xy, corners[(hxy>> 2) & 3u] ) );

    vec2 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.xy = vec2(my_smoothstep(fract(p.x)),my_smoothstep(fract(p.y)));

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

    vec3 p3    = vec3(floor(p.x) ,floor(p.y) ,floor(p.z) );
    vec3 p3x   = vec3(p3.x + 1.0, p3.y      , p3.z );
    vec3 p3y   = vec3(p3.x      , p3.y + 1.0, p3.z );
    vec3 p3xy  = vec3(p3.x + 1.0, p3.y + 1.0, p3.z );
    vec3 p3z   = vec3(p3.x      , p3.y      , p3.z + 1.0 ); 
    vec3 p3xz  = vec3(p3.x + 1.0, p3.y      , p3.z + 1.0 );
    vec3 p3yz  = vec3(p3.x      , p3.y + 1.0, p3.z + 1.0 );
    vec3 p3xyz = vec3(p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );

    uint h    = pcg_hash(p3)   ;
    uint hx   = pcg_hash(p3x)  ;
    uint hy   = pcg_hash(p3y)  ;
    uint hxy  = pcg_hash(p3xy) ;
    uint hz   = pcg_hash(p3z)  ;
    uint hxz  = pcg_hash(p3xz) ;
    uint hyz  = pcg_hash(p3yz) ;
    uint hxyz = pcg_hash(p3xyz);
    
    vec2 c    = vec2( dot(p - p3  ,  corners[h    & 7u] ),dot(p - p3  ,  corners[(h    >> 3) & 7u] ) );
    vec2 cx   = vec2( dot(p - p3x ,  corners[hx   & 7u] ),dot(p - p3x ,  corners[(hx   >> 3) & 7u] ) );
    vec2 cy   = vec2( dot(p - p3y ,  corners[hy   & 7u] ),dot(p - p3y ,  corners[(hy   >> 3) & 7u] ) );
    vec2 cxy  = vec2( dot(p - p3xy,  corners[hxy  & 7u] ),dot(p - p3xy,  corners[(hxy  >> 3) & 7u] ) );
    vec2 cz   = vec2( dot(p - p3z  , corners[hz   & 7u] ),dot(p - p3z  , corners[(hz   >> 3) & 7u] ) );
    vec2 cxz  = vec2( dot(p - p3xz , corners[hxz  & 7u] ),dot(p - p3xz , corners[(hxz  >> 3) & 7u] ) );
    vec2 cyz  = vec2( dot(p - p3yz , corners[hyz  & 7u] ),dot(p - p3yz , corners[(hyz  >> 3) & 7u] ) );
    vec2 cxyz = vec2( dot(p - p3xyz, corners[hxyz & 7u] ),dot(p - p3xyz, corners[(hxyz >> 3) & 7u] ) );

    vec3 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.xyz = vec3(my_smoothstep(fract(p.x)),my_smoothstep(fract(p.y)),my_smoothstep(fract(p.z)));

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

    uint h   = pcg_hash(p3)   ;
    uint hx  = pcg_hash(p3x)  ;
    uint hy  = pcg_hash(p3y)  ;
    uint hxy = pcg_hash(p3xy) ;
    
    vec3 c    = vec3( dot(p - p3  , corners[h   & 3u] ), dot(p - p3  , corners[(h  >> 2) & 3u] ), dot(p - p3  , corners[(h  >> 4) & 3u] ) );
    vec3 cx   = vec3( dot(p - p3x , corners[hx  & 3u] ), dot(p - p3x , corners[(hx >> 2) & 3u] ), dot(p - p3x , corners[(hx >> 4) & 3u] ) );
    vec3 cy   = vec3( dot(p - p3y , corners[hy  & 3u] ), dot(p - p3y , corners[(hy >> 2) & 3u] ), dot(p - p3y , corners[(hy >> 4) & 3u] ) );
    vec3 cxy  = vec3( dot(p - p3xy, corners[hxy & 3u] ), dot(p - p3xy, corners[(hxy>> 2) & 3u] ), dot(p - p3xy, corners[(hxy>> 4) & 3u] ) );

    vec2 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.xy = vec2(my_smoothstep(fract(p.x)),my_smoothstep(fract(p.y)));

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

    vec3 p3    = vec3(floor(p.x) ,floor(p.y) ,floor(p.z) );
    vec3 p3x   = vec3(p3.x + 1.0, p3.y      , p3.z );
    vec3 p3y   = vec3(p3.x      , p3.y + 1.0, p3.z );
    vec3 p3xy  = vec3(p3.x + 1.0, p3.y + 1.0, p3.z );
    vec3 p3z   = vec3(p3.x      , p3.y      , p3.z + 1.0 ); 
    vec3 p3xz  = vec3(p3.x + 1.0, p3.y      , p3.z + 1.0 );
    vec3 p3yz  = vec3(p3.x      , p3.y + 1.0, p3.z + 1.0 );
    vec3 p3xyz = vec3(p3.x + 1.0, p3.y + 1.0, p3.z + 1.0 );

    uint h    = pcg_hash(p3)   ;
    uint hx   = pcg_hash(p3x)  ;
    uint hy   = pcg_hash(p3y)  ;
    uint hxy  = pcg_hash(p3xy) ;
    uint hz   = pcg_hash(p3z)  ;
    uint hxz  = pcg_hash(p3xz) ;
    uint hyz  = pcg_hash(p3yz) ;
    uint hxyz = pcg_hash(p3xyz);
    
    vec3 c    = vec3( dot(p - p3  ,  corners[h    & 7u] ),dot(p - p3  ,  corners[(h    >> 3) & 7u] ),dot(p - p3  ,  corners[(h    >> 6) & 7u] ) );
    vec3 cx   = vec3( dot(p - p3x ,  corners[hx   & 7u] ),dot(p - p3x ,  corners[(hx   >> 3) & 7u] ),dot(p - p3x ,  corners[(hx   >> 6) & 7u] ) );
    vec3 cy   = vec3( dot(p - p3y ,  corners[hy   & 7u] ),dot(p - p3y ,  corners[(hy   >> 3) & 7u] ),dot(p - p3y ,  corners[(hy   >> 6) & 7u] ) );
    vec3 cxy  = vec3( dot(p - p3xy,  corners[hxy  & 7u] ),dot(p - p3xy,  corners[(hxy  >> 3) & 7u] ),dot(p - p3xy,  corners[(hxy  >> 6) & 7u] ) );
    vec3 cz   = vec3( dot(p - p3z  , corners[hz   & 7u] ),dot(p - p3z  , corners[(hz   >> 3) & 7u] ),dot(p - p3z  , corners[(hz   >> 6) & 7u] ) );
    vec3 cxz  = vec3( dot(p - p3xz , corners[hxz  & 7u] ),dot(p - p3xz , corners[(hxz  >> 3) & 7u] ),dot(p - p3xz , corners[(hxz  >> 6) & 7u] ) );
    vec3 cyz  = vec3( dot(p - p3yz , corners[hyz  & 7u] ),dot(p - p3yz , corners[(hyz  >> 3) & 7u] ),dot(p - p3yz , corners[(hyz  >> 6) & 7u] ) );
    vec3 cxyz = vec3( dot(p - p3xyz, corners[hxyz & 7u] ),dot(p - p3xyz, corners[(hxyz >> 3) & 7u] ),dot(p - p3xyz, corners[(hxyz >> 6) & 7u] ) );

    vec3 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.xyz = vec3(my_smoothstep(fract(p.x)),my_smoothstep(fract(p.y)),my_smoothstep(fract(p.z)));

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

    uint h    = pcg_hash(vec3( p3.xy,    loop( p3.z    , daylength ) ) );
    uint hx   = pcg_hash(vec3( p3x.xy,   loop( p3x.z   , daylength ) ) );
    uint hy   = pcg_hash(vec3( p3y.xy,   loop( p3y.z   , daylength ) ) );
    uint hxy  = pcg_hash(vec3( p3xy.xy,  loop( p3xy.z  , daylength ) ) );
    uint hz   = pcg_hash(vec3( p3z.xy,   loop( p3z.z   , daylength ) ) );
    uint hxz  = pcg_hash(vec3( p3xz.xy,  loop( p3xz.z  , daylength ) ) );
    uint hyz  = pcg_hash(vec3( p3yz.xy,  loop( p3yz.z  , daylength ) ) );
    uint hxyz = pcg_hash(vec3( p3xyz.xy, loop( p3xyz.z , daylength ) ) );
    
    float c    = dot(p2 - p3   , corners[h    & 7u] );
    float cx   = dot(p2 - p3x  , corners[hx   & 7u] );
    float cy   = dot(p2 - p3y  , corners[hy   & 7u] );
    float cxy  = dot(p2 - p3xy , corners[hxy  & 7u] );
    float cz   = dot(p2 - p3z  , corners[hz   & 7u] );
    float cxz  = dot(p2 - p3xz , corners[hxz  & 7u] );
    float cyz  = dot(p2 - p3yz , corners[hyz  & 7u] );
    float cxyz = dot(p2 - p3xyz, corners[hxyz & 7u] );

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

    uint h     = pcg_hash(vec4( p3.xyz,     loop( p3.w     , daylength) ) );
    uint hx    = pcg_hash(vec4( p3x.xyz,    loop( p3x.w    , daylength) ) );
    uint hy    = pcg_hash(vec4( p3y.xyz,    loop( p3y.w    , daylength) ) );
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   loop( p3xy.w   , daylength) ) );
    uint hz    = pcg_hash(vec4( p3z.xyz,    loop( p3z.w    , daylength) ) );
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   loop( p3xz.w   , daylength) ) );
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   loop( p3yz.w   , daylength) ) );
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  loop( p3xyz.w  , daylength) ) );
    uint hw    = pcg_hash(vec4( p3w.xyz,    loop( p3w.w    , daylength) ) );
    uint hxw   = pcg_hash(vec4( p3xw.xyz,   loop( p3xw.w   , daylength) ) );
    uint hyw   = pcg_hash(vec4( p3yw.xyz,   loop( p3yw.w   , daylength) ) );
    uint hxyw  = pcg_hash(vec4( p3xyw.xyz,  loop( p3xyw.w  , daylength) ) );
    uint hzw   = pcg_hash(vec4( p3zw.xyz,   loop( p3zw.w   , daylength) ) );
    uint hxzw  = pcg_hash(vec4( p3xzw.xyz,  loop( p3xzw.w  , daylength) ) );
    uint hyzw  = pcg_hash(vec4( p3yzw.xyz,  loop( p3yzw.w  , daylength) ) );
    uint hxyzw = pcg_hash(vec4( p3xyzw.xyz, loop( p3xyzw.w , daylength) ) );
    
    float c     = dot(p2 - p3     , corners[h     & 15u] );
    float cx    = dot(p2 - p3x    , corners[hx    & 15u] );
    float cy    = dot(p2 - p3y    , corners[hy    & 15u] );
    float cxy   = dot(p2 - p3xy   , corners[hxy   & 15u] );
    float cz    = dot(p2 - p3z    , corners[hz    & 15u] );
    float cxz   = dot(p2 - p3xz   , corners[hxz   & 15u] );
    float cyz   = dot(p2 - p3yz   , corners[hyz   & 15u] );
    float cxyz  = dot(p2 - p3xyz  , corners[hxyz  & 15u] );
    float cw    = dot(p2 - p3w    , corners[hw    & 15u] );
    float cxw   = dot(p2 - p3xw   , corners[hxw   & 15u] );
    float cyw   = dot(p2 - p3yw   , corners[hyw   & 15u] );
    float cxyw  = dot(p2 - p3xyw  , corners[hxyw  & 15u] );
    float czw   = dot(p2 - p3zw   , corners[hzw   & 15u] );
    float cxzw  = dot(p2 - p3xzw  , corners[hxzw  & 15u] );
    float cyzw  = dot(p2 - p3yzw  , corners[hyzw  & 15u] );
    float cxyzw = dot(p2 - p3xyzw , corners[hxyzw & 15u] );

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

vec2 perlin_noise_2d_t(vec2 p,float freqency,float phase){

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

    uint h    = pcg_hash(vec3( p3.xy,    loop( p3.z    , daylength ) ) );
    uint hx   = pcg_hash(vec3( p3x.xy,   loop( p3x.z   , daylength ) ) );
    uint hy   = pcg_hash(vec3( p3y.xy,   loop( p3y.z   , daylength ) ) );
    uint hxy  = pcg_hash(vec3( p3xy.xy,  loop( p3xy.z  , daylength ) ) );
    uint hz   = pcg_hash(vec3( p3z.xy,   loop( p3z.z   , daylength ) ) );
    uint hxz  = pcg_hash(vec3( p3xz.xy,  loop( p3xz.z  , daylength ) ) );
    uint hyz  = pcg_hash(vec3( p3yz.xy,  loop( p3yz.z  , daylength ) ) );
    uint hxyz = pcg_hash(vec3( p3xyz.xy, loop( p3xyz.z , daylength ) ) );
    
    vec2 c    = vec2( dot(p2 - p3   , corners[h    & 7u] ), dot(p2 - p3   , corners[(h    >> 3 ) & 7u] ) );
    vec2 cx   = vec2( dot(p2 - p3x  , corners[hx   & 7u] ), dot(p2 - p3x  , corners[(hx   >> 3 ) & 7u] ) );
    vec2 cy   = vec2( dot(p2 - p3y  , corners[hy   & 7u] ), dot(p2 - p3y  , corners[(hy   >> 3 ) & 7u] ) );
    vec2 cxy  = vec2( dot(p2 - p3xy , corners[hxy  & 7u] ), dot(p2 - p3xy , corners[(hxy  >> 3 ) & 7u] ) );
    vec2 cz   = vec2( dot(p2 - p3z  , corners[hz   & 7u] ), dot(p2 - p3z  , corners[(hz   >> 3 ) & 7u] ) );
    vec2 cxz  = vec2( dot(p2 - p3xz , corners[hxz  & 7u] ), dot(p2 - p3xz , corners[(hxz  >> 3 ) & 7u] ) );
    vec2 cyz  = vec2( dot(p2 - p3yz , corners[hyz  & 7u] ), dot(p2 - p3yz , corners[(hyz  >> 3 ) & 7u] ) );
    vec2 cxyz = vec2( dot(p2 - p3xyz, corners[hxyz & 7u] ), dot(p2 - p3xyz, corners[(hxyz >> 3 ) & 7u] ) );

    vec3 ratio;

    ratio.x = my_smoothstep(fract(p2.x));
    ratio.y = my_smoothstep(fract(p2.y));
    ratio.z = my_smoothstep(fract(p2.z));

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

    uint h     = pcg_hash(vec4( p3.xyz,     loop( p3.w     , daylength) ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    loop( p3x.w    , daylength) ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    loop( p3y.w    , daylength) ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   loop( p3xy.w   , daylength) ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    loop( p3z.w    , daylength) ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   loop( p3xz.w   , daylength) ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   loop( p3yz.w   , daylength) ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  loop( p3xyz.w  , daylength) ));
    uint hw    = pcg_hash(vec4( p3w.xyz,    loop( p3w.w    , daylength) ));
    uint hxw   = pcg_hash(vec4( p3xw.xyz,   loop( p3xw.w   , daylength) ));
    uint hyw   = pcg_hash(vec4( p3yw.xyz,   loop( p3yw.w   , daylength) ));
    uint hxyw  = pcg_hash(vec4( p3xyw.xyz,  loop( p3xyw.w  , daylength) ));
    uint hzw   = pcg_hash(vec4( p3zw.xyz,   loop( p3zw.w   , daylength) ));
    uint hxzw  = pcg_hash(vec4( p3xzw.xyz,  loop( p3xzw.w  , daylength) ));
    uint hyzw  = pcg_hash(vec4( p3yzw.xyz,  loop( p3yzw.w  , daylength) ));
    uint hxyzw = pcg_hash(vec4( p3xyzw.xyz, loop( p3xyzw.w , daylength) ));
    
    vec2 c     = vec2( dot(p2 - p3     , corners[h     & 15u] ), dot(p2 - p3     , corners[(h     >> 4) & 15u] ) );
    vec2 cx    = vec2( dot(p2 - p3x    , corners[hx    & 15u] ), dot(p2 - p3x    , corners[(hx    >> 4) & 15u] ) );
    vec2 cy    = vec2( dot(p2 - p3y    , corners[hy    & 15u] ), dot(p2 - p3y    , corners[(hy    >> 4) & 15u] ) );
    vec2 cxy   = vec2( dot(p2 - p3xy   , corners[hxy   & 15u] ), dot(p2 - p3xy   , corners[(hxy   >> 4) & 15u] ) );
    vec2 cz    = vec2( dot(p2 - p3z    , corners[hz    & 15u] ), dot(p2 - p3z    , corners[(hz    >> 4) & 15u] ) );
    vec2 cxz   = vec2( dot(p2 - p3xz   , corners[hxz   & 15u] ), dot(p2 - p3xz   , corners[(hxz   >> 4) & 15u] ) );
    vec2 cyz   = vec2( dot(p2 - p3yz   , corners[hyz   & 15u] ), dot(p2 - p3yz   , corners[(hyz   >> 4) & 15u] ) );
    vec2 cxyz  = vec2( dot(p2 - p3xyz  , corners[hxyz  & 15u] ), dot(p2 - p3xyz  , corners[(hxyz  >> 4) & 15u] ) );
    vec2 cw    = vec2( dot(p2 - p3w    , corners[hw    & 15u] ), dot(p2 - p3w    , corners[(hw    >> 4) & 15u] ) );
    vec2 cxw   = vec2( dot(p2 - p3xw   , corners[hxw   & 15u] ), dot(p2 - p3xw   , corners[(hxw   >> 4) & 15u] ) );
    vec2 cyw   = vec2( dot(p2 - p3yw   , corners[hyw   & 15u] ), dot(p2 - p3yw   , corners[(hyw   >> 4) & 15u] ) );
    vec2 cxyw  = vec2( dot(p2 - p3xyw  , corners[hxyw  & 15u] ), dot(p2 - p3xyw  , corners[(hxyw  >> 4) & 15u] ) );
    vec2 czw   = vec2( dot(p2 - p3zw   , corners[hzw   & 15u] ), dot(p2 - p3zw   , corners[(hzw   >> 4) & 15u] ) );
    vec2 cxzw  = vec2( dot(p2 - p3xzw  , corners[hxzw  & 15u] ), dot(p2 - p3xzw  , corners[(hxzw  >> 4) & 15u] ) );
    vec2 cyzw  = vec2( dot(p2 - p3yzw  , corners[hyzw  & 15u] ), dot(p2 - p3yzw  , corners[(hyzw  >> 4) & 15u] ) );
    vec2 cxyzw = vec2( dot(p2 - p3xyzw , corners[hxyzw & 15u] ), dot(p2 - p3xyzw , corners[(hxyzw >> 4) & 15u] ) );

    vec4 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.x = my_smoothstep(fract(p2.x));
    ratio.y = my_smoothstep(fract(p2.y));
    ratio.z = my_smoothstep(fract(p2.z));
    ratio.w = my_smoothstep(fract(p2.w));

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

    uint h    = pcg_hash(vec3( p3.xy,    loop( p3.z    , daylength ) ) );
    uint hx   = pcg_hash(vec3( p3x.xy,   loop( p3x.z   , daylength ) ) );
    uint hy   = pcg_hash(vec3( p3y.xy,   loop( p3y.z   , daylength ) ) );
    uint hxy  = pcg_hash(vec3( p3xy.xy,  loop( p3xy.z  , daylength ) ) );
    uint hz   = pcg_hash(vec3( p3z.xy,   loop( p3z.z   , daylength ) ) );
    uint hxz  = pcg_hash(vec3( p3xz.xy,  loop( p3xz.z  , daylength ) ) );
    uint hyz  = pcg_hash(vec3( p3yz.xy,  loop( p3yz.z  , daylength ) ) );
    uint hxyz = pcg_hash(vec3( p3xyz.xy, loop( p3xyz.z , daylength ) ) );
    
    vec3 c    = vec3( dot(p2 - p3   , corners[h    & 7u] ), dot(p2 - p3   , corners[(h    >> 3 ) & 7u] ), dot(p2 - p3   , corners[(h    >> 6 ) & 7u] ) );
    vec3 cx   = vec3( dot(p2 - p3x  , corners[hx   & 7u] ), dot(p2 - p3x  , corners[(hx   >> 3 ) & 7u] ), dot(p2 - p3x  , corners[(hx   >> 6 ) & 7u] ) );
    vec3 cy   = vec3( dot(p2 - p3y  , corners[hy   & 7u] ), dot(p2 - p3y  , corners[(hy   >> 3 ) & 7u] ), dot(p2 - p3y  , corners[(hy   >> 6 ) & 7u] ) );
    vec3 cxy  = vec3( dot(p2 - p3xy , corners[hxy  & 7u] ), dot(p2 - p3xy , corners[(hxy  >> 3 ) & 7u] ), dot(p2 - p3xy , corners[(hxy  >> 6 ) & 7u] ) );
    vec3 cz   = vec3( dot(p2 - p3z  , corners[hz   & 7u] ), dot(p2 - p3z  , corners[(hz   >> 3 ) & 7u] ), dot(p2 - p3z  , corners[(hz   >> 6 ) & 7u] ) );
    vec3 cxz  = vec3( dot(p2 - p3xz , corners[hxz  & 7u] ), dot(p2 - p3xz , corners[(hxz  >> 3 ) & 7u] ), dot(p2 - p3xz , corners[(hxz  >> 6 ) & 7u] ) );
    vec3 cyz  = vec3( dot(p2 - p3yz , corners[hyz  & 7u] ), dot(p2 - p3yz , corners[(hyz  >> 3 ) & 7u] ), dot(p2 - p3yz , corners[(hyz  >> 6 ) & 7u] ) );
    vec3 cxyz = vec3( dot(p2 - p3xyz, corners[hxyz & 7u] ), dot(p2 - p3xyz, corners[(hxyz >> 3 ) & 7u] ), dot(p2 - p3xyz, corners[(hxyz >> 6 ) & 7u] ) );

    vec3 ratio;

    ratio.x = my_smoothstep(fract(p2.x));
    ratio.y = my_smoothstep(fract(p2.y));
    ratio.z = my_smoothstep(fract(p2.z));

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

    uint h     = pcg_hash(vec4( p3.xyz,     loop( p3.w     , daylength) ));
    uint hx    = pcg_hash(vec4( p3x.xyz,    loop( p3x.w    , daylength) ));
    uint hy    = pcg_hash(vec4( p3y.xyz,    loop( p3y.w    , daylength) ));
    uint hxy   = pcg_hash(vec4( p3xy.xyz,   loop( p3xy.w   , daylength) ));
    uint hz    = pcg_hash(vec4( p3z.xyz,    loop( p3z.w    , daylength) ));
    uint hxz   = pcg_hash(vec4( p3xz.xyz,   loop( p3xz.w   , daylength) ));
    uint hyz   = pcg_hash(vec4( p3yz.xyz,   loop( p3yz.w   , daylength) ));
    uint hxyz  = pcg_hash(vec4( p3xyz.xyz,  loop( p3xyz.w  , daylength) ));
    uint hw    = pcg_hash(vec4( p3w.xyz,    loop( p3w.w    , daylength) ));
    uint hxw   = pcg_hash(vec4( p3xw.xyz,   loop( p3xw.w   , daylength) ));
    uint hyw   = pcg_hash(vec4( p3yw.xyz,   loop( p3yw.w   , daylength) ));
    uint hxyw  = pcg_hash(vec4( p3xyw.xyz,  loop( p3xyw.w  , daylength) ));
    uint hzw   = pcg_hash(vec4( p3zw.xyz,   loop( p3zw.w   , daylength) ));
    uint hxzw  = pcg_hash(vec4( p3xzw.xyz,  loop( p3xzw.w  , daylength) ));
    uint hyzw  = pcg_hash(vec4( p3yzw.xyz,  loop( p3yzw.w  , daylength) ));
    uint hxyzw = pcg_hash(vec4( p3xyzw.xyz, loop( p3xyzw.w , daylength) ));
    
    vec3 c     = vec3( dot(p2 - p3     , corners[h     & 15u] ), dot(p2 - p3     , corners[(h     >> 4) & 15u] ), dot(p2 - p3     , corners[(h     >> 8) & 15u] ) );
    vec3 cx    = vec3( dot(p2 - p3x    , corners[hx    & 15u] ), dot(p2 - p3x    , corners[(hx    >> 4) & 15u] ), dot(p2 - p3x    , corners[(hx    >> 8) & 15u] ) );
    vec3 cy    = vec3( dot(p2 - p3y    , corners[hy    & 15u] ), dot(p2 - p3y    , corners[(hy    >> 4) & 15u] ), dot(p2 - p3y    , corners[(hy    >> 8) & 15u] ) );
    vec3 cxy   = vec3( dot(p2 - p3xy   , corners[hxy   & 15u] ), dot(p2 - p3xy   , corners[(hxy   >> 4) & 15u] ), dot(p2 - p3xy   , corners[(hxy   >> 8) & 15u] ) );
    vec3 cz    = vec3( dot(p2 - p3z    , corners[hz    & 15u] ), dot(p2 - p3z    , corners[(hz    >> 4) & 15u] ), dot(p2 - p3z    , corners[(hz    >> 8) & 15u] ) );
    vec3 cxz   = vec3( dot(p2 - p3xz   , corners[hxz   & 15u] ), dot(p2 - p3xz   , corners[(hxz   >> 4) & 15u] ), dot(p2 - p3xz   , corners[(hxz   >> 8) & 15u] ) );
    vec3 cyz   = vec3( dot(p2 - p3yz   , corners[hyz   & 15u] ), dot(p2 - p3yz   , corners[(hyz   >> 4) & 15u] ), dot(p2 - p3yz   , corners[(hyz   >> 8) & 15u] ) );
    vec3 cxyz  = vec3( dot(p2 - p3xyz  , corners[hxyz  & 15u] ), dot(p2 - p3xyz  , corners[(hxyz  >> 4) & 15u] ), dot(p2 - p3xyz  , corners[(hxyz  >> 8) & 15u] ) );
    vec3 cw    = vec3( dot(p2 - p3w    , corners[hw    & 15u] ), dot(p2 - p3w    , corners[(hw    >> 4) & 15u] ), dot(p2 - p3w    , corners[(hw    >> 8) & 15u] ) );
    vec3 cxw   = vec3( dot(p2 - p3xw   , corners[hxw   & 15u] ), dot(p2 - p3xw   , corners[(hxw   >> 4) & 15u] ), dot(p2 - p3xw   , corners[(hxw   >> 8) & 15u] ) );
    vec3 cyw   = vec3( dot(p2 - p3yw   , corners[hyw   & 15u] ), dot(p2 - p3yw   , corners[(hyw   >> 4) & 15u] ), dot(p2 - p3yw   , corners[(hyw   >> 8) & 15u] ) );
    vec3 cxyw  = vec3( dot(p2 - p3xyw  , corners[hxyw  & 15u] ), dot(p2 - p3xyw  , corners[(hxyw  >> 4) & 15u] ), dot(p2 - p3xyw  , corners[(hxyw  >> 8) & 15u] ) );
    vec3 czw   = vec3( dot(p2 - p3zw   , corners[hzw   & 15u] ), dot(p2 - p3zw   , corners[(hzw   >> 4) & 15u] ), dot(p2 - p3zw   , corners[(hzw   >> 8) & 15u] ) );
    vec3 cxzw  = vec3( dot(p2 - p3xzw  , corners[hxzw  & 15u] ), dot(p2 - p3xzw  , corners[(hxzw  >> 4) & 15u] ), dot(p2 - p3xzw  , corners[(hxzw  >> 8) & 15u] ) );
    vec3 cyzw  = vec3( dot(p2 - p3yzw  , corners[hyzw  & 15u] ), dot(p2 - p3yzw  , corners[(hyzw  >> 4) & 15u] ), dot(p2 - p3yzw  , corners[(hyzw  >> 8) & 15u] ) );
    vec3 cxyzw = vec3( dot(p2 - p3xyzw , corners[hxyzw & 15u] ), dot(p2 - p3xyzw , corners[(hxyzw >> 4) & 15u] ), dot(p2 - p3xyzw , corners[(hxyzw >> 8) & 15u] ) );

    vec4 ratio;

    //ratio.xy = vec2(fract(p.x),fract(p.y));

    ratio.x = my_smoothstep(fract(p2.x));
    ratio.y = my_smoothstep(fract(p2.y));
    ratio.z = my_smoothstep(fract(p2.z));
    ratio.w = my_smoothstep(fract(p2.w));

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