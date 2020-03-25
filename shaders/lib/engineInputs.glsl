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

#endif 