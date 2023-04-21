Shader "Custom/WaterScrolling"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FoamTex ("Albedo (RGB)", 2D) = "white" {}
        _ScrollX("ScrollX", Range(-5,5)) = 1
        _ScrollY("ScrollY", Range(-5,5)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _FoamTex;
        float _ScrollX;
        float _ScrollY;

        struct Input
        {
            float2 uv_MainTex;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            _ScrollX *= _Time;
            _ScrollY *= _Time;
            float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;
            float3 foam = (tex2D(_FoamTex, IN.uv_MainTex + float2(_ScrollX * 0.5, _ScrollY * 0.5))).rgb;
            o.Albedo = (water + foam) * 0.5;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

//The purpose of this shader is to create a water scrolling effect by blending two textures – the primary water texture and the foam texture – as they scroll in the X and Y directions at different speeds.The shader contains several properties that can be adjusted through Unity's material editor, including two 2D textures (_MainTex and _FoamTex) for the water and foam, and two float values (_ScrollX and _ScrollY) for controlling the scroll speed in both the X and Y axes. Within the SubShader block, the CGPROGRAM directive is used to define the main shader code. The #pragma surface surf Lambert line denotes the use of the Lambert lighting model to calculate the shader's lighting.The main function, surf(), calculates the scrolling of the two textures based on the _Time variable and their respective scroll speeds.It then combines the water and foam textures with a weighted average, resulting in the final output color.If the shader fails to compile or execute, the FallBack directive specifies that the "Diffuse" shader should be used as a fallback option.
