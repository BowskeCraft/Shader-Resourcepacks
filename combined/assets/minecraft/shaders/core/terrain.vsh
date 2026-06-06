#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:chunksection.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:sample_lightmap.glsl>

#define PERLIN_TIME true
#moj_import <minecraft:noise.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    vec3 pos = Position + ChunkPosition;

    //vec3 gray = vec3(Color.r + Color.g + Color.b) / 3.0;

    float amplitude = Color.b > Color.r ? 0.1 : 0.0;

    if(amplitude > 0){
        vec3 noise;
        noise.x = perlin_noise_t(pos.yz * 0.25, 0.2, 0.0) + 0.5 * perlin_noise_t( pos.yz * 0.5, 0.4, 0.1);
        noise.y = perlin_noise_t(pos.xz * 0.25, 0.2, 4.3) + 0.5 * perlin_noise_t( pos.xz * 0.5, 0.4, 4.4);
        noise.z = perlin_noise_t(pos.xy * 0.25, 0.2, 8.6) + 0.5 * perlin_noise_t( pos.xy * 0.5, 0.4, 8.8);
        pos += noise * amplitude;
    }
    pos += CameraOffset - CameraBlockPos;

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
}
