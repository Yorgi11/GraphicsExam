Shader "Custom/Ambient_Diffuse"
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
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
                // adding unity default ambient light model
                o.col = float4(lightFinal * _Color.rgb, 1.0);
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

//combines diffuse lighting with Unity's default ambient lighting model. It takes a single property, _Color, which is used to set the color of the material. The SubShader block has a single pass, consisting of a vertex shader(vert) and a fragment shader(frag).The vertex shader takes the input structure vertexInput, which contains the vertex positions and normals.It then calculates the normal direction in world space and the diffuse lighting contribution from the primary directional light source(_LightColor0) based on the dot product between the normal direction and the light direction.Afterward, the shader adds the ambient lighting contribution from Unity's default ambient light model (UNITY_LIGHTMODEL_AMBIENT.xyz) to the diffuse lighting, resulting in the final light contribution. The vertex shader outputs a vertexOutput structure containing the clip - space positions and the final light color.The fragment shader takes this structure as input and returns the calculated color for each pixel.The resulting appearance of the material will be affected by both the diffuse and ambient lighting in the scene.