Shader "Custom/VertexExtruding"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _Amount ("Extrude", Range(-1,1)) = 0.01
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        struct appdata 
        {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
            float4 texcoord: TEXCOORD0;
        };

        float _Amount;

        void vert(inout appdata v) {
            v.vertex.xyz += v.normal * _Amount * 0.01f;
        }

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

        ENDCG
    }
    FallBack "Diffuse"
}


//designed to create an extrusion effect on a mesh by modifying its vertices' positions based on their normals. This shader can be applied to any mesh to create an extruded look, which may be useful for effects such as visualizing normals or creating stylized appearances.The shader properties include a 2D texture (_MainTex) for the albedo and a float value(_Amount) to control the extrusion strength.The SubShader block houses the CGPROGRAM directive, while the #pragma surface surf Lambert vertex : vert line specifies the use of the Lambert lighting model and defines a custom vertex function(vert).The vert function calculates the new vertex positions by adding a scaled normal vector to the original vertex position, with the scaling factor determined by the _Amount property.This operation results in the extrusion effect.The surf function is responsible for the shading and sets the output albedo to the texture color sampled from the _MainTex property.If the shader fails to compile or execute, the FallBack directive specifies the "Diffuse" shader as a fallback option.