shader_type canvas_item;
render_mode world_vertex_coords;

global uniform vec2 orb_position;
uniform float cutoff : hint_range(0.0, 1.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist = distance(orb_position, VERTEX);

	if(dist < 70.0) {
		discard;
		//COLOR = texture(TEXTURE, UV*.75);
	}
	else {

	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
