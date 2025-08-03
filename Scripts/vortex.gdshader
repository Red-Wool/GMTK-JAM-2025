shader_type canvas_item;

uniform float anim;

uniform vec3 bgColor;
uniform vec3 shineColor;
uniform int posterizeAmount;
uniform float time;

float rand(float co) { return fract(sin(co*(91.3458)) * 47453.5453); }
vec2 rand2(vec2 co){ return vec2(rand(co.x+co.y), rand(co.y-co.x)); }

/*
vec2 noise2(vec2 inp)
{
    vec2 i = floor(inp);
    vec2 f = fract(inp);
    
    vec2 a = rand2(i);
    vec2 b = rand2(i + vec2(1,0));
    vec2 c = rand2(i + vec2(0,1));
    vec2 d = rand2(i + vec2(1,1));
    
    vec2 s = f*f*(3. - (2. * f));
    
    return mix(a, b, s.x) + (c - a) * s.y * (1.0 - s.x) + (d - b) * s.x * s.y;;
}
*/

float voronoiDistance (vec2 inp, out vec2 index)
{
    vec2 i = floor(inp);
    vec2 f = fract(inp);
    
    float d = 8.;
    vec2 sc, sd;
    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            vec2 coord = vec2(float(x),float(y));
            vec2 a = sin(rand2(i+coord)*130.49 + TIME)*.5 + .5;
            vec2 p = a-f+coord;
            
            float l = length(p);
            if (l < d)
            {
                d = l;
                sc = coord + sin(3.*TIME+4.*length(inp))*f*.01*smoothstep(2.,30.,sqrt(length(inp)));
                sd = p;
                
                index = coord;
                
                
            }
        }
    }
    
    d = 8.;
    
    for (int x = -2; x <= 2; x++)
    {
        for (int y = -2; y <= 2; y++)
        {
            vec2 coord = vec2(float(x),float(y)) + sc;
            vec2 a = sin(rand2(i+coord)*130.49 +TIME)*.5 + .5;
            vec2 p = a-f+coord;
            
            d = min(d,abs(dot((sd+p)*.5, normalize(sd-p))));
        }
    }
    
    
    return d;
}

vec2 rotate(vec2 uv, float ang)
{
    return uv * mat2(vec2(cos(ang), -sin(ang)), vec2(sin(ang), cos(ang)));
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 uv = UV - .5;
    
	
	
	uv *= 750.*.25;
	uv = floor(uv);
	uv /= 750.*.25;
	
	uv *= 24.;
    
	uv = rotate(uv, time*.1+length(uv)*.1);
    //uv -= .5;
    
    
	
	
    vec2 aO, bO, coord;
    //vec2 v = voronoi(uv, aO, bO, coord), n = noise2(v);
    
    
    float ed = voronoiDistance(uv, coord);
    //float epct =1.- smoothstep(0.,2.*((length(uv)+0.)*.5+.5),ed);
	 float epct =smoothstep(0.,2.,length(uv)+sin(length(uv))+ed-anim*15.+1.);

    float pct = sin(ed * 50.)*.5+.5;
	
	
	pct *= float(posterizeAmount);
	pct = round(pct);
	pct /= float(posterizeAmount);
    
	epct *= float(posterizeAmount);
	epct = round(epct);
	epct /= float(posterizeAmount);
	
    // Time varying pixel color
    vec3 col = vec3(.165,.239,.271)*.5;//mix(vec3(.0,.05,.05), vec3(.0,.05,.05), pct) * (1.-epct) + (vec3(0,.05,.05) * epct);

    // Output to screen
    COLOR = vec4(col,epct);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
