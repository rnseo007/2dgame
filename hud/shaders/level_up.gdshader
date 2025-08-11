shader_type canvas_item;

uniform bool is_glowing = false; // 켜기/끄기
uniform float glow_strength : hint_range(0.0, 1.0) = 0.5; // 강도
uniform float speed : hint_range(0.1, 10.0) = 1.0; // 광택 이동 속도
uniform float width : hint_range(0.0, 1.0) = 0.8; // 광택 두께
uniform vec4 base_color : source_color = vec4(0.0, 0.706, 0.522, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.6, 1.0);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 final_color = tex * base_color;
	
    if (is_glowing && glow_strength > 0.0) {
		float center = fract(TIME * speed); // 이동하는 광택의 중심 X좌표 (0~1)
		float dist = abs(UV.x - center); // UV.x와 광택 중심 거리
		dist = min(dist, 1.0-dist);
		float mask = smoothstep(width, 0.0, dist); // 거리에 따른 마스크 (부드러운 가장자리)
		mask *= glow_strength; // 강도 반영
		
		final_color = mix(final_color, glow_color, mask); // 기본색과 광택색 섞기
	}
	COLOR = final_color;
}