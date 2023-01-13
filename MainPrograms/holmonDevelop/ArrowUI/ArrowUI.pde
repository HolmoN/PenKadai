ISceneSwitcherVisualizable view = new SceneSwitcherVisualizer();

void setup()
{
  size(800, 800);
  view.init();
  
  view.Display(true);
}

void draw()
{
  background(255);
  view.tick();
}

void mousePressed()
{
  view.onMousePressed();
}
