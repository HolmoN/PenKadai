class TitleSceneVisualizable implements ITitleSceneVisualizable
{
  Subject<Unit> PushedSoloPlay = new Subject<Unit>();
  Subject<Unit> PushedMultiPlay = new Subject<Unit>();
  
  public IObservable<Unit> PushedSoloPlay()
  {
    return PushedSoloPlay;
  }
  public IObservable<Unit> PushedMultiPlay()
  {
    return PushedMultiPlay;
  }
  
  Boolean _display = false;
  
  int w=800;
  int h=800;  //画面サイズ
  int Buttonw=500;  //四角いボタンの横幅
  int Buttonh=130;  //四角いボタンの縦幅
  
  RectButton rectbutton1;
  RectButton rectbutton2;
  
  PImage img;  //タイトル画像
  
  public void init()   //setup
  {
    fill(0);
    PFont font = createFont("Meiryo", 50);
    textFont(font);
    textAlign(CENTER,CENTER);
    
    img = loadImage("gametitle.png");  //タイトル画像
    
    rectbutton1 = new RectButton(w/2-(Buttonw/2),h*1.1/2-(Buttonh/2),Buttonw,Buttonh);
    rectbutton2 = new RectButton(w/2-(Buttonw/2),h*3/4-(Buttonh/2),Buttonw,Buttonh);
  }
  public void tick()   //draw
  {
    if(!_display) return;
    
    background(255);
    image(img, 0, 0);   //タイトル
    
    if( rectbutton1.OnClicked() )
    {
      strokeWeight(8);
    }
    else
    {
      strokeWeight(3);
    }
    fill(255);
    rectbutton1.ReDraw();   //一人プレイのボタン表示
    fill(0);
    text("一人プレイ", w/2,h*1.1/2);  
    
    if( rectbutton2.OnClicked() )
    {
      strokeWeight(8);
    }
    else
    {
      strokeWeight(3);
    }
    fill(255);
    rectbutton2.ReDraw();   //二人プレイのボタン表示
    fill(0);
    text("二人プレイ", w/2,h*3/4);  
  }
  public void onMousePressed()
  {
    if(!_display) return;
    // rectbutton1.OnClicked();
    // rectbutton2.OnClicked();
    
    if( rectbutton1.OnClicked() )  //一人プレイがクリックされた
    {
      PushedSoloPlay.OnNext(Unit.def);
      println("SoloPlay");
    }
    else if( rectbutton2.OnClicked() )  //二人プレイがクリックされた
    {
      PushedMultiPlay.OnNext(Unit.def);
      println("MultiPlay");
    }
  }
  
  public void Display(Boolean enable)
  {
    _display = enable; 
  }
  
}
