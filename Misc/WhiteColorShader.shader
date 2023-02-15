shader_type canvas_item;

uniform bool active = false; //Uniform is just like an export variable 

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV); //Goes to our sprite and looks for a point and give us color at specific position
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);  // RGB and Alpha values
	vec4 new_color = previous_color;
	if(active == true) {
		new_color = white_color;
	}
	COLOR = new_color;
}
