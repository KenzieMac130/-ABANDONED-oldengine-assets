#ifndef ENGINE_INPUTS_GLSL
#define ENGINE_INPUTS_GLSL
#include "engineConstants.glsl"

layout(binding = AS_BINDING_GLOBAL_UBO) uniform AsGlobal{
	vec4 customParams[AS_MAX_GLOBAL_CUSTOM_PARAMS];
	double timeElapsed;
	int debugMode;
} asGlobal;

layout(binding = AS_BINDING_VIEWPORT_UBO) uniform AsViewport{
	float width;
	float height;
} asViewport;

layout(set = AS_DESCSET_TEXTURE_POOL, binding = AS_BINDING_TEXTURE_POOL) uniform sampler2D AsBindlessTextures[AS_MAX_POOLED_TEXTURES];

#define AS_STANDARD_VERTEX_INPUTS() \
layout(location = 0) in vec3 vPosition;\
layout(location = 1) in vec3 vNormal;\
layout(location = 2) in vec3 vTangent;\
layout(location = 3) in vec2 vUV0;\
layout(location = 4) in vec2 vUV1;\
layout(location = 5) in vec4 vColor;\
layout(location = 6) in uvec4 vBoneIdxs;\
layout(location = 7) in vec4 vBoneWeights;

#endif 