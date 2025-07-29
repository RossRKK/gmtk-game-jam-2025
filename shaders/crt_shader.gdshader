/*
    CRT shader for Godot Engine by Yui Kinomoto @arlez80
    Modified to include configurable scan lines
*/
shader_type canvas_item;

// Screen texture
uniform sampler2D screen_texture : hint_screen_texture;
// CRT glass curvature (flat screens can use 0.0)
uniform float crt_curve : hint_range( 0.0, 1.0 ) = 0.02;
// Scan line intensity
uniform float crt_scan_line_color : hint_range( 0.0, 1.0 ) = 0.347;
// Number of scan lines (higher values = more scan lines)
uniform float scan_line_count : hint_range( 0, 2000.0 ) = 720.0;
// Light intensity
uniform float aperture_grille_rate : hint_range( 0.0, 1.0 ) = 0.4;
// RF switch-like blur
uniform float rf_switch_esque_blur : hint_range( 0.0, 1.0 ) = 1.0;
// White noise
uniform float white_noise_rate : hint_range( 0.0, 1.0 ) = 0.0;

float random( vec2 pos )
{ 
    return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment( )
{
    // Glass curvature
    vec2 crt_curve_shift = ( vec2( 1.0, 1.0 ) - sin( UV.yx * PI ) ) * crt_curve;
    vec2 crt_curve_scale = vec2( 1.0, 1.0 ) + crt_curve_shift * 2.0;
    vec2 texture_fixed_uv = UV * crt_curve_scale - crt_curve_shift;
    vec2 fixed_uv = SCREEN_UV * crt_curve_scale - crt_curve_shift;
    
    // Hide out-of-bounds areas
    float enable_color = float( 0.0 <= texture_fixed_uv.x && texture_fixed_uv.x <= 1.0 && 0.0 <= texture_fixed_uv.y && texture_fixed_uv.y <= 1.0 );
    
    // Get original color from glass curvature + RF switch-like blur
    COLOR.rgb = (
        (
            texture( screen_texture, fixed_uv ).rgb
        *    ( 1.0 - rf_switch_esque_blur * 0.5 )
        )
    +    (
            (
                texture( screen_texture, fixed_uv + vec2( -SCREEN_PIXEL_SIZE.x * 3.1, 0.0 ) ).rgb
            +    texture( screen_texture, fixed_uv + vec2( SCREEN_PIXEL_SIZE.x * 3.1, 0.0 ) ).rgb
            )
            *    ( rf_switch_esque_blur * 0.25 )    // (RF noise) 0.5 * (want to halve the 2 texture reads) 0.5
        )
    ) * enable_color;
    COLOR.a = 1.0;
    
    // ------------------------------------------------
    // Below is per-pixel processing on the aperture grille
    vec2 aperture_grille_pixel = vec2( floor( ( fixed_uv.x / SCREEN_PIXEL_SIZE.x ) / 3.0 ) * 3.0, fixed_uv.y );
    
    // White noise
    float white_noise = random( aperture_grille_pixel + vec2( sin( TIME * 0.543254 ), cos( TIME * 0.254323563 ) ) );
    COLOR.rgb = mix(
        COLOR.rgb
    ,    vec3( white_noise, white_noise, white_noise )
    ,    white_noise_rate * enable_color
    );
    
    // Aperture grille reproduction
    float aperture_grille_point = mod( ( ( SCREEN_UV.x * crt_curve_scale.x ) - crt_curve_shift.x ) / SCREEN_PIXEL_SIZE.x, 3.0 );
    float aperture_grille_r_rate = clamp( 1.0 - aperture_grille_point, 0.0, 1.0 ) + clamp( aperture_grille_point - 2.0, 0.0, 1.0 );
    float aperture_grille_g_rate = clamp( 1.0 - abs( 1.0 - aperture_grille_point ), 0.0, 1.0 );
    float aperture_grille_b_rate = 1.0 - aperture_grille_r_rate - aperture_grille_g_rate;
    COLOR = clamp(
        COLOR * vec4(
            normalize( vec3(
                clamp( aperture_grille_r_rate, aperture_grille_rate, 1.0 )
            ,    clamp( aperture_grille_g_rate, aperture_grille_rate, 1.0 )
            ,    clamp( aperture_grille_b_rate, aperture_grille_rate, 1.0 )
            ) )
        ,    1.0
        )
    ,    vec4( 0.0, 0.0, 0.0, 0.0 )
    ,    vec4( 1.0, 1.0, 1.0, 1.0 )
    );
    
    // Configurable scan lines
    float screen_height_in_pixels = 1.0 / SCREEN_PIXEL_SIZE.y;
    float scan_line_spacing = screen_height_in_pixels / scan_line_count;
    float current_scan_line = floor(fixed_uv.y / SCREEN_PIXEL_SIZE.y / scan_line_spacing);
    
    COLOR = mix(
        COLOR
    ,    vec4( 0.0, 0.0, 0.0, 1.0 )
    ,    float( 0 == int( current_scan_line ) % 2 ) * crt_scan_line_color
    );
	}
	