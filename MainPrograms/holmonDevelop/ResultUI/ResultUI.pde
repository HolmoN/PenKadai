IResultVisualizable view = new ResultVisualizer();

void setup()
{
  size(800, 800);
  
  view.init();
  view.Display(true);
}

void draw()
{
  view.tick();
}

void mousePressed()
{
  view.onMousePressed();
}
