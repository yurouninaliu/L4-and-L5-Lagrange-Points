import std.stdio;
import sdl_abstraction;
import opengl_abstraction;
import objgeometry, surface, material, texturematerial, camera, pipeline, uniform, mesh, scene, linear, renderer, instancemesh;
import bindbc.sdl;
import bindbc.opengl;
import std.array;
import std.conv;
import std.file;
import std.string;
import std.algorithm;
import std.random;
import std.math;


string getType(GLenum type){
    switch(type){
        case GL_FLOAT: return "float";
        case GL_FLOAT_VEC2: return "vec2";
        case GL_FLOAT_VEC3: return "vec3";
        case GL_FLOAT_VEC4: return "vec4";
        case GL_DOUBLE: return "double";
        case GL_DOUBLE_VEC2: return "dvec2";
        case GL_DOUBLE_VEC3: return "dvec3";
        case GL_DOUBLE_VEC4: return "dvec4";
        case GL_INT: return "int";
        case GL_INT_VEC2: return "ivec2";
        case GL_INT_VEC3: return "ivec3";
        case GL_INT_VEC4: return "ivec4";
        case GL_UNSIGNED_INT: return "unsigned int";
        case GL_UNSIGNED_INT_VEC2: return "uvec2";
        case GL_UNSIGNED_INT_VEC3: return "uvec3";
        case GL_UNSIGNED_INT_VEC4: return "uvec4";
        case GL_BOOL: return "bool";
        case GL_BOOL_VEC2: return "bvec2";
        case GL_BOOL_VEC3: return "bvec3";
        case GL_BOOL_VEC4: return "bvec4";
        case GL_FLOAT_MAT2: return "mat2";
        case GL_FLOAT_MAT3: return "mat3";
        case GL_FLOAT_MAT4: return "mat4";
        case GL_FLOAT_MAT2x3: return "mat2x3";
        case GL_FLOAT_MAT2x4: return "mat2x4";
        case GL_FLOAT_MAT3x2: return "mat3x2";
        case GL_FLOAT_MAT3x4: return "mat3x4";
        case GL_FLOAT_MAT4x2: return "mat4x2";
        case GL_FLOAT_MAT4x3: return "mat4x3";
        case GL_DOUBLE_MAT2: return "dmat2";
        case GL_DOUBLE_MAT3: return "dmat3";
        case GL_DOUBLE_MAT4: return "dmat4";
        case GL_DOUBLE_MAT2x3: return "dmat2x3";
        case GL_DOUBLE_MAT2x4: return "dmat2x4";
        case GL_DOUBLE_MAT3x2: return "dmat3x2";
        case GL_DOUBLE_MAT3x4: return "dmat3x4";
        case GL_DOUBLE_MAT4x2: return "dmat4x2";
        case GL_DOUBLE_MAT4x3: return "dmat4x3";
        case GL_SAMPLER_1D: return "sampler1D";
        case GL_SAMPLER_2D: return "sampler2D";
        case GL_SAMPLER_3D: return "sampler3D";
        case GL_SAMPLER_CUBE: return "samplerCube";
        case GL_SAMPLER_1D_SHADOW: return "sampler1DShadow";
        case GL_SAMPLER_2D_SHADOW: return "sampler2DShadow";
        case GL_SAMPLER_1D_ARRAY: return "sampler1DArray";
        case GL_SAMPLER_2D_ARRAY: return "sampler2DArray";
        case GL_SAMPLER_1D_ARRAY_SHADOW: return "sampler1DArrayShadow";
        case GL_SAMPLER_2D_ARRAY_SHADOW: return "sampler2DArrayShadow";
        case GL_SAMPLER_2D_MULTISAMPLE: return "sampler2DMS";
        case GL_SAMPLER_2D_MULTISAMPLE_ARRAY: return "sampler2DMSArray";
        case GL_SAMPLER_CUBE_SHADOW: return "samplerCubeShadow";
        case GL_SAMPLER_BUFFER: return "samplerBuffer";
        case GL_SAMPLER_2D_RECT: return "sampler2DRect";
        case GL_SAMPLER_2D_RECT_SHADOW: return "sampler2DRectShadow";
        case GL_INT_SAMPLER_1D: return "isampler1D";
        case GL_INT_SAMPLER_2D: return "isampler2D";
        case GL_INT_SAMPLER_3D: return "isampler3D";
        case GL_INT_SAMPLER_CUBE: return "isamplerCube";
        case GL_INT_SAMPLER_1D_ARRAY: return "isampler1DArray";
        case GL_INT_SAMPLER_2D_ARRAY: return "isampler2DArray";
        case GL_INT_SAMPLER_2D_MULTISAMPLE: return "isampler2DMS";
        case GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY: return "isampler2DMSArray";
        case GL_INT_SAMPLER_BUFFER: return "isamplerBuffer";
        case GL_INT_SAMPLER_2D_RECT: return "isampler2DRect";
        case GL_UNSIGNED_INT_SAMPLER_1D: return "usampler1D";
        case GL_UNSIGNED_INT_SAMPLER_2D: return "usampler2D";
        case GL_UNSIGNED_INT_SAMPLER_3D: return "usampler3D";
        case GL_UNSIGNED_INT_SAMPLER_CUBE: return "usamplerCube";
        case GL_UNSIGNED_INT_SAMPLER_1D_ARRAY: return "usampler2DArray";
        case GL_UNSIGNED_INT_SAMPLER_2D_ARRAY: return "usampler2DArray";
        case GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE: return "usampler2DMS";
        case GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY: return "usampler2DMSArray";
        case GL_UNSIGNED_INT_SAMPLER_BUFFER: return "usamplerBuffer";
        case GL_UNSIGNED_INT_SAMPLER_2D_RECT: return "usampler2DRect";
        // case GL_IMAGE_1D: return "image1D";
        // case GL_IMAGE_2D: return "image2D";
        // case GL_IMAGE_3D: return "image3D";
        // case GL_IMAGE_2D_RECT: return "image2DRect";
        // case GL_IMAGE_CUBE: return "imageCube";
        // case GL_IMAGE_BUFFER: return "imageBuffer";
        // case GL_IMAGE_1D_ARRAY: return "image1DArray";
        // case GL_IMAGE_2D_ARRAY: return "image2DArray";
        // case GL_IMAGE_2D_MULTISAMPLE: return "image2DMS";
        // case GL_IMAGE_2D_MULTISAMPLE_ARRAY: return "image2DMSArray";
        // case GL_INT_IMAGE_1D: return "iimage1D";
        // case GL_INT_IMAGE_2D: return "iimage2D";
        // case GL_INT_IMAGE_3D: return "iimage3D";
        // case GL_INT_IMAGE_2D_RECT: return "iimage2DRect";
        // case GL_INT_IMAGE_CUBE: return "iimageCube";
        // case GL_INT_IMAGE_BUFFER: return "iimageBuffer";
        // case GL_INT_IMAGE_1D_ARRAY: return "iimage1DArray";
        // case GL_INT_IMAGE_2D_ARRAY: return "iimage2DArray";
        // case GL_INT_IMAGE_2D_MULTISAMPLE: return "iimage2DMS";
        // case GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY: return "iimage2DMSArray";
        // case GL_UNSIGNED_INT_IMAGE_1D: return "uimage1D";
        // case GL_UNSIGNED_INT_IMAGE_2D: return "uimage2D";
        // case GL_UNSIGNED_INT_IMAGE_3D: return "uimage3D";
        // case GL_UNSIGNED_INT_IMAGE_2D_RECT: return "uimage2DRect";
        // case GL_UNSIGNED_INT_IMAGE_CUBE: return "uimageCube";
        // case GL_UNSIGNED_INT_IMAGE_BUFFER: return "uimageBuffer";
        // case GL_UNSIGNED_INT_IMAGE_1D_ARRAY: return "uimage1DArray";
        // case GL_UNSIGNED_INT_IMAGE_2D_ARRAY: return "uimage2DArray";
        // case GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE: return "uimage2DMS";
        // case GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY: return "uimage2DMSArray";
        // case GL_UNSIGNED_INT_ATOMIC_COUNTER: return "atomic_uint";
        default: return "unknown";
    }
}

