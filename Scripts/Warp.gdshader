shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	//uv.y /= TEXTURE_PIXEL_SIZE.y/TEXTURE_PIXEL_SIZE.x;
	uv *= 30.;
	uv = floor(uv);
	uv /= 30.;
	
	float a = 4., b = .1, t = 2.;
	for (int i = 0; i<4; i++){
		uv.x += sin(TIME*t+uv.y*a)*b;
		uv.x += sin(TIME*t+uv.x*a)*b*1.5;
		a*=2.;
		b*=.8;
		t *= .7;
	}
	
	COLOR = texture(TEXTURE, uv) * vec4(.6,.6,.6,1.);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
