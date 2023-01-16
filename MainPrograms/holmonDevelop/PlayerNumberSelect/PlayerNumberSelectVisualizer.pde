public class PlayerNumberSelectVisualizer implements IPlayerNumberSelectVisualizable
{
  private Subject<Unit> _pushedRed = new Subject<Unit>();
  private Subject<Unit> _pushedBlue = new Subject<Unit>();
  private Subject<Unit> _pushedBack= new Subject<Unit>();
  
  RectButton rectbutton1; //赤
  RectButton rectbutton2; //青
  CircleButton backbutton;
  
  Boolean _display = false;
  
  public IObservable<Unit> PushedRed()
  {
    return _pushedRed;
  }
  public IObservable<Unit> PushedBlue()
  {
    return _pushedBlue;
  }
  public IObservable<Unit> PushedBack()
  {
    return _pushedBack;
  }
  
  //setupと同じ
  public void init()
  {
    fill(0);
    PFont font = createFont("Meiryo", 50);
    textFont(font);
    
    rectbutton1 = new RectButton(80, 400, 240, 130);
    rectbutton2 = new RectButton(480, 400, 240, 130);
    backbutton = new CircleButton(50, 50, 40);
  }
  //drawと同じ
  public void tick()
  {
    if(!_display) return;
    
    background(255);
    
    //テキストの描写
    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("一人が赤、もう一人が\n青を選択してください", 400, 250);
    
    //赤ボタンの表示
    if( rectbutton1.OnClicked()) strokeWeight(8);
    else strokeWeight(3);
    fill(255, 0, 0);
    rectbutton1.ReDraw();
    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("赤", 80+(240/2), 400+(130/2)); 
    
    //青ボタンの表示
    if( rectbutton2.OnClicked()) strokeWeight(8);
    else strokeWeight(3);
    fill(0, 0, 255);
    rectbutton2.ReDraw();
    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("青", 480+(240/2), 400+(130/2));
    
    //戻るボタンの描写
    strokeWeight(3);
    fill(0, 255, 0);
    backbutton.ReDraw();
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("戻る", 50, 50);    
  }
  //mousePressedと同じ
  public void onMousePressed()
  {
    if(!_display) return;

    if( rectbutton1.OnClicked() )  //赤がクリックされた
    {
      _pushedRed.OnNext(Unit.def);
      println("赤");
    }
    if( rectbutton2.OnClicked() )  //青がクリックされた
    {
      _pushedBlue.OnNext(Unit.def);
      println("青");
    }
    if(backbutton.OnClicked())
    {
      _pushedBack.OnNext(Unit.def);
      println("もどる");
    }
  }
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable)
  {
    _display = enable;
  }
}
