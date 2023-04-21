Shader "Custom/Waves"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
        _ScrollX("ScrollX", Range(-5, 5)) = 1
        _Freq("Frequency", Range(0,5)) = 3
        _Speed("Speed", Range(0,10)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5
    }
        SubShader
        {
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            struct Input
            {
                float2 uv_MainTex;
                float3 vertColor;
            };

            float _Freq;
            float _Speed;
            float _Amp;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            void vert(inout appdata v, out Input o)
            {
                UNITY_INITIALIZE_OUTPUT(Input, o);
                float t = _Time * _Speed;
                float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t + v.vertex.z * _Freq) * _Amp;
                v.vertex.y = v.vertex.y + waveHeight;
                v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
                o.vertColor = waveHeight + 2;
            }

            sampler2D _MainTex;
            void surf(Input IN, inout SurfaceOutput o)
            {
                _ScrollX *= _Time;
                float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;
                o.Albedo = water * 0.5;
            }
            ENDCG
        }
            FallBack "Diffuse"
}


//designed to create a waving effect on a mesh by modifying its vertices' positions and normals based on a sine wave function. This shader can be applied to any mesh, such as a water surface, to simulate undulating waves.The shader properties include a 2D texture (_MainTex) for the albedo, a color property(_Tint) to tint the texture, and three float values(_Freq, _Speed, and _Amp) to control the frequency, speed, and amplitude of the waves.The SubShader block contains the CGPROGRAM directive, and the #pragma surface surf Lambert vertex : vert line defines the use of the Lambert lighting model and specifies a custom vertex function(vert).The vert function calculates the wave height based on the sine wave function and the shader properties, then adjusts the vertex's y-coordinate and normal accordingly. This creates the undulating wave effect on the mesh. The surf function is responsible for the shading, combining the albedo texture with the vertex color resulting from the wave calculation. In case the shader fails to compile or execute, the FallBack directive specifies the "Diffuse" shader as a fallback option.