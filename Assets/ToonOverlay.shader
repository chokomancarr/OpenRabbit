Shader "Hidden/ToonOverlay"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ToonTex("Toon Texture", 2D) = "black" {}
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _ToonTex;
			float threshold;
			float offset;
			float ambient;
			float sharpness;
			float darkness;
			float saturate;
			float invertY;

			float3 Saturate(float3 inCol, float lum, float change) {
				float3 lum3 = float3(lum, lum, lum);
				return lum3 + (inCol - lum3)*change;
			}


			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_ToonTex, float2(i.uv.x, lerp(i.uv.y, 1-i.uv.y, invertY)));
				float lum = 0.25*col.r + 0.6*col.g + 0.15*col.b + offset;
				float bin = clamp((lum - threshold)/sharpness, 0, 1);
				float drk = clamp((1 - (1 - bin)*darkness), 1-darkness, 1);
				float4 fcol;
				fcol.rgb = Saturate(col2, lum, 1 + saturate*(1 - drk)) * drk;
				fcol.a = 1;
				ambient = lerp(ambient, 0, lum*lum);
				float4 amb = (col - float4(ambient, ambient, ambient, 0)) / lum;
				return lerp(col, fcol*lerp(1, amb, 0.3), col2.a * 2 - 1);
			}
			ENDCG
		}
	}
}
