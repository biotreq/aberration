shader_type canvas_item;

uniform float inner_radius;
uniform float outer_radius;
uniform float green_blue = 1.0;

void fragment() {
	const float fourth = 1.0 / 4.0;
	const float eighth = 1.0 / 8.0;
	const float sixteenth = 1.0 / 16.0;

	vec3 col = texture(TEXTURE, UV).rgb * fourth;
	col += texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.0)).rgb * eighth;
	col += texture(TEXTURE, UV - vec2(TEXTURE_PIXEL_SIZE.x, 0.0)).rgb * eighth;

	col += texture(TEXTURE, UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y)).rgb * eighth;
	col += texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)).rgb * sixteenth;
	col += texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)).rgb * sixteenth;

	col += texture(TEXTURE, UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y)).rgb * eighth;
	col += texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)).rgb * sixteenth;
	col += texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)).rgb * sixteenth;

	float alpha = (length(UV - vec2(0.5, 0.5)) - inner_radius) * outer_radius;

	COLOR.rgb = col * vec3(1.0, green_blue, green_blue);
	COLOR.a = alpha;
}
