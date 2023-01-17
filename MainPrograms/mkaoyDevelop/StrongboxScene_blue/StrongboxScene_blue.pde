StrongboxSceneVisualizer_blue sb = new StrongboxSceneVisualizer_blue();

void setup(){
  size(800,800);
  sb.init();
  sb.Display(true); 
}

void draw(){
  sb.tick();
}

void mousePressed(){
  sb.onMousePressed();
}
