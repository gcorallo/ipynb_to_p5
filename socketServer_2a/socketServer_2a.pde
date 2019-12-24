//https://stackoverflow.com/questions/25086868/how-to-send-images-through-sockets-in-java
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import org.apache.commons.io.IOUtils;
PImage pimage;
Thread t;
boolean processed = false;
boolean imgSend = false;
void setup() {
  size(960, 540);
  try {
    init();
  }  
  catch(Exception e) {
    println("exp");
  }
}

void draw() {

  if (pimage != null) {
    image(pimage, 0, 0);
    if (!processed) {
      pimage.loadPixels();
      for (int i=0; i<pimage.pixels.length; i++) {
        color c = pimage.pixels[i];
        if (i<30000) {
          pimage.pixels[i] = color(red(c)*.85, green(c)*.85, blue(c)*.85);
        }
      }
      processed = true;
      pimage.updatePixels();
    }
  }
}

void init() throws IOException, SQLException, ClassNotFoundException, Exception {
  t  = new GreetingServer(6666);
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
  }
  else{
    return "";
  }
}
