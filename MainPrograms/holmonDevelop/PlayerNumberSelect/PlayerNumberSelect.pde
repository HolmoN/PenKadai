IPlayerNumberSelectVisualizable view = new PlayerNumberSelectVisualizer();

void setup()
{
  size(800, 800);
  view.Display(true);
  view.init();
}

void draw()
{
  view.tick();
}

void mousePressed()
{
  view.onMousePressed();
}
