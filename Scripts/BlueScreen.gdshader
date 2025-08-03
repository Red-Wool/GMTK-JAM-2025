shader_type canvas_item;

uniform bool isOn;
uniform sampler2D blueScreenTexture;

void vertex() {
	// Called for every vertex the material is visible on.
}

float rand(float inp){
	return fract(sin(inp*104.15)*1203.06);
}

void fragment() {
	vec2 uv = UV;
	if (isOn){
		uv.x += sin(smoothstep(.99,1.,rand(uv.y*.002 + TIME*.2))*100.)*.3 + rand(uv.y+TIME)*.04*sin(rand(TIME*10.+uv.y*.1));
	}
	
	vec4 col = texture(TEXTURE, uv);
	
	if (isOn){
		col.xyz = texture(blueScreenTexture, uv).xyz;
	}
	
	COLOR = col;
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
