StrongboxSceneVisualizer_blue sb = new StrongboxSceneVisualizer_blue();

void setup(){
  size(800,800);
  sb.init();
}

void draw(){
  sb.tick();
  sb.Display(true); 
}

void mousePressed(){
  sb.onMousePressed();
}
