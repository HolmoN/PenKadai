StrongboxSceneVisualizer strongbox = new StrongboxSceneVisualizer();

void setup()
{
  size(800,800);
  strongbox.init();
}

void draw()
{
  strongbox.tick();
}

void mousePressed(){
  strongbox.onMousePressed();
}
