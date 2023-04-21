Shader "Custom/Shadows"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
        {
            Pass
            {
                Tags {"LightMode" = "ForwardBase"}

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

                #include "UnityCG.cginc"
                #include "UnityLightingCommon.cginc"
                #include "Lighting.cginc" 
                #include "AutoLight.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : Normal;
                    float2 texcord : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 diff : COLOR0;
                    float4 pos : SV_POSITION;
                    SHADOW_COORDS(1)
                };

                sampler2D _MainTex;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = v.texcord;
                    half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                    half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                    o.diff = nl * _LightColor0;
                    TRANSFER_SHADOW(o)
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.uv);
                    fixed shadow = SHADOW_ATTENUATION(i);
                    col *= i.diff * shadow;
                    return col;
                }
                ENDCG
            }
            Pass
            {
                Tags {"LightMode" = "ShadowCaster"}
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_shadowcaster
                #include "UnityCG.cginc"
                struct appdata {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float4 texcoord : TEXCOORD0;
                };
                struct v2f {
                    V2F_SHADOW_CASTER;
                };
                v2f vert(appdata v)
                {
                    v2f o;
                    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                    return o;
                }
                float4 frag(v2f i) : SV_Target
                {
                    SHADOW_CASTER_FRAGMENT(i)
                }
                ENDCG
            }
        }
}

//designed to handle shadows for a 3D object using the Forward rendering path. The shader has one property, _MainTex, which represents the object's texture. The SubShader block has two Pass blocks.The first Pass block has a tag "LightMode" set to "ForwardBase", which indicates that it is responsible for handling the base pass of forward rendering.In this pass, the vertex shader function(vert) calculates the object's position, texture coordinates, and diffuse lighting. It also transfers shadow information from the vertex to the fragment shader. The fragment shader function (frag) samples the object's texture, calculates shadow attenuation, and then combines the diffuse lighting with the shadow attenuation.The resulting color is multiplied by the texture color to produce the final output color. The second Pass block has a tag "LightMode" set to "ShadowCaster", indicating that this pass is responsible for generating shadows.In this pass, the vertex shader function(vert) transfers the shadow caster information, including the normal offset, to the fragment shader.The fragment shader function(frag) calculates the shadow map information to be used in the first pass for shadow attenuation.This pass doesn't produce any visible output but is essential for generating shadows correctly in the scene.