shader_type canvas_item;

uniform sampler2D iChannel0;
// Desired number of squares per row and column
uniform float pix_num : hint_range(1.0, 100.0, 1.0) = 50.0;
uniform bool custom = false;
uniform int cus_row_num : hint_range(1, 500, 1) = 30;
uniform int cus_col_num : hint_range(1, 500, 1) = 30;

void fragment()
{
    // Aspect ratio of the viewport
    float aspectRatio = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = UV;

    // Adjust uv coordinates to keep squares as squares
    uv.x *= aspectRatio;
    // Creating grid of squares
	if (custom == false){
		uv = vec2(
        float(int(uv.x * pix_num)) / pix_num,
        float(int(uv.y * pix_num)) / pix_num
    );
	}
	else  {
		uv = vec2(
        float(int(uv.x * float(cus_row_num))) / float(cus_row_num) ,
        float(int(uv.y * float(cus_col_num))) / float(cus_col_num)
    );
	}
    
	

    // Resetting the aspect ratio effect on x coordinate after grid placement
    uv.x /= aspectRatio;

    // Time varying pixel color
    vec3 col = texture(iChannel0,uv).rgb;

    // Output to screen
    COLOR = vec4(col, 1.0);
}
