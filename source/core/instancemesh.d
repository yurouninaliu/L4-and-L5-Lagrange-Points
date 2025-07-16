/// This file represents a mesh abstraction.
module instancemesh;

import std.stdio;
import std.math;

import linear;
import material, texturematerial;
import scene, mesh;
import surface, objgeometry;

import bindbc.opengl;


class InstanceMeshNode : ISceneNode{
    ISurface mGeometry;
    IMaterial mMaterial; // The 'shaders' and textures needed to render our mesh
    mat4[] mInstanceMatrices;
    mat4[] mOriginalInstanceMatrices;
    GLuint mInstanceVBO; 

    float mRocktime = 0.0f;
    vec3 mLocalCenterOffset;

    this(string name, ISurface geometry, IMaterial material, mat4[] instanceMatrices){
        mNodeName = name;
        mGeometry = geometry;
        mMaterial = material;
        mInstanceMatrices = instanceMatrices;
        mOriginalInstanceMatrices = instanceMatrices.dup;
        foreach (ref m; mInstanceMatrices)
            m = MatrixTranspose(m);

        auto vao = (cast(SurfaceObj)mGeometry).mVAO;
        glBindVertexArray(vao);

        glGenBuffers(1, &mInstanceVBO);
        glBindBuffer(GL_ARRAY_BUFFER, mInstanceVBO);
        glBufferData(GL_ARRAY_BUFFER, mInstanceMatrices.length * mat4.sizeof, mInstanceMatrices.ptr, GL_STATIC_DRAW);

        

        for (int i = 0; i < 4; i++){
            glEnableVertexAttribArray(3 + i); 
            glVertexAttribPointer(3 + i, 4, GL_FLOAT, GL_FALSE, mat4.sizeof, cast(void*)(i * vec4.sizeof));
            glVertexAttribDivisor(3 + i, 1); 
        }

        glBindVertexArray(0);
        
    }

    override void Update(){

        mRocktime += 0.01f;

        mRocktime = fmod(mRocktime, 2.0f * PI);

        mat4 parentTransform = ComputeParentTransform();
        
        mat4 rotation = MatrixMakeYRotation(mRocktime * 1.2f);
        
        foreach (i, ref m; mInstanceMatrices){
            mat4 model = mOriginalInstanceMatrices[i];
            model = parentTransform * MatrixMakeTranslation(mLocalCenterOffset) * rotation * model;
            m = MatrixTranspose(model);
        }

        glBindBuffer(GL_ARRAY_BUFFER, mInstanceVBO);
        glBufferData(GL_ARRAY_BUFFER, mInstanceMatrices.length * mat4.sizeof, mInstanceMatrices.ptr, GL_STATIC_DRAW);

        /// Update the material
        mMaterial.Update();

        // Update the model matrix based on the mesh we are attached to
        // mMaterial.mUniformMap["uModel"].Set(mModelMatrix.DataPtr());

        // Update all of the uniform values
        // This will happen prior to the draw call
        foreach(u ; mMaterial.mUniformMap){
            u.Transfer();
        }

        /// Render the Mesh
        // Draw our arrays
        // mGeometry.Render();

        auto vao = (cast(SurfaceObj)mGeometry).mVAO;
        glBindVertexArray(vao);

        glDrawElementsInstanced(GL_TRIANGLES, cast(int)((cast(SurfaceObj)mGeometry).mIndices.length), GL_UNSIGNED_INT, cast(void*)0, cast(int)mInstanceMatrices.length);

        glBindVertexArray(0);

    }

    /// Return the material associated with the mesh
    IMaterial GetMaterial(){
        return mMaterial;
    }

    /// Return the geometry associated with the mesh
    ISurface GetGeometry(){
        return mGeometry;
    }


    mat4 ComputeParentTransform(){
        mat4 parentTransform = MatrixMakeIdentity();
        ISceneNode parent = mParent;

        parentTransform = (cast(MeshNode)parent).mOrbit * parentTransform;
        return parentTransform;
    }



    
}

