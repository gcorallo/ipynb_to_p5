import java.net.ServerSocket;
import java.net.Socket;

import java.io.IOException;
import java.sql.SQLException;
import java.net.SocketTimeoutException;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.nio.charset.StandardCharsets;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.DataOutputStream; 
import java.io.BufferedOutputStream;

import javax.imageio.stream.ImageInputStream;


PImage pimage;
PGraphics pg;
Thread t;
boolean processed = false;
PShader sh;
void setup() {

  size(960, 540, P2D);
  pg = createGraphics(2500, 2500, P2D);
  sh = loadShader("sh.glsl");
  try {
    init();
  }  
  catch(Exception e) {
    println("exp");
  }
}


void draw() {
  background(127);
  if (pimage != null) {
    if (!processed) {
      //pg = createGraphics(pimage.width, pimage.height, P2D);
      pg.beginDraw();
      pg.image(pimage, 0, 0);
      pg.shader(sh);
      pg.endDraw();

      pimage = pg.copy();
      processed = true;
    }
    
   
  }
  image(pg,0,0,500,500);
}

void init() throws IOException, SQLException, ClassNotFoundException, Exception {
  t  = new SockServer(7777);
  t.start();

  println("thread ok");
}



private static String convertInputStreamToString(InputStream inputStream) 
  throws IOException {
  println("calls function");  
  ByteArrayOutputStream result = new ByteArrayOutputStream();
  byte[] buffer = new byte[1024];
  int length1=inputStream.read(buffer);
  //println("length: "+length1);
  if (length1>-1) {
    //while ((length1 = inputStream.read(buffer)) != -1) {
    println(length1, buffer);
    result.write(buffer, 0, length1);
    //}
    //println("result"+ result.toString(StandardCharsets.UTF_8.name()));
    return result.toString(StandardCharsets.UTF_8.name());
  } else {
    return "";
  }
}
