shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 1.0) = 0.9; // 강도
uniform float speed : hint_range(0.1, 10.0) = 1.0; // 광택 이동 속도
uniform float width : hint_range(0.0, 1.0) = 0.5; // 광택 두께
uniform vec4 base_color : source_color = vec4(0.0, 0.706, 0.522, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.6, 1.0);
uniform float pixel_scale_factor : hint_range(1.0, 16.0) = 1.0; //픽셀 배율 1.0이 기본

//대각선 방향 벡터 (정규화)
uniform vec2 direction = vec2(1.0, 1.0);

void fragment() {
	//텍스쳐 픽셀 크기 (x,y)
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	
	//스케일 펙터 적용
	vec2 pixel_gird = tex_size / pixel_scale_factor;
	
	//uv 양자화
	vec2 pixel_uv = floor(UV * pixel_gird) / pixel_gird;
	
	vec4 tex = texture(TEXTURE, pixel_uv);
	vec4 final_color = tex * base_color;
	
	//방향벡터 정규화
	vec2 dir = normalize(direction);
	float proj = dot(pixel_uv, dir); // UV를 방향에 투영해서 "이동 축" 만들기
	float center = fract(TIME * speed); // 이동하는 광택의 중심 X좌표 (0~1)
	
	float dist = abs(proj - center); // UV.x와 광택 중심 거리
	dist = min(dist, 1.0-dist);
	
	float mask = smoothstep(width, 0.0, dist); // 거리에 따른 마스크 (부드러운 가장자리)
	mask *= glow_strength; // 강도 반영
	mask *= tex.a; //알파값 반영
	
	final_color = mix(final_color, glow_color, mask); // 기본색과 광택색 섞기
	COLOR = final_color;
}
