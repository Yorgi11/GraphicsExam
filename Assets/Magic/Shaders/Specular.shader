Shader "Custom/Simple_Specular"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0)
        _SpecColor("SpecColor", Color) = (1.0,1.0,1.0)
        _Shininess("Shininess", Float) = 10
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
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform float4 _LightColor0;

            struct vertexInput
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            struct vertexOutput 
            {
                float4 pos: SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 normalDir : TEXCOORD1;
            };
            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            float4 frag(vertexOutput i) : COLOR
            {
               float3 normalDirection = i.normalDir;
               float atten = 1.0;
               // lighting
               float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
               float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
               // specular direction
               float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
               float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));
               float3 lightSeeDirection = max(0.0,dot(lightReflectDirection, viewDirection));
               float3 shininessPower = pow(lightSeeDirection, _Shininess);
               float3 specularReflection = atten * _SpecColor.rgb * shininessPower;
               float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;
               return float4(lightFinal * _Color.rgb, 1.0);
            }
            ENDCG
        }
    }
}

//designed to create a simple specular reflection effect on a 3D object. The shader has three properties: _Color, which represents the object's base color, _SpecColor, which represents the color of the specular reflections, and _Shininess, which controls the shininess or glossiness of the object's surface. The SubShader block tags the shader as "ForwardBase," indicating that it uses forward rendering.Within the Pass block, the CGPROGRAM directive defines the vertex and fragment shader functions, vert and frag, respectively.The vert function transforms the input vertex position and normal into world coordinates and clip space coordinates.The frag function calculates the final color by combining the diffuse and specular reflections of the light source.The diffuse reflection is computed using Lambertian shading, while the specular reflection is computed using the Blinn - Phong shading model.The shader also takes into account the global ambient light in the scene.The final output color is a combination of the base color, diffuse reflection, and specular reflection, with an alpha value of 1.0.