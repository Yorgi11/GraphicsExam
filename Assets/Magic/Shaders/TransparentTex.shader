Shader "Custom/Holo_Shader"
{
    Properties
    {
       _MainTex("Texture", 2D) = "black"// the colour is what becomes transparent
    }
        SubShader
    {
        Tags {"Queue" = "Transparent"}
        Blend One One                       // blends the transparency one to one
        //Blend SrcAlpha OneMinusSrcAlpha   // 
        //Blend DstColor Zero               // only the specified color is visible the rest becomes transparent
        Pass{
            SetTexture[_MainTex] {combine texture}
        }
    }
        Fallback "Diffuse"
}

// designed to create a holographic effect for 3D objects using a single texture. The shader code is written using the CG programming language and has a single property, _MainTex, which represents the texture that will be used for the object. The SubShader block starts by setting the rendering queue to "Transparent," ensuring that the object is rendered with proper transparency sorting.The shader uses the "Blend One One" blending mode, which adds the source and destination colors together to create an additive blending effect.This is a common technique used to create holographic or glowing effects.The Pass block sets the texture of the object to the _MainTex property, combining the texture with the object's surface. If the shader fails to compile or execute, the Fallback directive specifies the "Diffuse" shader as a fallback option.