Shader "Unlit/Code_Create" {
    Properties {
        _Slider_Power ("Slider_Power", Range(0, 100)) = 27.13045
    }
    SubShader {
        Tags {
            "RenderType"="Opaque" 
        }
        Pass {
            Tags {
                "LightMode"="ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"
            uniform float _Slider_Power;
            
            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };
            
            struct VertexOutput {
                float4 posCS : SV_POSITION;
                float4 posWS : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;
            };

            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.posCS = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld, v.vertex);
                o.nDirWS = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag (VertexOutput i) : COLOR {
                float3 nDir = i.nDirWS;
                float3 lDir = _WorldSpaceLightPos0.xyz;
                float3 vDir = normalize(_WorldSpaceCameraPos.xyz - i.posWS);
                float3 hDir = normalize(vDir + lDir);
                float ndoth = dot(nDir, hDir);
                float BlinnPhong = pow(max(0, ndoth), _Slider_Power);
                return float4(BlinnPhong, BlinnPhong, BlinnPhong, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
