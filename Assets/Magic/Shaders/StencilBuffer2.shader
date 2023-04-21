Shader "Custom/StencilBuffer_hole"
{
    Properties
    {
        _MainTex("Diffuse", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "Queue" = "Geometry-1" }

        ColorMask 0
        ZWrite off

        Stencil
        {
            Ref 1
            Comp always
            Pass replace
        }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = a.rgb;
        }
        ENDCG
    }
        FallBack "Diffuse"
}

//manipulates the stencil buffer to create a hole or a cutout effect in the object it is applied to. The shader has a single property, _MainTex, which represents the diffuse texture that will be applied to the object. The SubShader block sets the rendering queue to "Geometry-1" to ensure proper rendering order.The "ColorMask 0" and "ZWrite off" directives disable writing to the color buffer and depth buffer, respectively, ensuring that the shader only modifies the stencil buffer.The Stencil block sets the reference value to 1, the comparison function to "always," and the stencil operation to "replace." This means that the shader will always pass the stencil test and replace the stencil buffer value with the reference value(1) wherever the object is rendered.The CGPROGRAM block defines a simple Lambertian shading model.The surf function takes the texture coordinates as input and outputs the albedo of the object based on the sampled _MainTex property.If the shader fails to compile or execute, the Fallback directive specifies the "Diffuse" shader as a fallback option.