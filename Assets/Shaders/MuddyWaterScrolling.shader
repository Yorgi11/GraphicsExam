Shader "Custom/Waves" {
    Properties{
        _MainTex("MainTex", 2D) = "white" {}
        _MainTex2("MainTex2", 2D) = "white" {}
        _ScrollX("ScrollX", Range(-5, 5)) = 1
        _Freq("Frequency", Range(0, 5)) = 3
        _Speed("Speed", Range(0, 10)) = 10
        _Amp("Amplitude", Range(0, 1)) = 0.5
    }
        SubShader{
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert

            struct Input {
                float2 uv_MainTex;
                float3 vertColor;
            };

            float _Freq;
            float _Speed;
            float _Amp;
            float _ScrollX;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            void vert(inout appdata v, out Input o) {
                UNITY_INITIALIZE_OUTPUT(Input, o);
                float t = _Time * _Speed;
                float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t + v.vertex.z * _Freq) * _Amp;
                v.vertex.y = v.vertex.y + waveHeight;
                v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
                o.vertColor = waveHeight + 2;
            }

            sampler2D _MainTex;
            sampler2D _MainTex2;

            void surf(Input IN, inout SurfaceOutput o) {
                _ScrollX *= _Time;
                float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, 0))).rgb;
                o.Albedo = water * 0.5;
            }
            ENDCG
        }
            FallBack "Diffuse"
}