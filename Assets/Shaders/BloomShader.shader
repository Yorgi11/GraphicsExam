Shader "Custom/BloomShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _BloomColor("Bloom Color", Color) = (0,0,0,1)
        _Intensity("Bloom Intensity", Range(0, 10)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _BloomColor;
        float _Intensity;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Emission = _BloomColor.rgb * _Intensity;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
