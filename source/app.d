/// @file: 01_simple_triangle/app.d

import graphics_app;

/// Program entry point 
/// NOTE: When debugging, this is '_Dmain'
void main(string[] args)
{
    GraphicsApp app = GraphicsApp(640,640);
    app.Loop();
}
