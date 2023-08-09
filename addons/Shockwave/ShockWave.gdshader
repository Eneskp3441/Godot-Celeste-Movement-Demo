shader_type canvas_item;

uniform sampler2D shockWaves;
uniform sampler2D screenTexture : hint_screen_texture;

void fragment() {
	vec4 shockWaveTex = texture(shockWaves, UV);		
	vec4 screenTex = texture(screenTexture, SCREEN_UV);
	
	vec2 pos = SCREEN_UV;
	pos.x += (shockWaveTex.r * 2. - 1.) * 0.025;
	pos.y += (shockWaveTex.g * 2. - 1.) * 0.025;
	
	vec4 pixel = texture(screenTexture, pos);
	float gray = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
	COLOR = shockWaveTex;
}
