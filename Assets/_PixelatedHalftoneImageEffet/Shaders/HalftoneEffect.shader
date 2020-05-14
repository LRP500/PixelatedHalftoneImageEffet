Shader "Custom/HalftoneEffect"
{
	Properties
    {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_PrimaryColor("Primary Color", Color) = (0.3, 1, 1, 1)
		_SecondaryColor("Secondary Color", Color) = (1, 0.3, 1, 1)
		_BackgroundColor("Background Color", Color) = (0, 0, 0, 1)
		_Threshold("Threshold", Range(0, 1)) = 0.5
		_Brightness("Brightness", Color) = (0.3, 0.59, 0.11)
		_BlockSize("Block Size", Range(0, 64)) = 8
		_Spacing("Spacing", Range(1, 3)) = 1.2
	}

	SubShader
    {
		Pass
        {
			CGPROGRAM
		
        	#pragma vertex vert_img
			#pragma fragment frag
 
			#include "UnityCG.cginc"
 
			uniform sampler2D _MainTex;

			float _ObjectColor;
			float _Threshold;
			fixed4 _PrimaryColor;
			fixed4 _SecondaryColor;
			fixed4 _Brightness;
			fixed4 _BackgroundColor;
			float _BlockSize;
			float _Spacing;

			float4 frag(v2f_img i) : COLOR
            {
				float4 c = tex2D(_MainTex, i.uv);
				float lum = c.r * _Brightness.r + c.g * _Brightness.g + c.b * _Brightness.b;
				float4 output_color = _PrimaryColor;
				
                if (lum < _Threshold)
                {
					output_color = _SecondaryColor;
				}
				
                float x = i.pos.x;
				float y = i.pos.y;
				float rad = (_Spacing * _BlockSize) / 2;
				
                // depending on lum [0,1] we draw as halftone with black background.
				float cx = (x - (x % _BlockSize)) + rad;
				float cy = (y - (y % _BlockSize)) + rad;
				float dx = x - cx;
				float dy = y - cy;
				float r = sqrt((dx * dx) + (dy * dy));
				float cr = (_BlockSize * lum) / 2;
				
                if (r > cr)
                {					
					output_color = _BackgroundColor;
				}
				
                return output_color;
			}

			ENDCG
		}
	}
}