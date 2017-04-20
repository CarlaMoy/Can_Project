#version 420

// The vertex position attribute
layout (location=0) in vec3 VertexPosition;

// The texture coordinate attribute
layout (location=1) in vec2 TexCoord;

// The vertex normal attribute
layout (location=2) in vec3 VertexNormal;

// These attributes are passed onto the shader (should they all be smoothed?)
smooth out vec3 FragmentPosition;
smooth out vec3 FragmentNormal;
smooth out vec2 FragmentTexCoord;
smooth out vec4 ShadowCoord;
smooth out vec4  Colour;

uniform mat4 MV;            // model view matrix calculated in the App
uniform mat4 MVP;           // model view projection calculated in the app
uniform mat3 N;             // normal matrix calculated in the app
uniform mat4 textureMatrix;
uniform vec3 LightPosition;
uniform  vec4 inColour;

//out vec4  ShadowCoord;




void main() {
    // Transform the vertex normal by the inverse transpose modelview matrix
    FragmentNormal = normalize(N * VertexNormal);

    // Compute the unprojected vertex position
  //  FragmentPosition = vec3(MV * vec4(VertexPosition, 1.0) );
    vec4 ecPosition = MV * vec4(VertexPosition, 1.0);
    vec3 ecPosition3 = (vec3(ecPosition)) / ecPosition.w;

    vec3 VP = LightPosition - ecPosition3;
    VP = normalize(VP);

    vec3 normal = normalize(N * VertexNormal);
    float diffuse = max(0.0, dot(normal, VP));

    //textureMatrix converts from modelling coordinates to shadow map coordinates
    ShadowCoord = textureMatrix * vec4(VertexPosition,1.0);

    // Copy across the texture coordinates
    FragmentTexCoord = TexCoord;

    Colour  = vec4(diffuse * inColour.rgb, inColour.a);

    // Compute the position of the vertex
    gl_Position = MVP * vec4(VertexPosition,1.0);
}







/// modified from the OpenGL Shading Language Example "Orange Book"
/// Roost 2002







/*void main()
{
	vec4 ecPosition = MV * inVert;
	vec3 ecPosition3 = (vec3(ecPosition)) / ecPosition.w;
	vec3 VP = LightPosition - ecPosition3;
	VP = normalize(VP);
	vec3 normal = normalize(normalMatrix * inNormal);
	float diffuse = max(0.0, dot(normal, VP));
	vec4 texCoord = textureMatrix * inVert;
	ShadowCoord   = texCoord;
	Colour  = vec4(diffuse * inColour.rgb, inColour.a);
  gl_Position    = MVP * inVert;
}*/

