#version 450
#pragma asShaderType Gui2D

#include "../lib/standardlib.glsl"

layout(binding = 0) uniform 
AS_REFLECT_BEGIN(Model)
AS_REFLECT_ENTRY(vec3, pos, "0,0,0")
AS_REFLECT_END()
model;

layout(location = 0) out vec4 outColor;

void main(){
	outColor = vec4(1.0, 0.0, 1.0, 1.0);
}