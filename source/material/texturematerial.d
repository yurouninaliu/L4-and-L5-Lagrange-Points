// An example of a texture material
module texturematerial;

import pipeline, material, texture;
import bindbc.opengl;

import std.file;
import std.string;
import std.conv;
import std.stdio;

/// Represents a simple material 
class TextureMaterial : IMaterial{
		Texture mTexture1;

    /// Construct a new material for a pipeline, and load a texture for that pipeline
    this(string pipelineName, string textureFileName){
				/// delegate to the base constructor to do initialization
				super(pipelineName);
				auto fileContent = readText(textureFileName);
				auto lines = fileContent.splitLines();
				auto directory = textureFileName.split("/")[0 .. $-1].join("/") ~ "/";
				string diffusemap = directory;
				string normalmap = directory;
				string specularmap = directory;
				for (int i = 0; i < lines.length; i++){
					string line = lines[i];
					if (line.startsWith("map_Kd")){
						auto words = line.split;
						diffusemap ~= words[1];
					}
					else if (line.startsWith("map_Bump")){
						auto words = line.split;
						normalmap ~= words[1];
					}
					else if (line.startsWith("map_Ks")){
						auto words = line.split;
						specularmap ~= words[1];
					}
				}
				mTexture1 = new Texture(diffusemap);
    }

    /// TextureMaterial.Update()
    override void Update(){
        // Set our active Shader graphics pipeline 
        PipelineUse(mPipelineName);

				// Set any uniforms for our mesh if they exist in the shader
				if("sampler1" in mUniformMap){
						glActiveTexture(GL_TEXTURE0);
						glBindTexture(GL_TEXTURE_2D,mTexture1.mTextureID);
        		mUniformMap["sampler1"].Set(0);
				}
    }
}



