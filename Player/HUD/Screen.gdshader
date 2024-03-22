shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float inner_radius;
uniform float magnitude;
uniform float red = 0.0;

void fragment() {
	float local_magnitude = max(0.0, (length(SCREEN_UV - vec2(0.5, 0.5)) - inner_radius) * magnitude);

	const float max_kernel_radius = 4.0;

	float kernel_radius = min(max_kernel_radius, floor(local_magnitude));
	float kernel_diameter = 1.0 + 2.0 * kernel_radius;
	float contribution = 1.0 / (kernel_diameter * kernel_diameter);

	vec2 step_size = SCREEN_PIXEL_SIZE * (local_magnitude - kernel_radius + 1.0);

	vec3 color = vec3(0.0);

	for (float x = -kernel_radius; x <= kernel_radius; x++) {
		for (float y = -kernel_radius; y <= kernel_radius; y++) {
			color += texture(screen_texture, SCREEN_UV + vec2(x, y) * step_size).rgb * contribution;
		}
	}
	
	float local_green_blue = (1.0 - red * length(SCREEN_UV - vec2(0.5, 0.5)));

	COLOR.rgb = color * vec3(1.0, local_green_blue, local_green_blue);
}
