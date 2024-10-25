shader_type canvas_item;

void vertex() {
	UV.x += TIME * .05;
	UV.y += TIME * .05;
}