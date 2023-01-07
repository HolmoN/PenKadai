//扉のシーンを実装するためのインターフェース
interface IDoorSceneVisualizable
{
  //別のシーンに切り替え可能かどうかを知らせるイベントを返す
  //切り替え可能かどうかが値として返される
  public IObservable<Boolean> SceneSwitchable();
  //脱出したかどうかを知らせるイベントを返す
  public IObservable<Unit> Escaped();
  
  //setupと同じ
  public void init();
  //drawと同じ
  public void tick();
  //モジュールの値が入った参照型オブジェクトが渡される
  public void ReceiveModuleValue(ModuleContainer container);
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable);
  
  //脱出可能なフラグがたっているかどうか渡される
  public void Escapable(Boolean enable);
}
