Shader "Custom/ColorVertShader"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // color is set per vertex
                // 5 is fine bc it is world space
                o.color.r = (v.vertex.x + 5) / 5;
                o.color.g = (v.vertex.z + 5) / 5;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // fixed4 col = fixed(0,1,0,1);
                fixed4 col = i.color;
                // 1000 bc screen space has a larger grid system
                // color changes with position relative to cam bc its in the frag
                //col.r = (i.vertex.x + 5) / 1000;
                //col.g = (i.vertex.z + 5) / 1000;
                return col;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

//colors objects based on their vertex positions in the x and z directions. The shader does not have any properties, as the colors are generated procedurally. The SubShader block contains a single pass with a CGPROGRAM block that consists of a vertex shader(vert) and a fragment shader(frag).The vertex shader takes the input structure appdata with the vertex positions and outputs the v2f structure, which contains both the vertex positions in clip space and the per - vertex colors.The vertex shader calculates the colors for the red and green channels based on the x and z coordinates of the vertices, respectively, by adding 5 and dividing by 5. The fragment shader then takes the v2f structure and directly uses the per - vertex colors for the output color.The final output color is determined by the per - vertex colors calculated in the vertex shader, resulting in a smooth gradient of colors across the object based on its vertex positions in world space.The shader falls back to the "Diffuse" shader in case the device does not support the "Custom/ColorVertShader".