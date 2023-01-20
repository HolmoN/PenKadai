public interface IPlayModule
{
  //クリアしたことを返す
  public IObservable<Unit> Cleared();
  //ステートが変わったことを返す
  public IObservable<eSceneState> ChangeState();
  
  public IDoorSceneVisualizable Door();
  public IHoleSceneVisualizable  Hole();
  public IRefrigeratorSceneVisualizable Refrigerator();
  public IStrongboxSceneVisualizable Strongbox();
  public ISceneSwitcherVisualizable SceneSwitcher();
  
  public void DispSceneSwitcher(Boolean enable);
  
  public void Tick();
  public void Stop();
}

public class PlayModule
{
  public Subject<Unit> cleared = new Subject<Unit>();
  public Subject<eSceneState> changeState = new Subject<eSceneState>();
  
  IDoorSceneVisualizable doorSceneVisualizable; //ドア
  IHoleSceneVisualizable holeSceneVisualizable; //穴
  IRefrigeratorSceneVisualizable refrigeratorSceneVisualizable; //冷蔵庫
  IStrongboxSceneVisualizable strongboxSceneVisualizable; //金庫
  ISceneSwitcherVisualizable sceneSwitcherVisualizable; //シーン切り替えボタン
  
  public boolean[] keyFrags = new boolean[3]; //穴、冷蔵庫、金庫
  public ModuleContainer moduleContainer = new ModuleContainer();
  private int sceneNum = 0;
  
  //コンストラクタ
  public PlayModule(ModuleContainer __moduleContainer, dassyutuge_mu gam)
  {
    for(int i = 0; i < keyFrags.length; i++) keyFrags[i] = false;
    moduleContainer = __moduleContainer;
    sceneNum = 0;
    
    GenerateInstance(gam);
    Present();
    
    doorSceneVisualizable.init();
    holeSceneVisualizable.init();
    refrigeratorSceneVisualizable.init();
    strongboxSceneVisualizable.init();
    sceneSwitcherVisualizable.init();
  }
  
  //インスタンスの生成
  public void GenerateInstance(dassyutuge_mu gam)
  {
    sceneSwitcherVisualizable = new SceneSwitcherVisualizer();
  }
  //各モジュールの接続
  public void Present()
  {
    //シーン切り替えボタン
    sceneSwitcherVisualizable.PushedArrow().Subscribe(new fn<eArrowDirection>(){ public void func(eArrowDirection m)
      {
        if(m == eArrowDirection.Right) sceneNum++;
        else sceneNum--;
        if(sceneNum < 0) sceneNum = 3;
        else if(sceneNum >= 4) sceneNum = 0;
      
        eSceneState st = eSceneState.Door;
        if(sceneNum == 0) st = eSceneState.Door;
        if(sceneNum == 1) st = eSceneState.Hole;
        if(sceneNum == 2) st = eSceneState.Refrigerator;
        if(sceneNum == 3) st = eSceneState.Strongbox;
      
        changeState.OnNext(st);
        println(sceneNum);
    }});
  }
  
  public IObservable<Unit> Cleared(){ return cleared; }
  public IObservable<eSceneState> ChangeState(){ return changeState; }
  
  public IDoorSceneVisualizable Door(){ return doorSceneVisualizable; }
  public IHoleSceneVisualizable  Hole(){ return holeSceneVisualizable; }
  public IRefrigeratorSceneVisualizable Refrigerator(){ return refrigeratorSceneVisualizable; }
  public IStrongboxSceneVisualizable Strongbox(){ return strongboxSceneVisualizable; }
  public ISceneSwitcherVisualizable SceneSwitcher(){ return sceneSwitcherVisualizable; }
  
  //シーンスイッチャーの表示を切り替える
  public void DispSceneSwitcher(Boolean enable)
  {
    if(enable) sceneSwitcherVisualizable.Display(true);
    else sceneSwitcherVisualizable.Display(false);
  }
  
  public void Tick(){}
  public void Stop(){}
}

public class SinglePlayModule extends PlayModule implements IPlayModule
{
  public SinglePlayModule(ModuleContainer moduleContainer, dassyutuge_mu gam)
  {
    super(moduleContainer, gam);
  }
  
  @Override
  public void GenerateInstance(dassyutuge_mu gam)
  {
    super.GenerateInstance(gam);
    
    doorSceneVisualizable = new DoorSceneVisualizer();
    holeSceneVisualizable = new HoleSceneVisualizer();
    refrigeratorSceneVisualizable = new RefrigeratorSceneVisualizer();
    strongboxSceneVisualizable = new StrongboxSceneVisualizer();
  }
  @Override
  public void Present()
  {
    super.Present();
    
    //ドアシーン
    doorSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        doorSceneVisualizable.ReceiveModuleValue(moduleContainer);
        
        Boolean escapable = false;
        if(keyFrags[0] &&keyFrags[1] && keyFrags[2]) escapable = true;
        doorSceneVisualizable.Escapable(escapable);
      }});
    doorSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    doorSceneVisualizable.Escaped().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        cleared.OnNext(Unit.def);
      }});
  
    //穴シーン
    holeSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        holeSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    holeSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    holeSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[0] = true;
      }});
  
    //冷蔵庫シーン
    refrigeratorSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        refrigeratorSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    refrigeratorSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    refrigeratorSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[1] = true;
      }});
  
    //金庫シーン
    strongboxSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        strongboxSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    strongboxSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    strongboxSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[2] = true;
      }});
  }
}

