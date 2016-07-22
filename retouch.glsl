#define GammaCorrection(color, gamma) pow(color, 1.0 / gamma)

//Given a temperature (in Kelvin), generate the RGB equivalent of an ideal black body
//NOTE: the mathematical formula used in this routine is NOT STANDARD.  I wrote it myself using self-calculated regression equations based
//		off the raw data on blackbody radiation provided at http://www.vendian.org/mncharity/dir3/blackbody/UnstableURLs/bbr_color.html
//		Because of that, I can't guarantee great precision - but the function works well enough for photo-manipulation purposes.
vec3 Temperature(float temperatureInKelvins)
{
	vec3 retColor;
	
	temperatureInKelvins = clamp(temperatureInKelvins, 1000.0, 40000.0) / 100.0;
	
	if (temperatureInKelvins <= 66.0)
	{
		retColor.r = 1.0;
		retColor.g = 0.39008157876901960784 * log(temperatureInKelvins) - 0.63184144378862745098;
	}
	else
	{
		float t = temperatureInKelvins - 60.0;
		retColor.r = 1.29293618606274509804 * pow(t, -0.1332047592);
		retColor.g = 1.12989086089529411765 * pow(t, -0.0755148492);
	}
	
	if (temperatureInKelvins >= 66.0)
		retColor.b = 1.0;
	else if(temperatureInKelvins <= 19.0)
		retColor.b = 0.0;
	else
		retColor.b = 0.54320678911019607843 * log(temperatureInKelvins - 10.0) - 1.19625408914;

	retColor = clamp(retColor,0.0,1.0);
	
	return retColor;
}

/*
** Contrast, saturation, brightness
** Code of this function is from TGM's shader pack
** http://irrlicht.sourceforge.net/phpBB2/viewtopic.php?t=21057
*/

// For all settings: 1.0 = 100% 0.5=50% 1.5 = 150%
vec3 ContrastSaturationBrightness(vec3 color, float sat, float con)
{
	// Increase or decrease theese values to adjust r, g and b color channels seperately
	const float AvgLumR = 0.5;
	const float AvgLumG = 0.5;
	const float AvgLumB = 0.5;
	
	vec3 AvgLumin = vec3(AvgLumR, AvgLumG, AvgLumB);
	float intensityf = Luminance(color);
	vec3 intensity = vec3(intensityf, intensityf, intensityf);
	vec3 satColor = mix(intensity, color, sat);
	vec3 conColor = mix(AvgLumin, satColor, con);
	return conColor;
}



vec3 FastVibranceTemperatureTint(vec3 c, float vibrance, float temp, float tint)
{
	vec3 cout;
	
	//'Calculate the gray value using the look-up table
	float avgVal = (c.r + c.g + c.b)/3;
	float maxVal = max(max(c.r, c.g), c.b);

	//'Get adjusted average
	float amtVal = abs(maxVal - avgVal) / 0.5 * vibrance;
	
	//'Apply new vibrance
	cout = c + (maxVal - c) * amtVal;
	cout = clamp(cout,0,1);
	
	//'Temperature affects the red and blue channels
	cout += vec3(temp, tint, -temp);
	cout = clamp(cout,0,1);
	
	float lum = RGBToHSL(c).b;
	vec3 hsl = RGBToHSL(cout);
	
	cout = HSLToRGB( vec3( hsl.r, hsl.g, lum ) );
	
	/////////////temp
	//float lum = Luminance(color.rgb);
	//vec3 temp_color = Temperature(temp);
	//vec3 hsl = RGBToHSL(temp_color);
	//vec3 c = HSLToRGB( vec3( hsl.r, hsl.g, lum ) );
	//color.rgb = mix(color.rgb, c, temp_amount);
	
	return cout;
}

float clarityAdj(float ori, float tmp, float clarity)
{
	if(ori < 0.5)
		return tmp + (tmp / 0.5) * (tmp - 0.5) * clarity / 100 * 0.8;
	else
		return tmp + ((1.0 - tmp) / 0.5) * (tmp - 0.5) * clarity / 100 * 0.8;
}

vec3 FastExposureContrastClarity(vec3 c, float exposure, float contrast, float clarity)
{
	vec3 cout;
	// 'Calculate exposure
	cout = c * pow(2,exposure);
	cout = clamp(cout,0,1);
	
	//'Calculate contrast 
	float lum = RGBToHSL(cout).b;
	cout = cout + (cout - 0.5) * contrast / 100;
	cout = clamp(cout,0,1);
	vec3 hsl = RGBToHSL(cout);
	float lum2 = hsl.b;
	
	if(lum2 < lum)
		cout = HSLToRGB( hsl );
	else
		cout = HSLToRGB( vec3( hsl.r, hsl.g, lum ) );
	
	//'Calculate clarity.  Clarity is simply a contrast adjustment limited to midtones.  Values at 127 are processed
	//' most strongly, with a linear decrease as input values approach 0 or 255.  Also, I reduce the strength of the
	//' adjustment by 20% to prevent blowout or gray-washing (for high or low adjustments, respectively).
	cout.r = clarityAdj(c.r, cout.r, clarity);
	cout.g = clarityAdj(c.g, cout.g, clarity);
	cout.b = clarityAdj(c.b, cout.b, clarity);
	cout = clamp(cout,0,1);

	return cout;
}


vec3 SplitTone(vec3 c, float hi_hue, float hi_sat, float balance, float lo_hue, float lo_sat)
{
	float invBalGradient = balance + 0.000001;
	float balGradient = 1 - balance + 0.000001;

	float thisGradient;
	float v = Luminance(c);
				
	vec3 cout;
		
	if(v > balGradient)
	{
		//'Gradient between balGradient and 1.
		thisGradient = 1 - (v - balGradient) / invBalGradient;
		thisGradient = clamp( thisGradient, 0, 1);
		
		vec3 hi = HSLToRGB( vec3(hi_hue, hi_sat, v) );
		cout = mix(hi, vec3(v,v,v), thisGradient);
		cout = mix(c, cout, hi_sat);
	} else
	{
		//'Gradient between 0 and balGradient.
		thisGradient = 1 - (balGradient - v) / balGradient;
		thisGradient = clamp( thisGradient, 0, 1);

		vec3 lo = HSLToRGB( vec3(lo_hue, lo_sat, v) );
		cout = mix(lo, vec3(v,v,v), thisGradient);
		cout = mix(c, cout, lo_sat);
	}
	
	return cout;
}

