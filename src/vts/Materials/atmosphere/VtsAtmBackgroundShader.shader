Shader "Vts/AtmBackgroundShader"
{
	Properties
	{
		vtsTexAtmDensity("Vts Atmosphere Density Texture", 2D) = "" {}
	}
	SubShader
	{
		Cull Off
		ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#define VTS_ATMOSPHERE 1
			#include "UnityCG.cginc"
			#include "VtsAtmShader.cginc"

			struct vIn
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 fragDir : TEXCOORD0;
			};

			struct fOut
			{
				float4 color : SV_Target;
			};

			float4 uniCorners[4];

			v2f vert(vIn i)
			{
				v2f o;
				o.vertex = float4(i.vertex.xy, 0.0, 1.0);
				o.fragDir = lerp(
					lerp(uniCorners[0], uniCorners[1], 1.0 - i.uv.x),
					lerp(uniCorners[2], uniCorners[3], 1.0 - i.uv.x), 1.0 - i.uv.y).xyz;
				return o;
			}

			fOut frag(v2f i)
			{
				fOut o;
				float atmosphere = vtsAtmDensityDir(i.fragDir, 1001.0);
				o.color = vtsAtmColor(atmosphere, float4(0.0, 0.0, 0.0, 1.0));
				//o.color = float4(i.fragDir, 1.0);
				//o.color = float4(0.0, 1.0, 0.0, 1.0);
				return o;
			}
			ENDCG
		}
	}
}