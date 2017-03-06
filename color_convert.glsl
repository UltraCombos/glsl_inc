//	rgb<-->hsv functions by Sam Hocevar
//	http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 rgb2hsv(float r, float g, float b) { return rgb2hsv(vec3(r, g, b)); }

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 hsv2rgb(float h, float s, float v) { return hsv2rgb(vec3(h, s, v)); }

vec3 rgb2yuv(vec3 c)
{
	float Y = 0.2989 * c.r + 0.5866 * c.g + 0.1145 * c.b;
	float Cr = -0.169 * c.r - 0.331 * c.g + 0.5 * c.b + 0.5;
	float Cb = 0.5 * c.r - 0.419 * c.g - 0.081 * c.b + 0.5;
	return vec3(Y, Cr, Cb);
}

vec3 yuv2rgb(vec3 c)
{
	float R = c.x + 1.13983 * (c.z - 0.5);
	float G = c.x - 0.39465 * (c.y - 0.5) - 0.5806 * (c.z - 0.5);
	float B = c.x + 2.03211 * (c.y - 0.5);
	return vec3(R, G, B);
}

vec3 hue( vec3 s, vec3 d )
{
	d = rgb2hsv(d);
	d.x = rgb2hsv(s).x;
	return hsv2rgb(d);
}

vec3 color( vec3 s, vec3 d )
{
	s = rgb2hsv(s);
	s.z = rgb2hsv(d).z;
	return hsv2rgb(s);
}

vec3 saturation( vec3 s, vec3 d )
{
	d = rgb2hsv(d);
	d.y = rgb2hsv(s).y;
	return hsv2rgb(d);
}

vec3 luminosity( vec3 s, vec3 d )
{
	float dLum = dot(d, vec3(0.3, 0.59, 0.11));
	float sLum = dot(s, vec3(0.3, 0.59, 0.11));
	float lum = sLum - dLum;
	vec3 c = d + lum;
	float minC = min(min(c.x, c.y), c.z);
	float maxC = max(max(c.x, c.y), c.z);
	if(minC < 0.0) return sLum + ((c - sLum) * sLum) / (sLum - minC);
	else if(maxC > 1.0) return sLum + ((c - sLum) * (1.0 - sLum)) / (maxC - sLum);
	else return c;
}

float luminance( vec3 c )
{
	return dot(color.rgb, vec3(0.299, 0.587, 0.114)); // vec3(0.2126, 0.7152, 0.0722)
}