Shader "Custom/Lut_Shader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _LUT("LUT", 2D) = "white" {}
        _Contribution("Contribution", Range(0, 1)) = 1
    }
        SubShader
        {
            // No culling or depth
            Cull Off ZWrite Off ZTest Always

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"
                //height of the LUTs in pixels
                #define COLORS 32.0

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

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                sampler2D _MainTex;
                sampler2D _LUT;
                float4 _LUT_TexelSize;
                float _Contribution;

                fixed4 frag(v2f i) : SV_Target
                {
                    float maxColor = COLORS - 1.0;
                    fixed4 col = saturate(tex2D(_MainTex, i.uv));
                    float halfColX = 0.5 / _LUT_TexelSize.z;
                    float halfColY = 0.5 / _LUT_TexelSize.w;
                    float threshold = maxColor / COLORS;

                    float xOffset = halfColX + col.r * threshold / COLORS;
                    float yOffset = halfColY + col.g * threshold;
                    float cell = floor(col.b * maxColor);

                    float2 lutPos = float2(cell / COLORS + xOffset, yOffset);
                    float4 gradedCol = tex2D(_LUT, lutPos);

                    return lerp(col, gradedCol, _Contribution);
                }
                ENDCG
            }
        }
}

//designed to apply a color correction to a texture using a Lookup Texture (LUT). LUTs are often used in image and video processing to modify the colors and tones of an image based on a predefined set of values. The shader properties include a 2D texture (_MainTex) for the input texture, a 2D texture (_LUT)representing the Lookup Texture, and a float value(_Contribution) to control the blending between the original and color - graded textures.The SubShader block sets the Cull and ZWrite directives to Off and the ZTest directive to Always, ensuring that the shader doesn't write to the depth buffer or perform depth testing. The Pass block within the SubShader contains the CGPROGRAM and ENDCG directives, defining the custom vertex(vert) and fragment(frag) shader functions.The vert() function calculates the output vertex positions and UV coordinates.The frag() function samples the input texture and performs the color lookup using the LUT.The LUT coordinates are calculated based on the input texture's color values and the dimensions of the LUT texture. The resulting color-graded value is then blended with the original color value based on the _Contribution property. The final output color is returned as a fixed4 value, representing a 4-component color with low precision.