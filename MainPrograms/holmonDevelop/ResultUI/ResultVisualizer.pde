public class ResultVisualizer implements IResultVisualizable
{
  private Subject<Unit> clicked = new Subject<Unit>();
  private Subject<Unit> _displaied = new Subject<Unit>();
  
  private String resultTime = "0:00:00";
  private Boolean display = false;
  private RectButton bt;
  
  //画面がクリックされたことを返す
  public IObservable<Unit> Clicked()
  {
    return clicked;
  }
  public IObservable<Unit> Displaied()
  {
    return _displaied;
  }
  
  //setupと同じ
  public void init()
  {
    bt = new RectButton(0, 0, 800, 800);
  }
  //drawと同じ
  public void tick()
  {
    if(!display) return;
    
    fill(0);
    textSize(150);
    text("CLEAR!!!", 100, 300);
    fill(255, 0, 0);
    textSize(60);
    text("resultTime " + resultTime, 100, 500);
  }
  //mousePressedと同じ
  public void onMousePressed()
  {
    if(!display) return;
    
    if(bt.OnClicked())
    {
      clicked.OnNext(Unit.def);
      println("clicked");
    }
  }
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable)
  {
    display = enable;
    if(display) _displaied.OnNext(Unit.def);
  }
  
  //クリアタイムがString型で渡される
  public void ReceiveClearTime(String time)
  {
    resultTime = time;
  }
}
