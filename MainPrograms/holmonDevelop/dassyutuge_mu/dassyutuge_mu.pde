//メインコア

public class NullSensor implements ISensorReceivable
{
  public void init(dassyutuge_mu s)
  {
    
  }
  public void tick()
  {
    
  }
  
  public ModuleContainer GetSensorValues()
  {
    return new ModuleContainer();
  }
}

enum eSceneState
{
  Title,
  PlayerNumberSelect,
  Door,
  Hole,
  Refrigerator,
  Strongbox,
  Result
}

enum ePlayType
{
  Single,
  Red,
  Blue
}

ITitleSceneVisualizable titleSceneVisualizable; //タイトル
IPlayerNumberSelectVisualizable playerNumberSelectVisualizable; //赤青選択画面
IPlayModule playModule; //プレイモジュール
IResultVisualizable resultVisualizable; //リザルト

ISensorReceivable sensorReceivable; //センサ

eSceneState _state = eSceneState.Title;
ModuleContainer moduleContainer = new ModuleContainer();
boolean[] _keyFrags = new boolean[3]; //穴、冷蔵庫、金庫
float playStartTime = 0;

void setup()
{
  init();
  
  titleSceneVisualizable = new TitleSceneVisualizable();
  playerNumberSelectVisualizable = new PlayerNumberSelectVisualizer();
  playModule = new SinglePlayModule(moduleContainer); 
  resultVisualizable = new ResultVisualizer();
  
  //センサ
  //sensorReceivable = new SensorReceivabler(); 
  sensorReceivable = new NullSensor();
  
  //-------------------------------------------------------------------
  
  titleSceneVisualizable.init();
  playerNumberSelectVisualizable.init();
  resultVisualizable.init();
  sensorReceivable.init(this); //センサ
  //networkConnectable; //通信
  
  size(800, 800);
  moduleContainer = sensorReceivable.GetSensorValues();
  ChangeState(eSceneState.Title);
  
  Presentor();
}

void Presentor()
{
  //タイトル
  titleSceneVisualizable.PushedSoloPlay().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      //シングルプレイモジュールの生成
      PlayModuleGenerator(0);
      ChangeState(eSceneState.Door);
      
      playStartTime = minute();
    }});
  titleSceneVisualizable.PushedMultiPlay().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      ChangeState(eSceneState.PlayerNumberSelect);
    }});
    
  //赤青選択画面
  playerNumberSelectVisualizable.PushedRed().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      //赤モジュールの生成
      PlayModuleGenerator(1);
      ChangeState(eSceneState.Door);
      
      playStartTime = minute();
    }});
  playerNumberSelectVisualizable.PushedBlue().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      //青モジュールの生成
      PlayModuleGenerator(2);
      ChangeState(eSceneState.Door);
      
      playStartTime = minute();
    }});
  playerNumberSelectVisualizable.PushedBack().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      ChangeState(eSceneState.Title);
    }});
  
  //リザルト画面
  resultVisualizable.Displaied().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      //クリアタイムを算出する
      float clearTime = minute() - playStartTime;
      
      
      //int h = floor()
      
      
      resultVisualizable.ReceiveClearTime("");
    }});
  resultVisualizable.Clicked().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      ChangeState(eSceneState.Title);
      init();
    }});
}

void draw()
{
  background(255);
  
  titleSceneVisualizable.tick();
  playerNumberSelectVisualizable.tick();
  playModule.Door().tick();
  playModule.Hole().tick();
  playModule.Refrigerator().tick();
  playModule.Strongbox().tick();
  resultVisualizable.tick();
  sensorReceivable.tick(); //センサ
  
  playModule.Tick();
  playModule.SceneSwitcher().tick();
}

void mousePressed()
{
  titleSceneVisualizable.onMousePressed();
  playerNumberSelectVisualizable.onMousePressed();
  playModule.Door().onMousePressed();
  playModule.Hole().onMousePressed();
  playModule.Refrigerator().onMousePressed();
  playModule.Strongbox().onMousePressed();
  resultVisualizable.onMousePressed();
  
  playModule.SceneSwitcher().onMousePressed();
}

void stop()
{
  playModule.Stop();
}

void init()
{
  for(int i = 0; i < _keyFrags.length; i++) _keyFrags[i] = false;
  playStartTime = 0;
}

//ステートを切り替える
void ChangeState(eSceneState state)
{
  _state = state;
  int dex = state.ordinal(); //enum -> int変換
  
  Boolean[] dispFlag = new Boolean[7];
  for(int i = 0; i < dispFlag.length; i++) dispFlag[i] = false;
  dispFlag[dex] = true;
  titleSceneVisualizable.Display(dispFlag[0]);
  playerNumberSelectVisualizable.Display(dispFlag[1]);
  playModule.Door().Display(dispFlag[2]);
  playModule.Hole().Display(dispFlag[3]);
  playModule.Refrigerator().Display(dispFlag[4]);
  playModule.Strongbox().Display(dispFlag[5]);
  resultVisualizable.Display(dispFlag[6]);
  
  if(2 <= dex && dex <= 5) playModule.DispSceneSwitcher(true);
  else playModule.DispSceneSwitcher(false);
}

//playModuleの中身を切り替える
//0=一人用,1=赤,2=青0=一人用,
void PlayModuleGenerator(int num)
{
  if(num == 0) playModule = new SinglePlayModule(moduleContainer);
  if(num == 1) playModule = new RedPlayModule(moduleContainer, this);
  if(num == 2) playModule = new BluePlayerModule(moduleContainer, this);
  
  playModule.ChangeState().Subscribe(new fn<eSceneState>(){ public void func(eSceneState m)
    {
      ChangeState(m);
    }});
    
  playModule.Cleared().Subscribe(new fn<Unit>(){ public void func(Unit m)
    {
      ChangeState(eSceneState.Result);
    }});
}
