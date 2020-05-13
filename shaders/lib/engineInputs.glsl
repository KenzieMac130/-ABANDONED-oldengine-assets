#ifndef ENGINE_INPUTS_GLSL
#define ENGINE_INPUTS_GLSL
#include "engineConstants.glsl"

layout(set = AS_DESCSET_TEXTURE_POOL, binding = AS_BINDING_TEXTURE_POOL) uniform sampler2D AsBindlessTextures[AS_MAX_POOLED_TEXTURES];

#define AS_STANDARD_VERTEX_RASTER_IO(IO) \
layout(location = 0) IO vec3 IO##VtxPosition;\
layout(location = 1) IO vec3 IO##VtxNormal;\
layout(location = 2) IO vec4 IO##VtxTangent;\
layout(location = 3) IO vec2 IO##VtxUV0;\
layout(location = 4) IO vec2 IO##VtxUV1;\
layout(location = 5) IO vec4 IO##VtxColor;

#define AS_STANDARD_VERTEX_RASTER_PASSTHROUGH()\
outVtxPosition = inVtxPosition;\
outVtxNormal = inVtxNormal;\
outVtxTangent = inVtxTangent;\
outVtxUV0 = inVtxUV0;\
outVtxUV1 = inVtxUV1;\
outVtxColor = inVtxColor;

#define AS_STANDARD_VERTEX_RASTER_DEBUG_RETURN(RETURN, DBG)\
if(DBG == 0)\
	RETURN = vec4(inVtxPosition, 1.0);\
else if(DBG == 1)\
	RETURN = vec4(inVtxNormal.xyz * 0.5 + vec3(0.5), 1.0);\
else if(DBG == 2)\
	RETURN = vec4(inVtxTangent.xyz, 1.0);\
else if(DBG == 3)\
	RETURN = vec4(inVtxTangent.www, 1.0);\
else if(DBG == 4)\
	RETURN = vec4(inVtxUV0, 0.0, 1.0);\
else if(DBG == 5)\
	RETURN = vec4(inVtxUV1, 0.0, 1.0);\
else if(DBG == 6)\
	RETURN = vec4(inVtxColor.aaa, 1.0);\
else \
	RETURN =  vec4(inVtxColor.rgb, 1.0);

#define AS_STANDARD_VERTEX_ASSEMBLY_IN() \
AS_STANDARD_VERTEX_RASTER_IO(in)\
layout(location = 6) in uvec4 inVtxBoneIdxs;\
layout(location = 7) in vec4 inVtxBoneWeights;


#define AS_STANDARD_SCENE_SHADER_INPUTS() \
layout(push_constant) uniform AsInstanceData {\
	int materialIdx;\
	int transformOffsetCurrent;\
	int transformOffsetLast;\
	int debugInfo;\
} asInstanceData;\
\
layout(binding = AS_BINDING_GLOBAL_UBO) uniform AsGlobal{\
	vec4 customParams[AS_MAX_GLOBAL_CUSTOM_PARAMS];\
	double timeElapsed;\
	int debugMode;\
} asGlobal;\
\
layout(binding = AS_BINDING_VIEWPORT_UBO) uniform AsViewport{\
	float width;\
	float height;\
} asViewport;

#endif 