public class SceneSwitcherVisualizer implements ISceneSwitcherVisualizable
{
  private Subject<eArrowDirection> pushedArrow = new Subject<eArrowDirection>();
  
  private RectButton left;
  private RectButton right;
  private boolean display = false;
  
  //別のシーンへの切り替えボタンが押されたかどうかを返す
  //fで左、tで右
  public IObservable<eArrowDirection> PushedArrow()
  {
    return pushedArrow;
  }
  
  //setupと同じ
  public void init()
  {
    left = new RectButton(50, 300, 50, 200);
    right = new RectButton(700, 300, 50, 200);
  }
  //drawと同じ
  public void tick()
  {
    if(!display) return;
    
    noStroke();
    fill(255, 0, 0, 0);
    left.ReDraw();
    right.ReDraw();
    
    stroke(0, 0, 0);
    strokeWeight(1);
    fill(255, 255, 0);
    triangle(50, 400, 100, 300, 100, 500);
    triangle(750, 400, 700, 300, 700, 500);
  }
  //mousePressedと同じ
  public void onMousePressed()
  {
    if(!display) return;
    
    if(left.OnClicked())
    {
      pushedArrow.OnNext(eArrowDirection.Left);
      println("l");
    }
    if(right.OnClicked())
    {
      pushedArrow.OnNext(eArrowDirection.Right);
      println("r");
    }
  }
  
  //trueを入れると表示される
  public void Display(Boolean enable)
  {
    display = enable;
  }
}
