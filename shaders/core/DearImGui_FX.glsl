#version 450
#pragma asShaderType Gui2D

#include "../lib/standardlib.glsl"

#ifdef AS_STAGE_VERTEX
layout(location = 0) in vec2 vertPos;
layout(location = 1) in vec2 vertUV;
layout(location = 2) in vec4 vertColor;

layout(location = 0) out vec2 outUV;
layout(location = 1) out vec4 outColor;

void main(){
	gl_Position = vec4((vertPos*2 / vec2(2560,1440))-vec2(1.0), 0.0, 1.0);
	outUV = vertUV;
	outColor = vertColor;
}
#endif

#ifdef AS_STAGE_FRAGMENT
layout(binding = AS_BINDING_GUI_TEXTURE) uniform sampler2D textureSampler;

layout(location = 0) in vec2 inUV;
layout(location = 1) in vec4 inColor;

layout(location = 0) out vec4 fragColor;

void main(){
	fragColor = texture(textureSampler, inUV) * inColor;
}
#endif 