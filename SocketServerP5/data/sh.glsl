#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
  

  vec2 tc0 = vertTexCoord.st + vec2(0, 0);
  if(vertTexCoord.x>0.5){

    tc0 = vec2(0.,0.);

  }
  else{

    tc0 += vec2( (0,.5-vertTexCoord.x)*.01,0);

  }

  vec4 sum = texture2D(texture, tc0);

  float v = (sum.r+sum.g+sum.b)/3.0;

  vec3 vv = vec3(v,v,v);
  if(vertTexCoord.x>0.5){

    sum = vec4(1.,0.,0.,1.);

  }
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}
