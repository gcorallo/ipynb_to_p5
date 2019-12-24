import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.sql.SQLException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import java.awt.image.BufferedImage;
import java.io.DataOutputStream; 
import java.io.BufferedOutputStream;


class GreetingServer extends Thread
{
  boolean nextIsImage = false;
  boolean first = true;
  private ServerSocket serverSocket;
  Socket server;
  int count=-1;
  boolean notConnectedYet = true;
  public GreetingServer(int port) throws IOException, SQLException, ClassNotFoundException, Exception
  {
    serverSocket = new ServerSocket(port);
    serverSocket.setSoTimeout(10000);
  }

  public void run()
  {
    while (true)

    { 
      count++;
      println("try: "+count);
      try
      { 
        if (processed) {
          println("should send img back now!!!");
          sendImg(pimage);
        }

        println("inner try: "+count);

        if (notConnectedYet) {
          server = serverSocket.accept();
          if (server.isConnected()) {
            notConnectedYet = false;
          }
        }
        else{
          delay(1);
        }
        println("!!!");
        println("sa"+server.getLocalPort()    );
        println("afteraccept" );



        //println("is_ "+is);
        if (!nextIsImage) { 
          InputStream is = server.getInputStream();
          
          String ss = convertInputStreamToString(is);
          //println(":"+ss);

          if (ss.contains("SIZE")) {
            nextIsImage = true;
            println("next is Image to true");

            //Send got size
            sendMsg("GOT SIZE");


            //server.close();
          } else {
            println("other messages");
          }
        } 
        if (nextIsImage==true) { //nextisImage == true !!!

          println("reads image");
          InputStream im = server.getInputStream();
          println(im);
          //BufferedImage img=ImageIO.read(ImageIO.createImageInputStream(server.getInputStream()));
          BufferedImage img=ImageIO.read(ImageIO.createImageInputStream(im));
          println(img);
          println("reads image2");
          pimage = new PImage(img);
        }


        //BufferedImage img=ImageIO.read(ImageIO.createImageInputStream(server.getInputStream()));
        //println(img);
        //println(img.getHeight());
        //JFrame frame = new JFrame();
        //frame.getContentPane().add(new JLabel(new ImageIcon(img)));
        //frame.pack();
        //frame.setVisible(true);
        //println(img.getHeight());
        //server.close();
      }
      catch(SocketTimeoutException st)
      {
        System.out.println("Socket timed out!");
        //break;
      }
      catch(IOException e)
      {
        e.printStackTrace();
        //break;
      }
      catch(Exception ex)
      {
        System.out.println(ex);
      }
    }
  }

  public void sendMsg(String msg) throws IOException {
    // need host and port, we want to connect to the ServerSocket at port 7777
    //Socket socket = new Socket("localhost", 7777);
    //System.out.println("Connected!");

    // get the output stream from the socket.
    OutputStream outputStream = server.getOutputStream();
    // create a data output stream from the output stream so we can send data through it
    DataOutputStream dataOutputStream = new DataOutputStream(outputStream);

    System.out.println("Sending string to the ServerSocket");

    // write the message we want to send

    dataOutputStream.writeUTF(msg);



    //dataOutputStream.writeChars(msg);

    dataOutputStream.flush(); // send the message
    //dataOutputStream.close(); // close the output stream when we're done.

    //System.out.println("Closing socket and terminating program.");
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
      imgSend = true;
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    byte[] packet = baStream.toByteArray();

    dataOutputStream.write(packet); 
    dataOutputStream.flush();
  }
}
