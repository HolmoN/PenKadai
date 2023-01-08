HoleSceneVisualizer hoge = new HoleSceneVisualizer();

void setup()
{
  size(800, 800);
  hoge.init();
}

void draw()
{
  hoge.tick();
}
