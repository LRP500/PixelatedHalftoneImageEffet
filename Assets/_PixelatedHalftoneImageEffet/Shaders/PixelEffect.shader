Shader "Custom/PixelEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Tint("Tint", Color) = (1, 1, 1)
        _PixelWidth("Pixel width", Float) = 1.0
		_PixelHeight("Pixel height", Float) = 1.0

        [Toggle] _Greyscale("Greyscale", Range(0, 1)) = 1.0
        [Toggle] _Inverted("Inverted", Range(0, 1)) = 1.0
        _GreyscaleTreshold("Threshold", Range(0, 1)) = 0.5
        _GreyscaleIntensity("Threshold", Range(0, 1)) = 0.5

        _Brightness("Brightness", Range(-1, 1)) = 0
    }

    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
        
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            sampler2D _MainTex;
            float4 _Tint;
            half _PixelWidth;
			half _PixelHeight;

            float _Greyscale;
            float _Inverted;
            float _GreyscaleTreshold;
            float _GreyscaleIntensity;
            float _Brightness;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Pixelate
                fixed4 color = tex2D(_MainTex, i.uv);
				half dx = _PixelWidth * (1 / _ScreenParams.x);
				half dy = _PixelHeight * (1 / _ScreenParams.y);
				half2 coord = half2(dx * floor(i.uv.x / dx), dy * floor(i.uv.y / dy));
				color = tex2D(_MainTex, coord);

                // Greyscale
                float greyscale = ((color.r + color.g + color.b) / 3);
                float bwscale = step(1 - greyscale, _GreyscaleIntensity);
                float scale = lerp(greyscale, bwscale, _GreyscaleTreshold);
                float4 mono = fixed4(scale, scale, scale, 1);

                // Apply greyscale
                color = lerp(color, mono, _Greyscale);

                // Inverted
                color.rgb = lerp(color.rgb, 1 - color.rgb, _Inverted);

				return fixed4(color.r + _Brightness, color.g + _Brightness, color.b + _Brightness, 1) * _Tint;
            }

            ENDCG
        }
    }
}
