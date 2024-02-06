//shader_type canvas_item;
//uniform vec2 mouse_coords = vec2(0.0, 0.0);
//uniform float transparency_radius = 0.05;
//void fragment() {
	  //float distance_to_mouse = length(UV - mouse_coords);
    //// Check if the pixel is within the specified transparency radius
    //if (distance_to_mouse <= transparency_radius) {
        //// Set alpha value to 0 (transparent)
        //COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    //} else {
        //// Leave the color unchanged for other pixels
        //COLOR = texture(TEXTURE, UV);
    //}
//}


shader_type canvas_item;

uniform sampler2D texture_to_sample;
uniform float transparency_radius = 0.05;

void fragment() {
    // Sample the specified texture at the current UV coordinates
    vec4 sample_color = texture(texture_to_sample, SCREEN_UV);

    // Check if the sampled pixel is transparent
    bool isTransparent = sample_color.a <= 0.0;

    if (isTransparent) {
        // Set alpha value to 0 (transparent)
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        // Check neighboring pixels and set their alpha to 0 if they are transparent
        for (float i = -transparency_radius; i <= transparency_radius; i += 1.0) {
            for (float j = -transparency_radius; j <= transparency_radius; j += 1.0) {
                vec2 neighbor_uv = UV + vec2(i, j) / vec2(1150.0,660.0);
                vec4 neighbor_color = texture(texture_to_sample, neighbor_uv);
                
                if (neighbor_color.a <= 0.0) {
                    // Set alpha value to 0 for neighboring transparent pixels
                    isTransparent = true;
                    break; // Exit the inner loop
                }
            }
            
            if (isTransparent) {
                break; // Exit the outer loop
            }
        }

        // Leave the color unchanged if not close to any transparent pixels
        if (!isTransparent) {
            COLOR = sample_color;
        }
    }
}
