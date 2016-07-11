vec3 camera_position_from_model_view_matrix(mat4 m)
{
  mat4 mi = inverse(m);
  return vec3(view_matrix_inv[3][0],view_matrix_inv[3][1],view_matrix_inv[3][2]);
}
