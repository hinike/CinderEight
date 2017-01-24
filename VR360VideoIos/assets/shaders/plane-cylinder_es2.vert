#version 100

uniform float		uTexOffset;
uniform sampler2D	uLeftTex;
uniform sampler2D	uRightTex;
const float two_pi = 6.2831853;
const float pi = 3.1415927;
const float tenLogBase10 = 3.0102999566398; // 10.0 / log(10.0);
uniform float uMix;

uniform float uVolume;

attribute vec2 ciTexCoord0;
attribute vec4 ciPosition;

uniform mat4 ciModelViewProjection;

varying vec2 vVertex;

void main(void)
{
    // retrieve texture coordinate and offset it to scroll the texture
    vec2 coord = ciTexCoord0.st + vec2(-0.25, uTexOffset);
    
    // retrieve the FFT from left and right texture and average it
    float fft = max(0.0001, mix( texture2D( uLeftTex, coord ).r, texture2D( uRightTex, coord ).r, 0.5));
    
    // convert to decibels
    float decibels = tenLogBase10 * log( fft );
    
    // offset the vertex based on the decibels and create a cylinder

    float r = uVolume + 0.01 * decibels;
    vec4 vertexCyl = ciPosition;

    vertexCyl.y = r * cos(ciTexCoord0.t * two_pi);
    vertexCyl.z = r * sin(ciTexCoord0.t * two_pi);

    vVertex = ciTexCoord0;
    
    gl_Position = ciModelViewProjection *  mix(vertexCyl, ciPosition, uMix);
}
