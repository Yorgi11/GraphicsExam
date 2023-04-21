Shader "Custom/Decals"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DecalTex ("Decal", 2D) = "white" {}
        [Toggle] _ShowDecal("Show Decal", float) = 0
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert
        sampler2D _MainTex;
        sampler2D _DecalTex;
        float _ShowDecal;

        struct Input
        {
            float2 uv_MainTex;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 a = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 b = tex2D (_DecalTex, IN.uv_MainTex) * _ShowDecal;

            // o.Albedo = a.rgb * b.rgb;
            // o.Albedo = a.rgb + b.rgb;
            o.Albedo = b.r > 0.9 ? b.rgb : a.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

//allows for the application of a decal texture onto another texture. The shader has three properties: _MainTex, the primary texture; _DecalTex, the decal texture to be applied; and _ShowDecal, a toggle that controls whether or not the decal is displayed. The SubShader block consists of a single pass with a CGPROGRAM block, which utilizes the Lambert lighting model through the #pragma surface surf Lambert directive.The Input structure holds the texture coordinates for the primary texture (_MainTex).The surf function samples both the primary texture (_MainTex)and the decal texture (_DecalTex), and then multiplies the decal texture by the value of _ShowDecal, effectively controlling the decal's visibility. In the surf function, the shader evaluates whether the red channel(r) of the decal texture (b)is greater than 0.9.If true, the shader sets the output albedo to the decal color(b.rgb); otherwise, it uses the original primary texture color(a.rgb).This conditional assignment allows for the blending of the decal with the primary texture.The shader then falls back to the "Diffuse" shader in case the device does not support the "Custom/Decals" shader.