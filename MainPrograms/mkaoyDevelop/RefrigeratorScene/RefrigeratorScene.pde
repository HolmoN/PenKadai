RefrigeratorSceneVisualizer rs = new RefrigeratorSceneVisualizer();

void setup(){
  size(800,800);
  rs.init();
}
boolean E=true;
void draw(){
  rs.tick();
  rs.Display(E);
}
int c=0;
void mousePressed(){
  rs.onMousePressed();
  println( rs.nomalflag );
  c++;
  if(c%5==0)
  E = !E;
}
