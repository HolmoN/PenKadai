StrongboxSceneVisualizer_red strongbox = new StrongboxSceneVisualizer_red();

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
