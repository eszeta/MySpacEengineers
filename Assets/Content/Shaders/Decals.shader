Shader "Custom/Decals"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _CmTex ("cm (RGB)", 2D) = "white" {}
        _NgTex ("ng (RGB)", 2D) = "white" {}
        _AddTex ("add (RGB)", 2D) = "black" {}
        _AlphaMaskTex ("alphaMask (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _CmTex;
        sampler2D _NgTex;
        sampler2D _AddTex;

        struct Input
        {
            float2 uv_CmTex;
            float2 uv_NgTex;
            float2 uv_AddTex;
        };

        half _Glossiness;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 cm;
            cm = tex2D (_CmTex, IN.uv_CmTex);
    
            half metallic = cm.a;
            cm = cm  * _Color;
            
            fixed4 ng = tex2D (_NgTex, IN.uv_NgTex);
            half smoothness = ng.a;
            ng = ng * _Color;
            
            fixed4 add = tex2D(_AddTex, IN.uv_AddTex);
            o.Emission = add.g;
            o.Occlusion = add.r;
            o.Albedo = cm.rgb;
            o.Normal = normalize(ng.xyz * 2 - 1);

            o.Metallic = metallic;
            o.Smoothness = smoothness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
