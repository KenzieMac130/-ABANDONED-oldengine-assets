#version 450
#pragma asShaderType Scene

#include "../lib/standardlib.glsl"

layout(binding = 0) uniform 
AS_REFLECT_BEGIN(Model)
AS_REFLECT_ENTRY(vec3, pos, "98, 0, 67.9")
AS_REFLECT_ENTRY(vec2, pos2D, "100000, 53.3")
AS_REFLECT_EXTERN_RESOURCE_FILE_ID(textureBasic, "textures/basic.ktx")
AS_REFLECT_EXTERN_C_STRING(doot, "DOOT!!!")
AS_REFLECT_END()
model;

#ifdef AS_STAGE_VERTEX

AS_STANDARD_VERTEX_INPUTS()

layout(location = 0) out vec2 outUV;
layout(location = 1) out vec4 outColor;

void main(){
	gl_Position = vec4(vPosition, 1.0);
	outUV = vUV0;
	outColor = vColor;
}
#endif

#ifdef AS_STAGE_FRAGMENT
layout(location = 0) in vec2 inUV;
layout(location = 1) in vec4 inColor;

layout(location = 0) out vec4 fragColor;

void main(){
	fragColor = inColor;
}
#endif 