#version 330 core
in vec3 vFragPosition;
in vec2 vTexCoords;
in vec3 vNormal;

out vec4 color;

vec3 smoothing(in float border, in vec3 prev_col, in vec3 cur_col)
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

void main()
{
  vec3 lightDir = vec3(1.0f, 1.0f, 0.0f);

  vec3 col = vec3(0.0f, 0.9f, 0.75f);

  float kd = max(dot(vNormal, lightDir), 0.0);

  vec3 snow = vec3(0.8f, 0.8f, 0.8f);
  vec3 sand = vec3(0.7f, 0.7f, 0.2f);
  vec3 aqua = vec3(0.0f, 0.4f, 0.6f);
  vec3 rock = vec3(0.4f, 0.41f, 0.4f);
  vec3 tree = vec3(0.15f, 0.3f, 0.17f);
  if (vFragPosition.y <= 0){
    col = aqua;
  }else if (vFragPosition.y <= 1){
    col = sand;
    if (vFragPosition.y <= 0.3)
      col = (aqua + sand)/2;
  }else if (vFragPosition.y <= 15){
      col = smoothing(1.0f, sand, tree);
  }else if (vFragPosition.y <= 25){
    col = smoothing(15.0f, tree, rock);
  }else
    col = smoothing(25.0f, rock, snow);

  color = vec4(kd * col, 1.0f);
}