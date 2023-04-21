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
// utilizes a Lookup Texture (LUT) to apply color grading to an input texture. It has three properties: _MainTex, which represents the input texture; _LUT, the lookup texture used for color grading; and _Contribution, a value in the range of 0 to 1, which controls the blending between the original texture and the color-graded result. The SubShader block defines a pass that includes a CGPROGRAM block with a vertex shader(vert) and a fragment shader(frag).The appdata structure contains the vertex position and UV coordinates, while the v2f structure contains the interpolated UV coordinates and the SV_POSITION semantic.The vertex shader simply passes the UV coordinates from the input to the output structure.The COLORS constant is defined as 32.0, representing the height of the LUT in pixels. In the fragment shader, the input texture is sampled and clamped to the range 0 - 1. The _LUT_TexelSize contains the dimensions of the LUT, which are used to calculate the half - texel offsets for the X and Y axes.The shader computes the position within the LUT based on the input texture's red, green, and blue channels and samples the color grading value. Finally, the shader linearly interpolates between the original color and the graded color based on the _Contribution property, resulting in the final output color.