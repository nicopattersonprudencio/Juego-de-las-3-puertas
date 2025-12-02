shader_type canvas_item;

uniform float pixel_size = 20.0;

void fragment() {
    // Normal UV del label
    vec2 uv = UV;

    // Cuantizar las UV según el tamaño de píxel
    vec2 pixelated_uv = floor(uv * pixel_size) / pixel_size;

    // Muestra el color del texto usando las UV cuantizadas
    COLOR = texture(TEXTURE, pixelated_uv) * COLOR;
}
