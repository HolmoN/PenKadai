public interface IResultVisualizable
{
  //画面がクリックされたことを返す
  public IObservable<Unit> Clicked();
  //表示がtrueになったかどうかを返す
  public IObservable<Unit> Displaied();
  
  //setupと同じ
  public void init();
  //drawと同じ
  public void tick();
  //mousePressedと同じ
  public void onMousePressed();
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable);
  
  //クリアタイムがString型で渡される
  public void ReceiveClearTime(String time);
}
