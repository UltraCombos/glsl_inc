float map(float value, float inputMin, float inputMax, float outputMin, float outputMax)
{
	value = clamp(value, inputMin, inputMax);
	float outVal = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin);
	return outVal;
}

vec3 vec3map(vec3 value, float inputMin, float inputMax, float outputMin, float outputMax)
{
	float R = map(value.r, inputMin, inputMax, outputMin, outputMax);
	float G = map(value.g, inputMin, inputMax, outputMin, outputMax);
	float B = map(value.b, inputMin, inputMax, outputMin, outputMax);
	return vec3(R, G, B);
}

vec3 blackBodyColor(float temp)
{
    float x = temp / 1000.0;
    float x2 = x * x;
    float x3 = x2 * x;
    float x4 = x3 * x;
    float x5 = x4 * x;

    float R, G, B = 0;

    // red
    if (temp <= 6600)
        R = 1;
    else
        R = 0.0002889f * x5 - 0.01258f * x4 + 0.2148f * x3 - 1.776f * x2 + 6.907f * x - 8.723f;

    // green
    if (temp <= 6600)
        G = -4.593e-05f * x5 + 0.001424f * x4 - 0.01489f * x3 + 0.0498f * x2 + 0.1669f * x - 0.1653f;
    else
        G = -1.308e-07f * x5 + 1.745e-05f * x4 - 0.0009116f * x3 + 0.02348f * x2 - 0.3048f * x + 2.159f;

    // blue
    if (temp <= 2000)
        B = 0;
    else if (temp < 6600)
        B = 1.764e-05f * x5 + 0.0003575f * x4 - 0.01554f * x3 + 0.1549f * x2 - 0.3682f * x + 0.2386f;
    else
        B = 1;

    return vec3(R, G, B);
}