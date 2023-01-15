NetworkConnect nw = new NetworkConnect();

import processing.net.*;
Server myServer ;//= new Server( this, 12345 );
Client myClient = new Client( this, "127.0.0.1", 12345 );

void setup(){
  nw.IsServer(false);
  size(300,300);
}

void draw(){
  
}

void mousePressed(){
  nw.Send(true); 
}

void stop(){
 // myServer.stop();
  myClient.stop();
}
