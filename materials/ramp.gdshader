shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment(){
	float pixUV = min(UV.x + 0.25, 1.0);
	
	vec4 colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	colour.rgb *= pixUV;
	COLOR = colour;


//void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
