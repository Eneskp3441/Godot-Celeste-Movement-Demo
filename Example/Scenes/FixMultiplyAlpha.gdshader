shader_type canvas_item;
uniform vec3 color:source_color;
render_mode blend_add;
void fragment() {
	if (COLOR.a > 0.0) {
		COLOR = vec4(color, COLOR.a);
	} 
}
