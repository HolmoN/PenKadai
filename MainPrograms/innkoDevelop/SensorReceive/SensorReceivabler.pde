class SensorReceivabler implements ISensorReceivable
{
  public ArrayList<SensorValue> GetSensorValues()
  {
    return null;
  }
  
  ModuleContainer module = new ModuleContainer(); 
  
   
   import processing.serial.*; //シリアル通信用のライブラリを使用する宣言
  Serial serial; //シリアル通信用の変数
  
  public void init(SensorReceive s)
  {
   
  
    println(Serial.list()); //シリアルポートの一覧を表示
    serial = new Serial(s, Serial.list()[0], 9600 );
    delay(2000);
    serial.write("a"); //最初のデータ送信要求文字ʼaʼを送信 
  }
  
  public void tick()
  {
    if(serial.available()>0) //もしデータが届いていたら処理を実行
    {
      String inString = serial.readStringUntil('\n'); //区切り文字”¥n”まで読込む
      if(inString !=null) //文字列がnullなら処理しない
      {
        inString = trim(inString); //文字列から改行・空白を除去
        int data[] = int (split(inString,",")); //“,”で区切り、整数配列に格納
        module.DistanceValue =data[0]; //超音波距離センサの値を保存(超音波距離センサはA0につなぐ)
        module.TemperatureValue = data[1]; //温度センサの値を保存(温度センサはA1につなぐ)
        module.LightValue =data[2]; //Cdsセルの値を保存(CdsセルはA2につなぐ)
        module.VolumeValue = data[3]; //ボリュームセンサの値を保存(ボリュームセンサはA3につなぐ)
        serial.write("a"); //次のデータ送信要求文字ʼaʼを送信
      }
    }
  }
}
