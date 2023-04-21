Shader "Custom/Outining"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Thickness("Thickness", Range(0.002, 0.1)) = 0.005
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input
        {
            float2 uv_MainTex;
        };
        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            o.Emission = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG

        Pass{
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed4 color : COLOR;
            };

            float _Thickness;
            float4 _Color;

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float2 offset = TransformViewToProjection(norm.xy);

                o.pos.xy += offset * o.pos.z * _Thickness;
                o.color = _Color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

//designed to create an outline effect around a 3D object. The shader achieves this by rendering a solid-colored silhouette of the object, slightly extruded along its normals, and drawing it behind the object itself. The shader properties include a color property(_Color) for the outline, a float value(_Thickness) to control the thickness of the outline, and a 2D texture (_MainTex) for the albedo.The SubShader block contains two separate sections.The first section, enclosed by the CGPROGRAM and ENDCG directives, defines the surface shader for rendering the object's albedo texture. It uses the Lambert lighting model with the #pragma surface surf Lambert directive and the surf() function, which sets the output emission to the sampled albedo color. The second section is the Pass block, responsible for rendering the outline.It starts with the Cull Front directive, which causes the shader to render only the back faces of the object.The CGPROGRAM and ENDCG directives within the Pass block define the custom vertex(vert) and fragment(frag) shader functions.The vert() function calculates the extruded vertex positions by offsetting the object's vertices along their normals, using the _Thickness property as a scaling factor. The frag() function simply returns the color specified by the _Color property. The result is an outline effect that surrounds the object. If the shader fails to compile or execute, the FallBack directive specifies the "Diffuse" shader as a fallback option.