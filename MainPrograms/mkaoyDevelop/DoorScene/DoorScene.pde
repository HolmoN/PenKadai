DoorSceneVisualizer door = new DoorSceneVisualizer();

void setup(){
  size(800,800);
  door.init();
}
boolean E=false, ES=true;
void draw(){
  //door.tick();
  door.Display(ES);
  door.Escapable(E);
}
int c=0;
void mousePressed(){
  door.onMousePressed();
  c++;
  if(c>10){
    E=true;
  }
  if(c==5){
    ES=false;
  }
  if(c==8){
    ES=true;
  }
}
