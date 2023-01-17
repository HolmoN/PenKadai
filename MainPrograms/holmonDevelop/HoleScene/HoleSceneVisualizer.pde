public enum eHoleSceneView
{
  room, 
  hole
}

public class HoleSceneVisualizer implements IHoleSceneVisualizable
{
  private float sensorLower = 400; //センサー値下限
  private float sensorHigher = 1000; //センサー値上限
  private float sensorConfirmLower = 500; //センサー評価値下限
  private float sensorConfirmHigher = 600; //センサー評価値上限
  
  private Subject<Boolean> _sceneSwitchable = new Subject<Boolean>();
  private Subject<Unit> _getKey = new Subject<Unit>();  private Subject<eHoleSceneView> _changedView = new Subject<eHoleSceneView>(); //eHoleSceneViewに変更があった時に呼ばれる
  private Subject<Unit> _displaied = new Subject<Unit>();
  
  private PImage _room, _hole, _keyIm;
  
  private CircleButton _holeClickSpace; //穴のクリック部分
  private CircleButton _returnButton; //戻るボタン
  private RectButton rectButton_yes, rectButton_no;
  private WindowObject _window; //ガイド表示
  
  private ModuleContainer _moduleContainer = new ModuleContainer();
  private eHoleSceneView _view; //今表示している画面 変数を直接変えてはいけない！
  
  private Boolean _display = false;
  private Boolean _gotKey = false; //keyをすでに入手しているか
  private Boolean _grabKey = false; //keyをつかんでいるか
  private Boolean _dispWindow = false;
  
  public IObservable<Boolean> SceneSwitchable()
  {
    return _sceneSwitchable;
  }
  public IObservable<Unit> GetKey()
  {
    return _getKey;
  }
  
  IObservable<Unit> Displaied()
  {
    return _displaied;
  }
  
  public void init()
  {
    _room = loadImage("通常場面 穴.png");
    _hole = loadImage("穴注目.png");
    _keyIm = loadImage("赤の鍵 透過.png");
    
    _holeClickSpace = new CircleButton(390, 350, 60);
    _returnButton = new CircleButton(50, 50, 40); 
    rectButton_yes = new RectButton(80, 200, 240, 130);   //「はい」ボタン
    rectButton_no = new RectButton(480, 200, 240, 130);    //「いいえ」ボタン
    _window = new WindowObject();
  }
  
  public void tick()
  {
    if(!_display) return;
    
    background(255);
    PFont font = createFont("Meiryo", 34);
    textFont(font);
    
    //部屋のシーンの描写
    if(_view == eHoleSceneView.room)
    {
      image(_room, 0, 0);
      
      if(_gotKey)
      {
        _window.SetText("赤い鍵を手に入れた");
        if(_dispWindow)
        {
          _window.ReDraw();
          image(_keyIm, 0, 0);
        }
      }
    }
    //穴のシーンの描写
    if(_view == eHoleSceneView.hole)
    {
      image(_hole, 0, 0);
      //戻るボタン描写
      fill(0, 255, 0);
      _returnButton.ReDraw();
      fill(0); textSize(20); textAlign(CENTER,CENTER);
      text("戻る", 50, 50);
      
      //センサー処理
      if(!_gotKey)
      {
        float sensorVal = constrain(_moduleContainer.DistanceValue, sensorLower, sensorHigher);
        //float sensorVal = 550;
        float ratio = (sensorVal - sensorLower) / (sensorHigher - sensorLower);
        
        strokeWeight(5);
        fill(255);
        rect(650, 60, 70, 400);
        fill(255, 0, 0);
        rect(655, 65, 60, 390 * ratio);
        
        if(_grabKey) //鍵をつかんでいる
        {
          _window.SetText("ボタンがあった\n押しますか？");
          fill(255, 0, 0);
          rectButton_yes.ReDraw();    //「はい」ボタン
          fill(0);
          textAlign(CENTER, CENTER);
          text("はい", 80+(240/2), 200+(130/2));
          fill(0, 0, 255);
          rectButton_no.ReDraw();    //「いいえ」ボタン
          fill(0);
          textAlign(CENTER, CENTER);
          text("いいえ", 480+(240/2), 200+(130/2));
        }
        else
        {
          //キーを入手するセンサーの値になった
          if(sensorConfirmLower < sensorVal && sensorVal < sensorConfirmHigher) _grabKey = true;
          else if(sensorConfirmLower < sensorVal) _window.SetText("もうすこし手前に\n何かありそうだ");
          else _window.SetText("もうすこし奥に\n何かありそうだ");
        }
        _window.ReDraw();
      }
    }
  }
  public void onMousePressed()
  {
    if(!_display) return;
    
    //部屋のシーンの処理
    if(_view == eHoleSceneView.room)
    {
      if(_holeClickSpace.OnClicked()) HoleSceneViewChange(eHoleSceneView.hole);
      if(_gotKey)
      {
        if(_window.OnClicked()) _dispWindow = false;
      }
    }
    //穴シーンの処理
    if(_view == eHoleSceneView.hole)
    {
      if(_returnButton.OnClicked()) HoleSceneViewChange(eHoleSceneView.room);
      
       if(!_gotKey)
       {
         if(_grabKey)
         {
           if(rectButton_yes.OnClicked())
           {
             _gotKey = true;
             _grabKey = false;
             _dispWindow = true;
             HoleSceneViewChange(eHoleSceneView.room);
             _getKey.OnNext(Unit.def);
           }
           if(rectButton_no.OnClicked())
           {
             _grabKey = false;
             HoleSceneViewChange(eHoleSceneView.room);
           }
         }
       }
    }
  }
  
  public void ReceiveModuleValue(ModuleContainer container)
  {
    _moduleContainer = container;
  }
  
  public void Display(Boolean enable)
  {
    _display = enable;
    if(_display)_displaied.OnNext(Unit.def);
    if(enable) HoleSceneViewChange(eHoleSceneView.room);
  }
  
  //表示するviewを切り替える
  private void HoleSceneViewChange(eHoleSceneView view)
  {
    _view = view;
    
    if(_view == eHoleSceneView.room) _sceneSwitchable.OnNext(true);
    if(_view == eHoleSceneView.hole) _sceneSwitchable.OnNext(false);
  }
}
