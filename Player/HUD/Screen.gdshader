shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float inner_radius;
uniform float magnitude;
uniform float red = 0.0;

void fragment() {
	float local_magnitude = max(0.0, (length(SCREEN_UV - vec2(0.5, 0.5)) - inner_radius) * magnitude);
	float lod = local_magnitude * 0.25;
	const float fourth = 1.0 / 4.0;
	const float eighth = 1.0 / 8.0;
	const float sixteenth = 1.0 / 16.0;

	vec3 col = textureLod(screen_texture, SCREEN_UV, lod).rgb * fourth;
	col += textureLod(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0) * local_magnitude, lod).rgb * eighth;
	col += textureLod(screen_texture, SCREEN_UV - vec2(SCREEN_PIXEL_SIZE.x, 0.0) * local_magnitude, lod).rgb * eighth;

	col += textureLod(screen_texture, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y) * local_magnitude, lod).rgb * eighth;
	col += textureLod(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y) * local_magnitude, lod).rgb * sixteenth;
	col += textureLod(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y) * local_magnitude, lod).rgb * sixteenth;

	col += textureLod(screen_texture, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y) * local_magnitude, lod).rgb * eighth;
	col += textureLod(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y) * local_magnitude, lod).rgb * sixteenth;
	col += textureLod(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y) * local_magnitude, lod).rgb * sixteenth;
	
	float local_green_blue = (1.0 - red * length(SCREEN_UV - vec2(0.5, 0.5)));

	COLOR.rgb = col * vec3(1.0, local_green_blue, local_green_blue);
}
