//穴のシーンを実装するためのインターフェース
interface ITitleSceneVisualizable
{
  //一人プレイのボタンが押されたかどうかのイベントを返す
  public IObservable<Unit> PushedSoloPlay();
  //二人プレイのボタンが押されたかどうかのイベントを返す
  public IObservable<Unit> PushedMultiPlay();
  
  //setupと同じ
  public void init();
  //drawと同じ
  public void tick();
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable);
}
