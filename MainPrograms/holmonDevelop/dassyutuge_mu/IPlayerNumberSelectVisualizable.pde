//マルチプレイの時、赤か青どちらを選択するかを表示する
interface IPlayerNumberSelectVisualizable
{
  public IObservable<Unit> PushedRed();
  public IObservable<Unit> PushedBlue();
  public IObservable<Unit> PushedBack();
  
  //setupと同じ
  public void init();
  //drawと同じ
  public void tick();
  //mousePressedと同じ
  public void onMousePressed();
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable);
}
