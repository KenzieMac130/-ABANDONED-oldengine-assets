#version 450
#pragma asShaderType Scene

#include "../lib/standardlib.glsl"

#ifdef AS_STAGE_VERTEX
AS_STANDARD_VERTEX_ASSEMBLY_IN()
AS_STANDARD_VERTEX_RASTER_IO(out)
AS_STANDARD_SCENE_SHADER_INPUTS()

void main(){
	gl_Position = vec4(inVtxPosition, 1.0);
	AS_STANDARD_VERTEX_RASTER_PASSTHROUGH();
}
#endif

#ifdef AS_STAGE_FRAGMENT
AS_STANDARD_SCENE_SHADER_INPUTS()
AS_STANDARD_VERTEX_RASTER_IO(in)

layout(location = 0) out vec4 fragColor;

void main(){
	AS_STANDARD_VERTEX_RASTER_DEBUG_RETURN(fragColor, asInstanceData.debugInfo)
}
#endif 