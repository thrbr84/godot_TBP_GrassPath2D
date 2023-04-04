shader_type canvas_item;
render_mode blend_mix;

uniform float angle_degrees ;
uniform sampler2D noise;
uniform int samples = 8; //MUST BE A MULTIPLE OF 2
uniform float strength : hint_range(0,1.0, 0.0001);

vec4 DirectionalBlur(in vec2 uv, in vec2 MotionVector, in sampler2D Texture)
{
    vec4 Color = vec4(0.0);  
    float Noise = texture(noise,uv*20.0).x-0.485;
 
    for (int i=1; i<=samples/2; i++)
    {
	Color += texture(Texture,uv+ (float(i)*MotionVector ) /float(samples/2)*Noise*2.0);
	Color += texture(Texture,uv- (float(i)*MotionVector ) /float(samples/2)*Noise*2.0);
    }    
    return Color/(float(samples));    
}


void fragment(){
	vec2 blur_vector = vec2(cos(radians(angle_degrees)),sin(radians(angle_degrees)))*strength;
	COLOR=DirectionalBlur(UV, blur_vector*strength, TEXTURE);
}