public class RedPlayModule extends PlayModule implements IPlayModule
{
  INetworkModule networkConnectable;
  
  Boolean myKey;
  Boolean partnerKey;
  
  public RedPlayModule(ModuleContainer moduleContainer, dassyutuge_mu gam)
  {
    super(moduleContainer, gam);
    
    myKey = false;
    partnerKey = false;
  }
  
  @Override
  public void GenerateInstance(dassyutuge_mu gam)
  {
    super.GenerateInstance(gam);
    
    doorSceneVisualizable = new DoorSceneVisualizer();
    holeSceneVisualizable = new HoleSceneVisualizer();
    refrigeratorSceneVisualizable = new RefrigeratorSceneVisualizer();
    strongboxSceneVisualizable = new StrongboxSceneVisualizer_red();
    
    networkConnectable = new NetworkModule(gam, true); //<>//
  }
  @Override
  public void Present()
  {
    super.Present();
        
    //ドアシーン
    doorSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        doorSceneVisualizable.ReceiveModuleValue(moduleContainer);
        
        Boolean escapable = false;
        if(keyFrags[0] &&keyFrags[1] && keyFrags[2]) escapable = true;
        doorSceneVisualizable.Escapable(escapable);
      }});
    doorSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    doorSceneVisualizable.Escaped().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        cleared.OnNext(Unit.def);
      }});
  
    //穴シーン
    holeSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        holeSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    holeSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    holeSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[0] = true;
      }});
  
    //冷蔵庫シーン
    refrigeratorSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        refrigeratorSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    refrigeratorSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    refrigeratorSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[1] = true;
      }});
  
    //金庫シーン
    strongboxSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        strongboxSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    strongboxSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        //送信
        int wr = 0;
        if(myKey) wr = 1;
        networkConnectable.Write(str(wr));
        
        CheckFrag();
        
        DispSceneSwitcher(m);
      }});
    strongboxSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        myKey = true;
        
        //送信
        int wr = 0;
        if(myKey) wr = 1;
        networkConnectable.Write(str(wr));
        
        CheckFrag();
      }});
      
    networkConnectable.receive().Subscribe(new fn<Boolean>(){ public void func(Boolean b)
      {
        partnerKey = b;
        CheckFrag();
      }});
  }
  
  private void CheckFrag()
  {
    //フラグ確認
    if(myKey && partnerKey) keyFrags[2] = true;
  }
  
  @Override
  public void Tick()
  {
    networkConnectable.Tick();
  }
  @Override
  public void Stop()
  {
    networkConnectable.Stop();
  }
}

public class BluePlayerModule extends PlayModule implements IPlayModule
{
  INetworkModule networkConnectable;
  
  Boolean myKey;
  Boolean partnerKey;
  
  public BluePlayerModule(ModuleContainer moduleContainer, dassyutuge_mu gam)
  {
    super(moduleContainer, gam);
    
    myKey = false;
    partnerKey = false;
  }
  
  @Override
  public void GenerateInstance(dassyutuge_mu gam)
  {
    super.GenerateInstance(gam);
    
    doorSceneVisualizable = new DoorSceneVisualizer();
    holeSceneVisualizable = new HoleSceneVisualizer();
    refrigeratorSceneVisualizable = new RefrigeratorSceneVisualizer();
    strongboxSceneVisualizable = new StrongboxSceneVisualizer_blue();
    
    networkConnectable = new NetworkModule(gam, false); 
  }
  @Override
  public void Present()
  {
    super.Present();
        
    //ドアシーン
    doorSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        doorSceneVisualizable.ReceiveModuleValue(moduleContainer);
        
        Boolean escapable = false;
        if(keyFrags[0] &&keyFrags[1] && keyFrags[2]) escapable = true;
        doorSceneVisualizable.Escapable(escapable);
      }});
    doorSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    doorSceneVisualizable.Escaped().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        cleared.OnNext(Unit.def);
      }});
  
    //穴シーン
    holeSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        holeSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    holeSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    holeSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[0] = true;
      }});
  
    //冷蔵庫シーン
    refrigeratorSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        refrigeratorSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    refrigeratorSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        DispSceneSwitcher(m);
      }});
    refrigeratorSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        keyFrags[1] = true;
      }});
  
    //金庫シーン
    strongboxSceneVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        strongboxSceneVisualizable.ReceiveModuleValue(moduleContainer);
      }});
    strongboxSceneVisualizable.SceneSwitchable().Subscribe(new fn<Boolean>(){ public void func(Boolean m)
      {
        //送信
        int wr = 0;
        if(myKey) wr = 1;
        networkConnectable.Write(str(wr));
        
        CheckFrag();
        
        DispSceneSwitcher(m);
      }});
    strongboxSceneVisualizable.GetKey().Subscribe(new fn<Unit>(){ public void func(Unit m)
      {
        myKey = true;
        
        //送信
        int wr = 0;
        if(myKey) wr = 1;
        networkConnectable.Write(str(wr));
        
        CheckFrag();
      }});
      
    networkConnectable.receive().Subscribe(new fn<Boolean>(){ public void func(Boolean b)
      {
        partnerKey = b;
        CheckFrag();
      }});
  }
  
  private void CheckFrag()
  {
    //フラグ確認
    if(myKey && partnerKey) keyFrags[2] = true;
  }
  
  @Override
  public void Tick()
  {
    networkConnectable.Tick();
  }
  @Override
  public void Stop()
  {
    networkConnectable.Stop();
  }
}
