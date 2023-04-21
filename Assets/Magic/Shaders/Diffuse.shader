Shader "Custom/Diffuse"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {"LightMode" = "ForwardBase"}
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            uniform float4 _Color;
            uniform float4 _LightColor0;

            struct vertexInput
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            struct vertexOutput
            {
                float4 pos: SV_POSITION;
                float4 col: COLOR;
            };
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                float3 lightDirection;
                float atten = 1.0;
                lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
                //atten provides the strength of light that falls on the surface //Light and Normal direction relative to world space //avoid light angle > 90 // dot product gives intensity
                o.col = float4(diffuseReflection * _Color.rgb, 1.0);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            float4 frag(vertexOutput i) : COLOR
            {
                return i.col;
            }
            ENDCG
        }
    }
}

//implements a simple diffuse lighting model for rendering objects. The shader has one property, _Color, which defines the base color of the object. The SubShader block contains a single pass with a CGPROGRAM block that specifies both vertex and fragment shaders.The vertexInput structure holds the input vertex position and normal, while the vertexOutput structure holds the output position and color.The vertex shader, vert, computes the diffuse lighting by first transforming the normal into world space and then calculating the light direction using the built - in _WorldSpaceLightPos0 variable.The shader computes the diffuse reflection by multiplying the light color(_LightColor0) with the maximum value of the dot product between the normal direction and light direction(clamped at 0).This computation ensures that the light only affects the surface when the angle between the light and the surface normal is less than 90 degrees. The vertex shader also calculates the final color by multiplying the diffuse reflection with the object's base color (_Color). The fragment shader, frag, simply returns the color calculated in the vertex shader. This shader achieves a basic diffuse lighting effect that makes objects appear more three-dimensional in the scene.