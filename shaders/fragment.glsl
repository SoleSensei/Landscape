#version 330 core
in vec3 vFragPosition;
in vec2 vTexCoords;
in vec3 vNormal;
uniform int mode;
uniform sampler2D rock_tex; 
uniform sampler2D sand_tex;
uniform sampler2D aqua_tex;
uniform sampler2D snow_tex;

out vec4 color;

vec3 smooth_color(in float border, in vec3 prev_col, in vec3 cur_col)
{
    float h = vFragPosition.y;
    if (h >= border + 2.0f)
        return cur_col;

    float p = int(h * 100) % 100;
    vec3 col;
    if (h < border + 1.0f)
        col = (p*cur_col+(200-p)*prev_col) / 200;
    else
        col = ((100+p)*cur_col+(100-p)*prev_col) / 200;

    return col;
}

vec4 smooth_tex(in float border, in sampler2D prev_tex, in sampler2D cur_tex)
{
    float h = vFragPosition.y;    
    if (h >= border + 2.0f)
        return texture(cur_tex, vTexCoords);
    
    float p = int(h * 100) % 100;
    vec4 tex;
    if (h < border + 1.0f)
        tex = mix(texture(prev_tex,vTexCoords), texture(cur_tex,vTexCoords), p/200);
    else
        tex = mix(texture(prev_tex,vTexCoords), texture(cur_tex,vTexCoords), 0.5+p/200);

    return tex;   
}

void main()
{
    vec3 lightDir = vec3(1.0f, 1.0f, 0.0f);

    vec3 col = vec3(0.0f, 0.9f, 0.75f);
    vec4 tex = texture(aqua_tex, vTexCoords);

    float kd = max(dot(vNormal, lightDir), 0.0);

    vec3 snow = vec3(0.8f, 0.8f, 0.8f);
    vec3 sand = vec3(0.6f, 0.6f, 0.3f);
    vec3 aqua = vec3(0.0f, 0.7f, 0.9f);
    vec3 rock = vec3(0.4f, 0.41f, 0.4f);
    vec3 tree = vec3(0.15f, 0.3f, 0.17f);
    if (vFragPosition.y <= 0){ // aqua
        col = aqua;
        tex = texture(aqua_tex, vTexCoords);
    }else if (vFragPosition.y <= 2){ // sand
        col = smooth_color(0, aqua, sand);
        tex = smooth_tex(0, aqua_tex, sand_tex);
    }else if (vFragPosition.y <= 15){ // tree
        col = smooth_color(2.0f, sand, tree);
        tex = smooth_tex(2.0f, sand_tex, rock_tex);
    }else if (vFragPosition.y <= 25){ // rock
        col = smooth_color(15.0f, tree, rock);
        tex = texture(rock_tex, vTexCoords);        
    }else{ // snow
        col = smooth_color(25.0f, rock, snow);
        tex = smooth_tex(25.0f, rock_tex, snow_tex);            
    }

    if (mode == 1)
        color = mix(tex, vec4(kd * col, 1.0), 0.3); // tex + color
    else if (mode == 2)
        color =  vec4(abs(vNormal), 1.0f); // normals
    else 
        color = vec4(kd * col, 1.0); // color
}