shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

//uniform int pixelSize: hint_range(2, 16, 2) = 4;
uniform float pixelate: hint_range(2, 512, 4) = 256;

void fragment()
{
	vec2 uv = floor(UV * pixelate) / pixelate;
    COLOR = textureLod(SCREEN_TEXTURE, uv, 0.0);
	//vec2 iRes = 1.0 / SCREEN_PIXEL_SIZE;
	//
	//float onePixelSizeX = 1.0 / iRes.x;
	//float onePixelSizeY = 1.0 / iRes.y;
	//
	//float cellSizeX =  float(pixelSize) * onePixelSizeX;
    //float cellSizeY = float(pixelSize) * onePixelSizeY; 
	//
    //float x = cellSizeX * floor(UV.x / cellSizeX);
    //float y = cellSizeY * floor(UV.y / cellSizeY);
	//
	//COLOR = texture(SCREEN_TEXTURE, vec2(x, y));
}