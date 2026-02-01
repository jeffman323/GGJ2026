shader_type canvas_item;

global uniform vec2 orb_position;
uniform vec2 orb_updater;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//RenderingServer.global_shader_parameter_set("param_key", value)
	//orb_position = orb_updater;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
