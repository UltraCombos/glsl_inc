mat4 makeRotationMatrix(vec4 axis)
{    
    mat4 w = mat4(0.0);
    w[0][1] =  axis.z;
    w[0][2] = -axis.y;
    w[1][0] = -axis.z;
    w[1][2] =  axis.x;
    w[2][0] =  axis.y;
    w[2][1] = -axis.x;
    return mat4(1.0) + w * sin(axis.w) + w * w * (1.0 - cos(axis.w));
}
mat4 makeRotationMatrix(float theta, vec3 axis)
{
    return makeRotationMatrix(vec4(axis, theta));
}