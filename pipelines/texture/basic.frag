#version 410 core

in  vec2 vTexCoords;
out vec4 fragColor;

uniform sampler2D sampler1;

void main()
{

	vec2 flippedTexCoords = vec2(1 - vTexCoords.x, 1 - vTexCoords.y);
	vec3 color = texture(sampler1,flippedTexCoords).rgb;
	

	fragColor = vec4(color, 1.0);
}
