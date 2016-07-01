vec3 adjustHue(vec3 c, float inputMax)
{
	vec3 color = rgb2hsv(c);
	float H = color.x + inputMax;
	while (H < 0) H += 1;
	while (H > 1) H -= 1;
	return hsv2rgb(vec3(H, color.y, color.z));
}

vec3 adjustSaturation(vec3 c, float inputMax)
{
	vec3 color = rgb2hsv(c);
	float S = clamp(color.y*inputMax, 0.0, 1.0);
	return hsv2rgb(vec3(color.x, S, color.z));
}

vec3 adjustValue(vec3 c, float inputMax)
{
	vec3 color = rgb2hsv(c);
	float V = clamp(color.z*inputMax, 0.0, 1.0);
	return hsv2rgb(vec3(color.x, color.y, V));
}