Shader "Custom/TextureScale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScaleUVX("Scale X", Range(0.0001,10)) = 1
        _ScaleUVY("Scale Y", Range(0.0001,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ScaleUVX;
            float _ScaleUVY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x = sin(o.uv.x * _ScaleUVX);
                o.uv.y = sin(o.uv.y * _ScaleUVY);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}

// scales and warps the texture coordinates of an object to create a unique visual effect. The shader has three properties: _MainTex, representing the object's texture, and two float properties, _ScaleUVX and _ScaleUVY, which control the scaling factors for the X and Y texture coordinates respectively. The SubShader block contains one Pass block.In this pass, the vertex shader function(vert) is responsible for transforming the object's position and texture coordinates. The texture coordinates are transformed using the _MainTex_ST property, and the scaling effect is applied by multiplying the X and Y components of the texture coordinates by _ScaleUVX and _ScaleUVY, respectively. The sin function is then applied to the scaled texture coordinates to create a warping effect. The transformed texture coordinates are passed to the fragment shader function (frag), which samples the texture using the warped coordinates and returns the sampled color as the final output. This shader results in a unique, scaled, and sin-wave-warped texture appearance on the object.