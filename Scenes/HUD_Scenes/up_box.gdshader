shader_type canvas_item;

//outline width & color
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;
uniform vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool outline_enabled = false;
//alpha value
const float threshold = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (outline_enabled) {
		// 현재 스프라이트의 텍스처 크기에 따른 픽셀 크기 계산 (UV 스페이스에서의 한 픽셀)
		vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
		vec4 tex_color = texture(TEXTURE, UV);
		vec4 final_color = tex_color;

		// 현재 픽셀이 투명한 경우에만 주변 이웃 확인
		if (tex_color.a < threshold) {
			bool is_outline = false;
			for (int i = -1; i <= 1; i++) {
				for (int j = -1; j <= 1; j++) {
					vec2 offset = vec2(float(i),float(j)) * pixel_size * outline_width;
					vec4 test_pixel = texture(TEXTURE, UV + offset);
					if (test_pixel.a > threshold) {
						is_outline = true;
						break;
					}
				}
				if (is_outline) {
					break;
				}
			}
			if (is_outline) {
				final_color = outline_color;
			}
		}
		COLOR = final_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
