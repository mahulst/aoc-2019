shader_type spatial;

uniform float growth  = 10.0;
uniform vec3 color  = vec3(1.0,1.0,1.0);

render_mode cull_disabled;

void fragment() {
    if (UV.x > growth) {
        discard;
    }

    ALBEDO = color;
}
