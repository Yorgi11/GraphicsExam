Shader "Custom/Outining"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Thickness ("Thickness", Range(0.002, 0.1)) = 0.005
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
        SubShader
    {
        ZWrite off
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        struct Input
        {
            float2 uv_MainTex;
        };
        float _Thickness;
        float4 _Color;
        void vert(inout appdata_full v) {
            v.vertex.xyz += v.normal * _Thickness;
        }
        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            o.Emission = _Color.rgb;
        }
        ENDCG

        ZWrite on
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input
        {
            float2 uv_MainTex;
        };
        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
