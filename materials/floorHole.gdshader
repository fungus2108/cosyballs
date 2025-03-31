shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 noColour = vec4(0.0, 0.0, 0.0, 0.0);

void fragment(){
	vec2 pixUV = UV;
	
	vec2 holeCentre = vec2(0.5, 0.5);
	float holeRadius = 0.5;
	
	float pixDistance = distance(holeCentre, pixUV);
	vec4 colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	if (pixDistance < holeRadius) {
		colour.rgb *= 0.5;
		COLOR = colour;
	}
	else {
		COLOR = noColour;
	}
}

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