void PrintProgram(GLuint programID){
    // TODO: Implement
    writeln("------- Shader Information --------");
    // writeln("attributes:");
    
    // int noAttributes;
    // int maxAttributeLength;
    // glGetProgramiv(programID, GL_ACTIVE_ATTRIBUTES, &noAttributes);
    // glGetProgramiv(programID, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &maxAttributeLength);
    // GLchar[] name = new GLchar[maxAttributeLength];
    // for (int i = 0; i < noAttributes; i++){
    //     glGetActiveAttrib(programID, i, maxAttributeLength, null, null, null, name.ptr);
    //     printf("#%d name:%s\n", i, name.ptr);
    // }

    writeln("uniforms:");
    int noUniforms;
    int maxUniformLength;
    glGetProgramiv(programID, GL_ACTIVE_UNIFORMS, &noUniforms);
    glGetProgramiv(programID, GL_ACTIVE_UNIFORM_MAX_LENGTH, &maxUniformLength);
    GLchar[] name = new GLchar[maxUniformLength];
    for (int i = 0; i < noUniforms; i++){
        GLsizei length;
        GLint size;
        GLenum type;
        glGetActiveUniform(programID, i, maxUniformLength, &length, &size, &type, name.ptr);
        name = name[0..length];
        writeln("#",i, " name:", getType(type), " ", name);
        // printf("#%d name:%s %s\n", i, getType(type), name.ptr);
    }

}




