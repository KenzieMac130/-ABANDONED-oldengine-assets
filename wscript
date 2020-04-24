import time
import re
import os
import configparser
from waflib.Task import Task

top = '.'
out = '../build/resources'



#Compile Shaders Task
class CompileShader(Task):

	def run(self):
		#Get Defines
		reflectData = ''
		for node in self.inputs:
			contents = node.read()
			if("#pragma asIgnoreMacroParser" not in contents):
				for macro in re.finditer(r'AS_REFLECT_(.*\))', contents):
					reflectData += macro.group(1) + ';'
		#Because the pain of passing '"' replace in tool
		reflectData = reflectData.replace('"', '@')
		
		#Run Command
		return self.exec_command('"%s" "%s" "%s" SPIR-V "%s"' % (self.env['SHADER_COMPILER'][0], self.inputs[0].abspath(), self.outputs[0].abspath(), reflectData))
		
	def findGlslIncludes(self, node, levels):
		nodes = []
		
		#Break Infinite Recursion
		if levels > 64:
			raise ValueError("Maximum Include Levels Reached")
			
		fileContents = node.read() #Read Node
		for includeInfo in re.finditer(r'#include "(.*)"', fileContents): #Find Include
			includeNode = node.parent.find_resource(includeInfo.group(1)) #Find Node
			if not includeNode:
				raise ValueError('Missing Include File: ' + includeInfo.group(1))
			nodes.append(includeNode)
			nodes += self.findGlslIncludes(includeNode, levels+1)
		
		return nodes
		
	def scan(self):
		self.set_inputs(self.findGlslIncludes(self.inputs[0], 0))
		return (self.inputs, time.time())
		
	def runnable_status(self):
		ret = super(CompileShader, self).runnable_status()
		bld = self.generator.bld
		return ret
		
#Compile Shaders Task
class CompileTexture(Task):

	def run(self):
		return self.exec_command('"%s" %s "%s" "%s"' % (self.env['AMD_COMPRESSONATOR'][0], self.commandArgs, self.inputs[0].abspath(), self.outputs[0].abspath()))
		
	def scan(self):
		self.commandArgs = self.inputs[1].read()
		return (self.inputs, time.time())
		
	def runnable_status(self):
		ret = super(CompileTexture, self).runnable_status()
		bld = self.generator.bld
		return ret
		
#Generate Manifest
class GenerateManifest(Task):

	def run(self):
		manifestText = '[files]\n'
		redirectIni = configparser.ConfigParser() 
		redirectIni.read_string(self.inputs[0].read())
		#Add Redirections
		for section in redirectIni["files"].items():
			manifestText += section[0] + ': ' + section[1]
		manifestText += '\n';
		#Add All Files
		for node in self.inputs[1:]:
			manifestText += '_PATH_: ' + node.relpath().replace("\\", "/") + '\n'
			
		self.outputs[0].write(manifestText)
		return 0
		
	def scan(self): #Find all output files
		return (self.inputs, time.time())
		
	def runnable_status(self):
		ret = super(GenerateManifest, self).runnable_status()
		bld = self.generator.bld
		return ret

#Configure Program
def configure(ctx):
	try:
		ctx.find_program("asShaderCompiler", path_list=
		ctx.path.abspath() + '/../build/bin/Release/ '+
		ctx.path.abspath() + '/../build/bin/ ' +
		ctx.path.abspath() + '/../build/bin/Debug/ ',
		var='SHADER_COMPILER')
	except:
		raise ValueError('asShaderCompiler not found! Please install/compile build of engine containing the tool in a "build" folder right above the current folder')
	try:
		ctx.find_program("CompressonatorCLI", path_list=os.environ['COMPRESSONATOR_ROOT']+'bin/CLI/', var='AMD_COMPRESSONATOR')
	except:
		raise ValueError("CompressonatorCLI was not found! Please install from: https://github.com/GPUOpen-Tools/Compressonator/releases")
		
def build(ctx):
	print('Building: ' + ctx.path.abspath())
	
	ctx.add_group('BuildAssets')
	ctx.add_group('Package')
	ctx.add_group('Manifest')
	outFiles = []
	
	#Build Assets
	ctx.set_group('BuildAssets')
	
	#For each GLSL file
	for file in ctx.path.ant_glob('**/*_FX.glsl'):
		fileName = file.relpath()
		outFile = ctx.path.find_or_declare(fileName.replace('glsl', 'asfx'))
		outFiles.append(outFile)
		
		#Add Task
		task = CompileShader(env=ctx.env)
		task.set_inputs(file);
		task.set_outputs(outFile)
		ctx.add_to_group(task)
		
	#For each Image file
	for file in ctx.path.ant_glob('**/*.png **/*.jpeg **/*.jpg **/*.bmp **/*.tga **/*.tiff **/*.tif **/*.ppm **/*.dds **/*.ktx **/*.exr'):
		fileName = file.relpath()
		outFile = ctx.path.find_or_declare(fileName.split('.', 1)[0] + '.ktx')
		outFiles.append(outFile)
		
		#Configuration
		settingsNode = ctx.path.make_node(fileName + '.cfg')
		if not settingsNode.exists():
			settingsNode.write('-fd BC7 -miplevels 5')
		
		#Add Task
		task = CompileTexture(env=ctx.env)
		task.set_inputs([file, settingsNode]);
		task.set_outputs(outFile)
		ctx.add_to_group(task)
	
	#Build Manifest
	ctx.set_group('Manifest')
	resourceRedirectNode = [ctx.path.find_node("AsResourceRedirect.cfg")]
	
	task = GenerateManifest(env=ctx.env)
	task.set_inputs(resourceRedirectNode + outFiles);
	task.set_outputs(ctx.path.find_or_declare("resources.cfg"))
	ctx.add_to_group(task)
	