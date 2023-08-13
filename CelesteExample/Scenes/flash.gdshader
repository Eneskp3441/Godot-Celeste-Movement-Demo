shader_type canvas_item;
//render_mode blend_add;
uniform vec3 color:source_color;
void fragment() {
	COLOR = vec4(color, COLOR.a);
}
