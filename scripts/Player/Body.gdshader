shader_type spatial;
void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y += cos(10.0*VERTEX.x) * sin(VERTEX.z);
}

void fragment() {
	// Called for every pixel the material is visible on.
  ALBEDO = vec3(0.1, 0.3, 0.5);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
