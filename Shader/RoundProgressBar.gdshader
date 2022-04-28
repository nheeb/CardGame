shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float border : hint_range(0, .5);
uniform float completeness : hint_range(0, 1);

float scp(float v, float imin, float imax, float omin, float omax, float p) {
	float idist = imax - imin;
	return pow(mix(omin, omax, (clamp(v, imin, imax) - imin ) / idist), p);
}

void fragment() {
	float pi = 3.14159;
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	vec2 uvc = UV - vec2(.5);
	float angle = (float(uvc.y<0.0)*(pi + acos(uvc.x / length(uvc))) + float(uvc.y>=0.0)*(acos(-uvc.x / length(uvc))) ) / (2.0 * pi);
	//float alpha_from_angle = float(angle > (1.0 - completeness));
	float stretched_completeness = scp(completeness, .0, 1., -0.05, 1., 1.);
	float alpha_from_angle = scp(angle - stretched_completeness, .0, .05, 1.0, 0.0, 1);
	ALPHA = float(length(uvc) < .5) * float(length(uvc) > .5 - border) * alpha_from_angle;
}