struct GraphicsApp{
    bool mGameIsRunning=true;
    SDL_GLContext mContext;
    SDL_Window* mWindow;

    bool mWireframeMode = false;

    int mScreenWidth = 640;
    int mScreenHeight = 640;

    Renderer mRenderer;
    SceneTree mSceneTree;

    Camera mCamera;

    /// Setup OpenGL and any libraries
    this(int width, int height){
        mScreenWidth = width;
        mScreenHeight = height;

        // Setup SDL OpenGL Version
        SDL_GL_SetAttribute( SDL_GL_CONTEXT_MAJOR_VERSION, 4 );
        SDL_GL_SetAttribute( SDL_GL_CONTEXT_MINOR_VERSION, 1 );
        SDL_GL_SetAttribute( SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE );
        // We want to request a double buffer for smooth updating.
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

        // Create an application window using OpenGL that supports SDL
        mWindow = SDL_CreateWindow( "dlang - OpenGL",
                SDL_WINDOWPOS_UNDEFINED,
                SDL_WINDOWPOS_UNDEFINED,
                mScreenWidth,
                mScreenHeight,
                SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN );

        // Create the OpenGL context and associate it with our window
        mContext = SDL_GL_CreateContext(mWindow);

        // Load OpenGL Function calls
        auto retVal = LoadOpenGLLib();

        // Check OpenGL version
        GetOpenGLVersionInfo();

        mCamera = new Camera();

        mRenderer = new Renderer(mWindow,640,640);

        mSceneTree = new SceneTree("root");
    }

    ~this(){
        // Destroy our context
        SDL_GL_DeleteContext(mContext);
        // Destroy our window
        SDL_DestroyWindow(mWindow);
    }

