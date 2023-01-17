public class ResultVisualizer implements IResultVisualizable
{
  private Subject<Unit> clicked = new Subject<Unit>();
  private Subject<Unit> _displaied = new Subject<Unit>();
  
  private String resultTime = "0:00:00";
  private Boolean display = false;
  CircleButton circleButton;
  
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
    PFont font = createFont("Meiryo", 34);
    textFont(font);
    circleButton = new CircleButton(50, 50, 40); //戻るボタン
  }
  //drawと同じ
  public void tick()
  {
    if(!display) return;
    
    textAlign(LEFT, CENTER);
    fill(0);
    textSize(150);
    text("CLEAR!!!", 100, 300);
    fill(255, 0, 0);
    textSize(60);
    text("resultTime " + resultTime, 100, 500);
    
    fill(0, 255, 0);
    circleButton.ReDraw();
    fill(0);
    textSize(15);
    textAlign(CENTER, CENTER);
    text("タイトルへ", 50, 50);
  }
  //mousePressedと同じ
  public void onMousePressed()
  {
    if(!display) return;
    
    if(circleButton.OnClicked())
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
