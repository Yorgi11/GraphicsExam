Shader "Custom/PBR_Spec_Shader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MetallicTex("Metallic (R)", 2D) = "white" {}
        _Specular("Specular",Color) = (1,1,1,1)
    }
        SubShader
        {
            Tags {"Queue" = "Geometry"}

            CGPROGRAM
            #pragma surface surf StandardSpecular
            #pragma target 3.0

            sampler2D _MetallicTex;
            fixed4 _Specular;
            fixed4 _Color;

            struct Input
            {
                float2 uv_MetallicTex;
            };

            void surf(Input IN, inout SurfaceOutputStandardSpecular o)
            {
                o.Albedo = _Color.rgb;
                o.Smoothness = tex2D(_MetallicTex, IN.uv_MetallicTex).r;
                o.Specular = _Specular.rgb;
            }
            ENDCG
        }
            FallBack "Diffuse"
}

// implements a Physically-Based Rendering (PBR) shader with a specular workflow. The shader has three properties: _Color, which represents the object's base color; _MetallicTex, which is a 2D texture used to determine the smoothness of the object based on its red channel; and _Specular, which represents the specular color of the object. The SubShader block contains one CGPROGRAM block, which defines the surface shader function(surf).The shader uses the StandardSpecular lighting model and targets Shader Model 3.0.The Input structure contains the texture coordinates for the _MetallicTex property.In the surf function, the Albedo output is set to the _Color property, while the Smoothness output is determined by sampling the red channel of the _MetallicTex property.The Specular output is set to the _Specular property, ensuring that the object's specular color is defined by the user-specified value. The shader combines these properties to generate the final shading of the object, following a PBR specular workflow. If the hardware does not support this shader, it falls back to the built-in "Diffuse" shader.