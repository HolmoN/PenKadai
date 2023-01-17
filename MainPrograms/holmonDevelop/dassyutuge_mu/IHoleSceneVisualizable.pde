//穴のシーンを実装するためのインターフェース
interface IHoleSceneVisualizable
{
  //別のシーンに切り替え可能かどうかを知らせるイベントを返す
  //切り替え可能かどうかが値として返される
  public IObservable<Boolean> SceneSwitchable();
  //鍵を手に入れたかどうかのイベントを返す
  public IObservable<Unit> GetKey();
  //表示がtrueになったかどうかを返す
  public IObservable<Unit> Displaied();
  
  //setupと同じ
  public void init();
  //drawと同じ
  public void tick();
  //mousePressedと同じ
  public void onMousePressed();
  //モジュールの値が入った参照型オブジェクトが渡される
  public void ReceiveModuleValue(ModuleContainer container);
  
  //trueを入れると最初の画面が表示される
  //falseを入れると、どんな状態であっても表示が消える
  public void Display(Boolean enable);
}
