TitleSceneVisualizable title = new TitleSceneVisualizable();

void setup(){
  size(800,800);
  title.init();
}

void draw(){
  title.tick();
}
