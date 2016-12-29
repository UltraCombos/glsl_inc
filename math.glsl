#define FLT_EPSILON 1.192092896e-07

float ofMap(float value, float inputMin, float inputMax, float outputMin, float outputMax, bool bClamp) 
{
	if (abs(inputMin - inputMax) < FLT_EPSILON){
		return outputMin;
	} else {
		float outVal = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin);
		if (bClamp){
			if (outputMax < outputMin){
				if (outVal < outputMax) outVal = outputMax;
				else if (outVal > outputMin) outVal = outputMin;
			}else{
				if (outVal > outputMax) outVal = outputMax;
				else if (outVal < outputMin) outVal = outputMin;
			}
		}
		return outVal;
	}
}

vec2 ofMap(vec2 value, vec2 inputMin, vec2 inputMax, vec2 outputMin, vec2 outputMax, bool bClamp)
{
	float x = ofMap(value.x, inputMin.x, inputMax.x, outputMin.x, outputMax.x, bClamp);
	float y = ofMap(value.y, inputMin.y, inputMax.y, outputMin.y, outputMax.y, bClamp);
	return vec2(x, y);
}

vec3 ofMap(vec3 value, vec3 inputMin, vec3 inputMax, vec3 outputMin, vec3 outputMax, bool bClamp)
{
	float x = ofMap(value.x, inputMin.x, inputMax.x, outputMin.x, outputMax.x, bClamp);
	float y = ofMap(value.y, inputMin.y, inputMax.y, outputMin.y, outputMax.y, bClamp);
	float z = ofMap(value.z, inputMin.z, inputMax.z, outputMin.z, outputMax.z, bClamp);
	return vec3(x, y, z);
}

float ofWrap(float value, float from, float to)
{
	if (from > to){
		float t = from;
		from = to;
		to = t;
	}
	float cycle = to - from;
	if (cycle == 0){
		return to;
	}
	return value - cycle * floor((value - from) / cycle);
}

float ofWrapRadians(float angle, float from, float to)
{
	return ofWrap(angle, from, to);
}

float ofWrapDegrees(float angle, float from, float to)
{
	return ofWrap(angle, from, to);
}

float ofAngleDifferenceDegrees(float currentAngle, float targetAngle) 
{
	return ofWrapDegrees(targetAngle - currentAngle, -180.0, 180.0);
}

float ofAngleDifferenceRadians(float currentAngle, float targetAngle) 
{
	return ofWrapRadians(targetAngle - currentAngle, -3.141592741, 3.141592741);
}

float ofLerpDegrees(float currentAngle, float targetAngle, float pct) 
{
    return currentAngle + ofAngleDifferenceDegrees(currentAngle,targetAngle) * pct;
}

float ofLerpRadians(float currentAngle, float targetAngle, float pct) 
{
	return currentAngle + ofAngleDifferenceRadians(currentAngle,targetAngle) * pct;
}
