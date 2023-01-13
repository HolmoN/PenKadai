public enum eArrowDirection
{
  Right,
  Left
}

//扉のシーンを実装するためのインターフェース
interface ISceneSwitcherVisualizable
{
  //別のシーンへの切り替えボタンが押されたかどうかを返す
  //fで左、tで右
  public IObservable<eArrowDirection> PushedArrow();
  
  //setupと同じ
  public void init();
  //drawと同じ
  public void tick();
  //mousePressedと同じ
  public void onMousePressed();
  
  //trueを入れると表示される
  public void Display(Boolean enable);
}
