class HoleSceneVisualizer implements IHoleSceneVisualizable
{
  Subject<Boolean> sceneSwitchable = new Subject();
  Subject<Unit> getKey = new Subject();
  
  ModuleContainer hoge;
  
  
 //別のシーンに切り替え可能かどうかを知らせるイベントを返す
  //切り替え可能かどうかが値として返される
  public IObservable<Boolean> SceneSwitchable()
  {
    return sceneSwitchable;
  }
  //鍵を手に入れたかどうかのイベントを返す
  public IObservable<Unit> GetKey()
  {
    return getKey;
  }
  
  int i;
  
  //setupと同じ
  public void init()
  {
    
  }
  //drawと同じ
  public void tick()
  {
    background(255);
    
    fill(0);
    ellipse(50, 50, 80, 80);
  }
  //モジュールの値が入った参照型オブジェクトが渡される
  public void ReceiveModuleValue(ModuleContainer container)
  {
    hoge = container;
  }
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable)
  {
  
  }
  
  void KagiwoTeniireta()
  {
    sceneSwitchable.OnNext(false);
    getKey.OnNext(Unit.def);
    
    int i = hoge.DistanceValue;
  }
  
  void mousePressed()
  {
    println("hoge");
  }
}
