/// Triangle Creation
module objgeometry;

import bindbc.opengl;
import std.stdio;
import surface;
import std.file;
import std.string;
import std.conv;


struct VertexFormat3F2F3F{

    int vid;
    int tid;
    int nid;

    float x;
    float y;
    float z;

    float u;
    float v;

    float nx;
    float ny;
    float nz;
}
/// Geometry stores all of the vertices and/or indices for a 3D object.
/// Geometry also has the responsibility of setting up the 'attributes'
class SurfaceObj: ISurface{
    GLuint mVBO;
    GLuint mIBO;
    string mObjPath;
    size_t mTriangles;
    GLfloat[] mVertexData;
    GLuint[] mIndices;

    GLfloat[] vertex;
    GLfloat[] vertexTexture;
    GLfloat[] vertexNormal;


    VertexFormat3F2F3F[] mVertices;
    

    /// Geometry data
    this(string ObjPath){
        this.mObjPath = ObjPath;
    }
    void LoadObjFile(){
        auto fileContent = readText(this.mObjPath);
        auto lines = fileContent.splitLines();
        for (int i = 0; i < lines.length; i++){
            string line = lines[i];
            
            if (line.startsWith("v ")){
                auto words = line.split;
                for (int j = 1; j <= 3; j++){
                    auto word = words[j];
                    auto number = to!float(word);
                    this.vertex ~= number;
                }
            }
            else if (line.startsWith("vt ")){
                auto words = line.split;
                for (int j = 1; j <= 2; j++){
                    auto word = words[j];
                    auto number = to!float(word);
                    this.vertexTexture ~= number;
                }
            }
            else if (line.startsWith("vn ")){
                auto words = line.split;
                for (int j = 1; j <=3; j++){
                    auto word = words[j];
                    auto number = to!float(word);
                    this.vertexNormal ~= number;
                }
            }
            else if (line.startsWith("f")){
                auto words = line.split;
                for (int j = 1; j <=3; j++){
                    auto word = words[j];
                    auto vid = to!int(word.split("/")[0]) - 1;
                    auto tid = to!int(word.split("/")[1]) - 1;
                    auto nid = to!int(word.split("/")[2]) - 1;
                    bool found = false;
                    for (int k = 0; k < mVertices.length; k++){
                        auto vertex = mVertices[k];
                        if (vertex.vid == vid && vertex.tid == tid && vertex.nid == nid){
                            this.mTriangles++;
                            this.mIndices ~= k;
                            found = true;
                            break;
                        }
                    }
                    if (!found){
                        auto vert = VertexFormat3F2F3F(vid, tid, nid, vertex[vid*3], vertex[vid*3+1], vertex[vid*3+2], vertexTexture[tid*2], vertexTexture[tid*2+1], vertexNormal[nid*3], vertexNormal[nid*3+1], vertexNormal[nid*3+2]);
                        this.mVertices ~= vert;
                        this.mTriangles++;
                        this.mIndices ~= cast(uint)mVertices.length - 1;
                    }

                }
            }
        }
        for (int i = 0; i < this.mVertices.length; i++){
            this.mVertexData ~= this.mVertices[i].x;
            this.mVertexData ~= this.mVertices[i].y;
            this.mVertexData ~= this.mVertices[i].z;
            this.mVertexData ~= this.mVertices[i].u;
            this.mVertexData ~= this.mVertices[i].v;
            this.mVertexData ~= this.mVertices[i].nx;
            this.mVertexData ~= this.mVertices[i].ny;
            this.mVertexData ~= this.mVertices[i].nz;
        }
    }
    
    void SetUp(){
        

        // Vertex Arrays Object (VAO) Setup
        glGenVertexArrays(1, &mVAO);
        // We bind (i.e. select) to the Vertex Array Object (VAO) that we want to work withn.
        glBindVertexArray(mVAO);

        // Vertex Buffer Object (VBO) creation
        glGenBuffers(1, &mVBO);
        glBindBuffer(GL_ARRAY_BUFFER, mVBO);
        glBufferData(GL_ARRAY_BUFFER, mVertexData.length* GLfloat.sizeof, mVertexData.ptr, GL_STATIC_DRAW);

        // Vertex attributes
        // Atribute #0 Position
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, GLfloat.sizeof*8, cast(void*)0);

        // Attribute #1 Texture
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, GLfloat.sizeof*8, cast(GLvoid*)(GLfloat.sizeof*3));
        // Attribute #2 Normal
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, GLfloat.sizeof*8, cast(GLvoid*)(GLfloat.sizeof*5));

        glGenBuffers(1, &mIBO);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, mIndices.length* GLuint.sizeof, mIndices.ptr, GL_STATIC_DRAW);
        // Unbind our currently bound Vertex Array Object
        glBindVertexArray(0);
        // Disable any attributes we opened in our Vertex Attribute Arrray,
        // as we do not want to leave them open. 
        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);
        glDisableVertexAttribArray(2);
   
    }

    /// Render our geometry
    override void Render(){
        // Bind the Vertex Array Object
        glBindVertexArray(mVAO);
        // Draw the geometry
        glDrawElements(GL_TRIANGLES, cast(int)mTriangles, GL_UNSIGNED_INT, null);
        // Unbind the Vertex Array Object
        glBindVertexArray(0);
    }

}

