RefrigeratorSceneVisualizer rs = new RefrigeratorSceneVisualizer();

void setup(){
  size(800,800);
  rs.init();
}

void draw(){
  rs.tick();
  rs.Display(true);
}

void mousePressed(){
  rs.onMousePressed();
}
