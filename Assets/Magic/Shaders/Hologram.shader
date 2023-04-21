Shader "Custom/Holo_Shader"
{
    Properties
    {
       _RimColor("Rim Color", Color) = (0.0,0.5,0.5,0.0)
       _RimPower("Rim Power", Range(0.5,8.)) = 3.0
    }
    SubShader
    {
        Tags {"Queue" = "Transparent"}
        Pass{
            ZWrite On
            ColorMask 0
        }
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        struct Input
        {
            float3 viewDir;
        };

        float4 _RimColor;
        float _RimPower;
        void surf(Input IN, inout SurfaceOutput o)
        {
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            o.Alpha = pow(rim, _RimPower);
        }
        ENDCG
    }
    Fallback "Diffuse"
}

//creates a holographic rim lighting effect. It has two properties: _RimColor, which defines the color of the rim lighting, and _RimPower, which controls the sharpness of the rim effect. The SubShader block contains two passes.The first pass sets ZWrite to On and ColorMask to 0, which means that only the depth buffer is updated without writing any color information.This helps in handling transparent objects correctly.The second pass is a CGPROGRAM block that specifies a Lambertian shading model with alpha fading.The Input structure contains the view direction, which is used to compute the rim lighting effect. In the surf function, the shader calculates the rim value by taking the dot product of the view direction and the surface normal, which is then subtracted from 1 and clamped between 0 and 1 using the saturate function.The shader computes the emission value by multiplying the _RimColor property with the rim value raised to the power of _RimPower.The alpha value is set to the same power function result, giving the appearance of transparency around the edges.This results in a holographic rim lighting effect that fades out toward the edges of the object.The shader falls back to the "Diffuse" shader if the current rendering hardware does not support this shader.