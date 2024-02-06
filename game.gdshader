shader_type canvas_item;

// Uniform variables
uniform vec2 player_position = vec2(300.0, 300.0);
uniform float hole_radius : hint_range(0, 500) = 50.0;

void vertex() {
    // Transform vertex position
    vec2 transformed = (VERTEX.xy - player_position);

    // Pass the transformed position to the fragment shader
    VERTEX = vec2(VERTEX.x, VERTEX.y);
}

void fragment() {
    // Calculate the distance from the player position
    float distance = length(SCREEN_UV - player_position);

    // Create a circle mask
    float mask = smoothstep(1.0, 0.8, 1.0 - distance / hole_radius);
  // Set the color to black only within the hole area


    // Set the color to black
    COLOR.rgb = vec3(0.0);

    // Apply the mask to alpha
    COLOR.a *= mask;
}