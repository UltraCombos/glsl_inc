vec3 camera_position_from_model_view_matrix(mat4 m)
{
	mat4 mi = inverse(m);
	return vec3(mi[3][0],mi[3][1],mi[3][2]);
}
