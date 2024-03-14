shader_type spatial;
render_mode unshaded, blend_add;

void vertex() {
	vec3 relative_position = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float distance_from_camera = length(relative_position);
	vec3 relative_normal = normalize(mat3(MODELVIEW_MATRIX) * NORMAL);
	float lambert = max(0.0, dot(normalize(-relative_position), relative_normal));
	const float max_distance = 10.0;
	float ambient_light = max(0.0, (max_distance - distance_from_camera) / max_distance);

	COLOR = COLOR * (1.0 - lambert) * ambient_light;
}

void fragment() {
	ALBEDO = COLOR.rgb;
}
