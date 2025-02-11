Shader "Unlit/Code_Create" {
    Properties {
        _Slider_Power ("Slider_Power", Range(0, 100)) = 27.13045
        _MainTex ("Main Tex", 2D) = "white" {}
        _MainCol ("Main color", Color) = (1, 1, 1, 1)
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
            #include "Lighting.cginc"
            
            uniform float _Slider_Power;
            uniform float4 _MainCol;
            uniform float4 _MainTex_ST;
            sampler2D _MainTex;
            
            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };
            
            struct VertexOutput {
                float4 posCS : SV_POSITION;
                float4 posWS : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.posCS = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld, v.vertex);
                o.nDirWS = UnityObjectToWorldNormal(v.normal);
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            float4 frag (VertexOutput i) : COLOR {
                float3 nDir = i.nDirWS;
                float3 lDir = _WorldSpaceLightPos0.xyz;
                float3 vDir = normalize(_WorldSpaceCameraPos.xyz - i.posWS);
                float3 hDir = normalize(vDir + lDir);
                float ndotl = dot(nDir, lDir);
                float ndoth = dot(nDir, hDir);
                float Lambert = max(0.0, ndotl);
                float BlinnPhong = pow(max(0, ndoth), _Slider_Power);
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _MainCol.rgb;
                float3 diffuse = _MainCol * albedo * Lambert;
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                float3 finalcolor = diffuse + _MainCol * BlinnPhong + ambient;
                return float4 (finalcolor, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
