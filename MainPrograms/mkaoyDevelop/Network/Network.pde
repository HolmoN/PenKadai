NetworkConnect nw = new NetworkConnect();

void setup(){
  nw.IsServer(false);
  size(300,300);
}

void draw(){
  
}

void mousePressed(){
  nw.Send(true); 
}

void stop()
{
  nw.Stop();
}
