float gaussian(float x, float y, float sigma)
{
	float r = sqrt(float(x*x + y*y));
	float s = 2.0 * pow(sigma, 2);
	return (exp(-(r*r)/s)) / (3.14159 * s);
}

vec3 filterGaussianBlur(int sub)
{
	int size = int(max(sub, 1));
	float sum = 0.0;
	vec3 sampler = vec3(0);
	for (int x=-size; x<=size; x++) {
		for (int y=-size; y<=size; y++) {
			float scale = gaussian(x, y, 5.0);
			sampler += scale * texture(tex0, vTexCoord + vec2(x, y)).rgb;
			sum += scale;
		}
	}
	sampler /= sum;
	return sampler;
}

vec3 filterGaussianUnsharp(int sub)
{
	int size = int(max(sub, 1));
	float sum = 0.0;
	vec3 sampler = vec3(0);
	for (int x=-size; x<=size; x++) {
		for (int y=-size; y<=size; y++) {
			float scale = gaussian(x, y, 5.0);
			sampler -= scale * texture(tex0, vTexCoord + vec2(x, y)).rgb;
			sum += scale;
		}
	}
	sampler += (sum + 1.0) * texture(tex0, vTexCoord).rgb;
	return sampler;
}

vec3 filterBoxBlur(int sub)
{
	int size = int(max(sub, 1));
	vec3 sampler = vec3(0);
	for (int x=-size; x<=size; x++) {
		for (int y=-size; y<=size; y++) {
			sampler += texture(tex0, vTexCoord + vec2(x, y)).rgb;
		}
	}
	sampler /= pow(size*2-1, 2);
	return sampler;
}

vec3 filterSepia()
{
	float grey = dot(texture(tex0, vTexCoord).rgb, vec3(0.299, 0.587, 0.114));
	return grey * vec3(1.2, 1.0, 0.8);
}

vec3 filterEdge(int sub)
{
	int size = int(max(sub, 1));
	vec3 sampler = vec3(0);
	for (int x=-size; x<=size; x++) {
		for (int y=-size; y<=size; y++) {
			sampler -= texture(tex0, vTexCoord + vec2(x, y)).rgb;
		}
	}
	sampler += texture(tex0, vTexCoord).rgb * (pow(size*2-1, 2)+1);
	return sampler;
}

vec3 filterDilate(int sub)
{
	int size = int(max(sub, 1));
	vec3 sampler = vec3(0);
	for (int x=-size; x<=size; x++) {
		for (int y=-size; y<=size; y++) {
			sampler = max(texture(tex0, vTexCoord + vec2(x, y)).rgb, sampler);
		}
	}
	return sampler;
}

vec3 filterErode(int sub)
{
	int size = int(max(sub, 1));
	vec3 sampler = vec3(1);
	for (int x=-size; x<=size; x++) {
		for (int y=-size; y<=size; y++) {
			sampler = max(texture(tex0, vTexCoord + vec2(x, y)).rgb, sampler);
		}
	}
	return sampler;
}