    /// Handle input
    void Input(){
        // Store an SDL Event
        SDL_Event event;
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT){
                writeln("Exit event triggered (probably clicked 'x' at top of the window)");
                mGameIsRunning= false;
            }
            if(event.type == SDL_KEYDOWN){
                if(event.key.keysym.scancode == SDL_SCANCODE_ESCAPE){
                    writeln("Pressed escape key and now exiting...");
                    mGameIsRunning= false;
                }
                else if (event.key.keysym.scancode == SDL_SCANCODE_TAB){
                    if (mWireframeMode){
                        mWireframeMode = false;
                        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
                    }
                    else{
                        mWireframeMode = true;
                        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
                    }
                }
                else if(event.key.keysym.sym == SDLK_s){
                        mCamera.MoveBackward();
                        mCamera.UpdateViewMatrix();
                }
                else if(event.key.keysym.sym == SDLK_w){
                        mCamera.MoveForward();
                        mCamera.UpdateViewMatrix();
                }
                else if(event.key.keysym.sym == SDLK_a){
                        mCamera.MoveLeft();
                        mCamera.UpdateViewMatrix();
                }
                else if(event.key.keysym.sym == SDLK_d){
                        mCamera.MoveRight();
                        mCamera.UpdateViewMatrix();
                }
                else if(event.key.keysym.sym == SDLK_q){
                        mCamera.MoveUp();
                        mCamera.UpdateViewMatrix();
                }
                else if(event.key.keysym.sym == SDLK_e){
                        mCamera.MoveDown();
                        mCamera.UpdateViewMatrix();
                }
                else if(event.key.keysym.scancode == SDL_SCANCODE_SPACE){
                    writeln("Pressed space key ");
                }
                else{
                    writeln("Pressed a key ");
                }
            }
        }
        // const Uint8* keystate = SDL_GetKeyboardState(null);

        // if (keystate[SDL_SCANCODE_W]) {
        //     mCamera.MoveForward();
        // }
        // if (keystate[SDL_SCANCODE_S]) {
        //     mCamera.MoveBackward();
        // }
    }

    void SetupScene(){

        string planetmesh = "./assets/planet/mars.obj";
        string planettexture = "./assets/planet/mars.mtl";
        string sunmesh = "./assets/sun/sun.obj";
        string suntexture = "./assets/sun/sun.mtl";
        string rockmesh = "./assets/rock/rock.obj";
        string rocktexture = "./assets/rock/rock.mtl";

        Pipeline texturePipeline = new Pipeline("TexturePipeline","./pipelines/texture/basic.vert","./pipelines/texture/basic.frag");
        Pipeline instancePipeline = new Pipeline("InstancePipeline","./pipelines/instance/basic.vert","./pipelines/instance/basic.frag");
        
        ISurface mObj = new SurfaceObj(planetmesh);
        (cast(SurfaceObj)mObj).LoadObjFile();
        (cast(SurfaceObj)mObj).SetUp();

        ISurface mSun = new SurfaceObj(sunmesh);
        (cast(SurfaceObj)mSun).LoadObjFile();
        (cast(SurfaceObj)mSun).SetUp();
        
        

        IMaterial mTextureMaterial = new TextureMaterial(texturePipeline.mPipelineName, planettexture);
        mTextureMaterial.AddUniform(new Uniform("sampler1", 0));
        mTextureMaterial.AddUniform(new Uniform("uModel", "mat4", null));
		mTextureMaterial.AddUniform(new Uniform("uView", "mat4", mCamera.mViewMatrix.DataPtr()));
		mTextureMaterial.AddUniform(new Uniform("uProjection", "mat4", mCamera.mProjectionMatrix.DataPtr()));
        MeshNode mMesh = new MeshNode("planet",mObj,mTextureMaterial);
        mSceneTree.GetRootNode().AddChildSceneNode(mMesh);
        
        IMaterial mSunMaterial = new TextureMaterial(texturePipeline.mPipelineName, suntexture);
        mSunMaterial.AddUniform(new Uniform("sampler1", 0));
        mSunMaterial.AddUniform(new Uniform("uModel", "mat4", null));
        mSunMaterial.AddUniform(new Uniform("uView", "mat4", mCamera.mViewMatrix.DataPtr()));
        mSunMaterial.AddUniform(new Uniform("uProjection", "mat4", mCamera.mProjectionMatrix.DataPtr()));
        MeshNode mSunMesh = new MeshNode("sun",mSun,mSunMaterial);
        mSceneTree.GetRootNode().AddChildSceneNode(mSunMesh);

        ISurface mRockObjL4 = new SurfaceObj(rockmesh);
        (cast(SurfaceObj)mRockObjL4).LoadObjFile();
        (cast(SurfaceObj)mRockObjL4).SetUp();

        ISurface mRockObjL5 = new SurfaceObj(rockmesh);
        (cast(SurfaceObj)mRockObjL5).LoadObjFile();
        (cast(SurfaceObj)mRockObjL5).SetUp();



        IMaterial mRockMaterialL4 = new TextureMaterial(instancePipeline.mPipelineName, rocktexture);
        mRockMaterialL4.AddUniform(new Uniform("sampler1", 0));
        mRockMaterialL4.AddUniform(new Uniform("uView", "mat4", mCamera.mViewMatrix.DataPtr()));
        mRockMaterialL4.AddUniform(new Uniform("uProjection", "mat4", mCamera.mProjectionMatrix.DataPtr()));

        IMaterial mRockMaterialL5 = new TextureMaterial(instancePipeline.mPipelineName, rocktexture);
        mRockMaterialL5.AddUniform(new Uniform("sampler1", 0));
        mRockMaterialL5.AddUniform(new Uniform("uView", "mat4", mCamera.mViewMatrix.DataPtr()));
        mRockMaterialL5.AddUniform(new Uniform("uProjection", "mat4", mCamera.mProjectionMatrix.DataPtr()));
        float r = 6.0f;
        vec3 l4Offset = vec3(-cos(PI / 3.0) * r, 0,  sin(PI / 3.0) * r);
        vec3 l5Offset = vec3(-cos(PI / 3.0) * r, 0, -sin(PI / 3.0) * r);
        mat4[] rockField = createRockField();
        InstanceMeshNode mRockMeshL4 = new InstanceMeshNode("rock", mRockObjL4, mRockMaterialL4, rockField);
        mRockMeshL4.mLocalCenterOffset = l4Offset;
        mMesh.AddChildSceneNode(mRockMeshL4);

        rockField = createRockField();
        InstanceMeshNode mRockMeshL5 = new InstanceMeshNode("rock", mRockObjL5, mRockMaterialL5, rockField);
        mRockMeshL5.mLocalCenterOffset = l5Offset;
        mMesh.AddChildSceneNode(mRockMeshL5);

        // foreach (i, mat; rockField) {
        //     writeln("Matrix ", i, ":");
        //     writeln(mat);
        // }
        
    }

    mat4[] createRockField(){
        int numRocks = 300;
        mat4[] rockField;
        float ellipseA = 1.0f;
        float ellipseB = 0.4f;
        
        for (int i = 0; i < numRocks; i++){
            mat4 rockTransform;

            float rotation = std.random.uniform(0.0f, 360.0f);
            rockTransform = MatrixMakeYRotation(rotation);

            float phase = std.random.uniform(0.0f, 2.0f * PI);
            
            float x = ellipseA * cos(phase) + std.random.uniform(-1.0f, 1.0f);
            float z = ellipseB * sin(phase) + std.random.uniform(-1.0f, 1.0f);
            float y = std.random.uniform(-0.5f, 0.5f);
            rockTransform = rockTransform * MatrixMakeTranslation(vec3(x, y, z));

            float scale = std.random.uniform(0.05f, 0.07f);
            rockTransform = rockTransform * MatrixMakeScale(vec3(scale, scale, scale));

            // rockTransform = MatrixMakeTranslation(offset) * rockTransform;

            rockField ~= rockTransform;
        }
        return rockField;
    }

    /// Update gamestate
    void Update(){
        static float yRotation = 0.0f;   yRotation += 0.003f;
        static float planetSelfSpin = 0.0f;   planetSelfSpin += 0.01f;
        MeshNode mMesh = cast(MeshNode)mSceneTree.FindNode("planet");
        mMesh.mModelMatrix = MatrixMakeYRotation(yRotation);
        mMesh.mModelMatrix = mMesh.mModelMatrix * MatrixMakeTranslation(vec3(6.0f, 0.0f, 0.0f));
        mat4 orbit = mMesh.mModelMatrix;
        mMesh.mOrbit = orbit;
        mMesh.mModelMatrix  = mMesh.mModelMatrix * MatrixMakeYRotation(planetSelfSpin);
        


        static float sunyRotation = 0.0f;   sunyRotation += 0.01f;
        MeshNode msunMesh = cast(MeshNode)mSceneTree.FindNode("sun");
        msunMesh.mModelMatrix = MatrixMakeTranslation(vec3(0.0f,0.0f,0.0f));
        msunMesh.mModelMatrix = msunMesh.mModelMatrix * MatrixMakeYRotation(sunyRotation);
        msunMesh.mModelMatrix = msunMesh.mModelMatrix * MatrixMakeScale(vec3(2.0f,2.0f,2.0f));

    }

    void Render(){
        // Clear the renderer each time we render
        // glViewport(0,0,mScreenWidth,mScreenHeight);
        // glClearColor(0.0f,0.6f,0.8f,1.0f);
        // glClear(GL_COLOR_BUFFER_BIT);
        // glEnable(GL_DEPTH);


        mRenderer.Render(mSceneTree,mCamera);

        
        // glDrawElements(GL_TRIANGLES,cast(int) mObj.mTriangles, GL_UNSIGNED_INT, null);

        // Final step is to present what we have copied into
        // video memory
        // SDL_GL_SwapWindow(mWindow);
    }

    /// Process 1 frame
    void AdvanceFrame(){
        Input();
        Update();
        Render();
        SDL_Delay(16);
    }

    /// Main application loop
    void Loop(){
        // Setup the graphics scene
        
        SetupScene();
        // Run the graphics application loop
        while(mGameIsRunning){
            AdvanceFrame();
        }
    }
}
