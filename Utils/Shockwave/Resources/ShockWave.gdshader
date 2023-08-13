shader_type canvas_item;

uniform sampler2D shockWaves;
uniform sampler2D screenTexture : hint_screen_texture, filter_nearest;
uniform float chromatic:hint_range(0.0, 10.0, 0.02) = 1.;
void fragment() {
	float ch = 2.;
	vec4 shockWaveTex = texture(shockWaves, UV);		
	vec4 screenTex = texture(screenTexture, SCREEN_UV);
	
	vec2 pos = SCREEN_UV;
	float strength = 60.0;
	pos.x += shockWaveTex.r * (SCREEN_PIXEL_SIZE.x * strength)*shockWaveTex.a;
	pos.y += shockWaveTex.g * (SCREEN_PIXEL_SIZE.y * strength)*shockWaveTex.a;
	vec4 pixel = texture(screenTexture, pos);
	float _r = texture(screenTexture, pos + vec2(TEXTURE_PIXEL_SIZE.x * ch * (shockWaveTex.b - .2),0)).r;
	float _g = texture(screenTexture, pos + vec2(0,TEXTURE_PIXEL_SIZE.x * ch * (shockWaveTex.b - .2))).g;
	float _b = texture(screenTexture, pos + vec2(-TEXTURE_PIXEL_SIZE.x * ch * (shockWaveTex.b - .2),0)).b;
//	float alpha = max(0, (shockWaveTex.b - .5) * 2.);
	float alpha = 1.;
	vec4 chromaticTexture = vec4(_r, _g, _b, 1.);
	
	
//	COLOR = pixel;
	COLOR = mix(pixel, chromaticTexture, alpha*chromatic);
//	COLOR = shockWaveTex;
}
