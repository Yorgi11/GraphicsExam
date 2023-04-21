Shader "Custom/Glass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _BumpMap("Normalmap", 2D) = "bump" {}
        _ScaleUV("Scale", Range(1, 20)) = 1
    }

        SubShader
        {
            Tags { "Queue" = "Transparent" }
            GrabPass { }

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float4 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 uvgrab : TEXCOORD1;
                    float2 uvbump : TEXCOORD2;
                    float4 vertex : SV_POSITION;
                };

                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                sampler2D _BumpMap;
                float4 _BumpMap_ST;
                float _ScaleUV;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);

                    #ifdef UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif

                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.uvbump = TRANSFORM_TEX(v.uv, _BumpMap);

                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg;
                    float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
                    i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

                    fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                    fixed4 tint = tex2D(_MainTex, i.uv);
                    col *= tint;

                    return col;
                }

                ENDCG
            }
        }

            FallBack "Diffuse"
}
// designed to create a glass-like effect on objects. It achieves this effect by combining the object's color information with a distortion effect, which is derived from a normal map. The shader properties include a 2D texture (_MainTex) for the input texture, a 2D bump map texture (_BumpMap) for the normal map, and a float value(_ScaleUV) to control the distortion scale.The SubShader block sets the "Queue" tag to "Transparent" for rendering transparency correctly. Inside the SubShader, the GrabPass block captures the screen's content behind the object. The Pass block contains the CGPROGRAM and ENDCG directives, defining the custom vertex (vert) and fragment (frag) shader functions. The vert() function calculates the output vertex positions and UV coordinates for the main texture, normal map, and the grabbed screen content. The frag() function unpacks the normal map, calculates the distortion offset based on the _ScaleUV property, and adjusts the UV coordinates of the grabbed screen content. It then samples the grabbed texture and the main texture, multiplying them together to create the final output color. This creates the glass-like effect, with the object's color and the distortion from the normal map applied. If the shader fails to compile or execute, the FallBack directive specifies the "Diffuse" shader as a fallback option.