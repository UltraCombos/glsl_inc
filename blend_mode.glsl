////////// MULTIPLY /////////
vec3 blendMultiply(vec3 a, vec3 b)
{
	return a * b;
}

////////// SCREEN /////////
vec3 blendScreen(vec3 a, vec3 b)
{
	//return 1.0 - (1.0 - a) * (1.0 - b);
	return a + (1.0 - a) * b;
}

////////// OVERLAY /////////
float fOverlay(float a, float b)
{
	if (a < 0.5) return 2.0 * a * b;
	else return 1.0 - 2.0 * (1.0 - a) * (1.0 - b);
}
vec3 blendOverlay(vec3 a, vec3 b)
{
	return vec3(fOverlay(a.r, b.r), fOverlay(a.g, b.g), fOverlay(a.b, b.b));
}

////////// HARD LIGHT /////////
float fHardLight(float b, float a)
{
	if (a < 0.5) return 2.0 * a * b;
	else return 1.0 - 2.0 * (1.0 - a) * (1.0 - b);
}
vec3 blendHardLight(vec3 b, vec3 a)
{
	return vec3(fHardLight(a.r, b.r), fHardLight(a.g, b.g), fHardLight(a.b, b.b));
}

////////// SOFT LIGHT /////////
vec3 blendSoftLight(vec3 a, vec3 b)
{
	return (1.0 - 2.0 * b) * a * a + 2.0 * a * b;
}

////////// DODGE /////////
vec3 blendDodge(vec3 a, vec3 b)
{
	return 1 - (1 - a) * (1 - b);
}

////////// COLOR DODGE /////////
float fColorDodge(float a, float b)
{
	return a / clamp(1.0 - b, 0.01, 1.0);
}
vec3 blendColorDodge(vec3 a, vec3 b)
{
	return vec3(fColorDodge(a.r, b.r), fColorDodge(a.g, b.g), fColorDodge(a.b, b.b));
}

////////// COLOR BURN /////////
float fColorBurn(float a, float b)
{
	return 1.0 - (1.0 - a) / clamp(b, 0.01, 1.0);
}
vec3 blendColorBurn(vec3 a, vec3 b)
{
	return vec3(fColorBurn(a.r, b.r), fColorBurn(a.g, b.g), fColorBurn(a.b, b.b));
}

////////// LINEAR BURN /////////
vec3 blendLinearBurn(vec3 a, vec3 b)
{
	return a + b - 1.0;
}

////////// VIVID COLOR /////////
float fVividColor(float a, float b)
{
	if (b > 0.5) return fColorDodge(a, b);
	else return fColorBurn(a, b);
}
vec3 blendVividColor(vec3 a, vec3 b)
{
	return vec3(fVividColor(a.r, b.r), fVividColor(a.g, b.g), fVividColor(a.b, b.b));
}

////////// DARKEN /////////
vec3 blendDarken(vec3 a, vec3 b)
{
	return min(a, b);
}

////////// LIGHTEN /////////
vec3 blendLighten(vec3 a, vec3 b)
{
	return max(a, b);
}