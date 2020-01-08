class SockServer extends Thread
{

  ServerSocket serverSocket;
  Socket server;

  boolean notConnectedYet = true;
  boolean readyToSend = false;
  boolean nextIsImage=false;
  int count = 0;
  public SockServer(int port) throws IOException, SQLException, ClassNotFoundException, Exception
  {
    serverSocket = new ServerSocket(port);
    serverSocket.setSoTimeout(0);
  }

  public void run()
  {
    while (true) {
      count++;
      println("try: "+count);
      try
      { 

        if (processed) {
          println("should send img back now!!!");
          
          if(readyToSend){
            sendImg(pimage);
            readyToSend=false;
          }
        } 

        if (notConnectedYet) {
          server = serverSocket.accept();
          if (server.isConnected()) {
            notConnectedYet = false;
            println("connected");
          }
        } else { //connected!

          InputStream is = server.getInputStream();
          if (!nextIsImage) { //parses text msg

            //println("av txt"+is.available());
            String ss = convertInputStreamToString(is);
            if (ss.contains("SIZE")) {
              println("size received");
              sendMsg("SIZERCVD");
              nextIsImage = true;
            } else if(ss.contains("READY")){
              readyToSend = true;
            
            }else {
              println("other msgs...");
            }
          } else { //receive image

            println("reads image");





            println("img av"+is.available());
            if (is.available()> 0) {
              println("av >0");

              //BufferedImage img=ImageIO.read(ImageIO.createImageInputStream(server.getInputStream()));
              ImageInputStream iis = ImageIO.createImageInputStream(is);
              print("iis:" +iis);
              BufferedImage img= ImageIO.read(iis);

              println("img:"+img);
              println("reads image2");
              pimage = new PImage(img);

              nextIsImage = false;
              sendMsg("IMGRCVD");
              
              //delay(500);
              processed = false;
            }
          }

          println("ends connected st");
        }
      }
      catch(SocketTimeoutException st)
      {
        System.out.println("Socket timed out!");
        //break;
      }



      catch(IOException e)
      {
        e.printStackTrace();
      }
      catch(Exception ex)
      {
        System.out.println(ex);
      }
    }
  }

  public void sendMsg(String msg) throws IOException {

    println("sending:" + msg);
    OutputStream outputStream = server.getOutputStream();

    DataOutputStream dataOutputStream = new DataOutputStream(outputStream);

    System.out.println("Sending string to the ServerSocket");

    dataOutputStream.writeUTF(msg);

    dataOutputStream.flush();
  }



  public void sendImg (PImage img_) throws IOException {
    println("sendImg!");

    OutputStream outputStream = server.getOutputStream();
    DataOutputStream dataOutputStream = new DataOutputStream(outputStream);



    BufferedImage bimg = new BufferedImage( img_.width, img_.height, 
      BufferedImage.TYPE_INT_RGB );    
    img_.loadPixels();
    bimg.setRGB( 0, 0, img_.width, img_.height, img_.pixels, 0, img_.width);
    ByteArrayOutputStream baStream    = new ByteArrayOutputStream();
    BufferedOutputStream bos      = new BufferedOutputStream(baStream);
    try {
      ImageIO.write(bimg, "jpg", bos);
      nextIsImage = false;
      processed = false;
      pimage = null;
      //imgSend = true;
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    byte[] packet = baStream.toByteArray();

    dataOutputStream.write(packet); 
    dataOutputStream.flush();
  }
}
