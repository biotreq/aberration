shader_type spatial;
render_mode unshaded;

uniform sampler2D ground: filter_nearest_mipmap, source_color;
uniform sampler2D cliff: filter_nearest_mipmap, source_color;

void vertex() {
	vec3 relative_position = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float distance_from_camera = length(relative_position);
	vec3 relative_normal = normalize(mat3(MODELVIEW_MATRIX) * NORMAL);
	float lambert = max(0.0, dot(normalize(-relative_position), relative_normal));
	const float max_distance = 10.0;
	float ambient_light = max(0.0, (max_distance - distance_from_camera) / max_distance);

	COLOR.r = lambert * ambient_light;
	COLOR.g = NORMAL.y;
}

void fragment() {
	float factor = pow(COLOR.g, 4);
	ALBEDO = texture(ground, UV).rgb * factor;
	ALBEDO += texture(cliff, UV).rgb * (1.0 - factor);
	ALBEDO = COLOR.r * ALBEDO;
}
