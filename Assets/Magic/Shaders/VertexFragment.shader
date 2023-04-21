Shader "VertFrag"{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f// vertex to fragment
            {
                // POSITION vert pos float3 or float4
                // NORMAL vert normal float3
                // TEXCOORD0 is the first UV coordinate, typically float2, float3 or float4.
                // EXCOORD1, TEXCOORD2 and TEXCOORD3 are the 2nd, 3rd and 4th UV coordinates, respectively.
                // TANGENT is the tangent vector (used for normal mapping), typically a float4.
                // COLOR is the per-vertex color, typically a float4.
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex =
                UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex,i.uv);

                UNITY_APPLY_FOG(i.fogCoord,col);
                return col;
            }
            ENDCG
        }
    }
}