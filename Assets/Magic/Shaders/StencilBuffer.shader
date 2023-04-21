Shader "Custom/StencilBuffer_wall"
{
    Properties
    {
        _MainTex("Diffuse", 2D) = "white" {}
    }
        SubShader
        {
            Tags { "Queue" = "Geometry" }

            Stencil {
                Ref 1               // use 1 as the value to check against
                Comp notequal       // If this stencil Ref 1 is not equal to what's in the stencil buffer, then we will keep this pixel that belongs to the Wall
                Pass keep           // If you do find a 1, don't draw it.
            }

            CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _MainTex;

            struct Input
            {
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = a.rgb;
            }
            ENDCG
        }
        FallBack "Diffuse"
}

//designed to work with the stencil buffer to conditionally render parts of a mesh based on a reference value. This shader is particularly useful for creating effects such as masking, revealing hidden objects, or creating holes in walls. The shader properties include a 2D texture (_MainTex) for the diffuse color.Within the SubShader block, the Tags directive sets the rendering queue to "Geometry," ensuring that the shader renders at the proper stage in the pipeline.The Stencil block defines the stencil buffer operations, with a reference value(Ref) set to 1. The comparison function(Comp) is set to "notequal," which means that the shader will only render pixels where the stencil buffer value is not equal to the reference value.The pass operation(Pass) is set to "keep," meaning that the stencil buffer value will remain unchanged if the comparison test succeeds. The CGPROGRAM directive is used within the SubShader block to define the main shader code.The #pragma surface surf Lambert line denotes the use of the Lambert lighting model to calculate the shader's lighting. The main function, surf(), simply samples the color from the _MainTex property and sets the output albedo to the sampled color. If the shader fails to compile or execute, the FallBack directive specifies the "Diffuse" shader as a fallback option.