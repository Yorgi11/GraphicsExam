# GraphicsExam
 Task #1
 floor, back wall and a controlable player as well as eemy have been implemented
 as well as two rotating lights and a light that follows the player
 
 Task #2
 I used Bumpmaping to create the purple walls seen in the back ground.
This shader combines a base texture with a normal map for creating a bumpy brick surface. It
uses the Lambert lighting model for diffuse shading and falls back to the Diffuse shader if the custom shader is not supported.
 
 Task #3
 I created the flowing water using a combination of the wave shader and water scrolling shaders used in class. The shader creates a dynamic wave effects on the plane mesh by modifying the vertex positions and scrolling the texture coordinates. The vertex function adjusts the vertex position and normal based on wave height, frequency, and amplitude. Using a sine wave to create the offsets creates a smooth natural motion. A second sine wave was used along the z axis of the mesh to create an omnidirectional wave pattern, rather than the standard unidirectional pattern. The surface function then scrolls the texture coordinates and computes the final albedo output using the Lambert lighting model.

Task #4
The bloom effect was implemented using unitys default forward renderer, and the unity postprocessing volume. The bloom effect was added to the sai the player turtle is holding

Task #5
The water implements vertex extrusion when using the sine waves to transform the vertices on the plane mesh
