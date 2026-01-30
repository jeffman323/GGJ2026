shader_type canvas_item;
uniform sampler2D existing_screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform float radius : hint_range(0.0, 1.0) = 0.2;
uniform float edge_softness : hint_range(0.0, 0.1) = 0.01;

void vertex() {

	//VERTEX += vec2(cos(TIME)*100.0, sin(TIME)*100.0); //(this makes it spin)
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Calculate distance from center
    float dist = distance(UV, vec2(0.5));

    // Create circular mask (1.0 inside, 0.0 outside)
    float mask = 1.0 - smoothstep(radius, radius + edge_softness, dist);

    // Apply shader effects here (e.g., sample texture)
	vec3 new_color = texture(existing_screen_texture, SCREEN_UV, 0.0).rgb;
	new_color = vec3(1.0) - new_color;
    vec4 tex_color = texture(existing_screen_texture, UV);

    // Apply mask to alpha
    COLOR = vec4(new_color, tex_color.a * mask);
	//vec3 new_color = texture(existing_screen_texture, SCREEN_UV, 0.0).rgb;
	//new_color = vec3(1.0) - new_color;
	//COLOR.rgb = new_color;

	// Called for every pixel the material is visible on.
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
