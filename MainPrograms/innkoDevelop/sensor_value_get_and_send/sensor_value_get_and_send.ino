//センサ値を取得し、processingに送信するプログラム
int Trig = 8; // Trigger に接続したピン
int Echo = 9; // Echo に接続したピン
float analogDatatemp; // 0 - 1023
  float tempC = 0; // 摂氏温度
int Duration;
float Distance;
int c;
  int n = 4; //送りたいセンサ値の個数
  int val;
void setup() {
  Serial.begin(9600); //シリアル通信の開始
  pinMode(Trig, OUTPUT);
  pinMode(Echo, INPUT); //超音波センサの入出力pin指定
}

void loop() {
  
  
  val = new int[n];
  if (Serial.available() > 0) //データ要求文字が届いているかの確認
  {
    c = Serial.read(); //データ要求文字を一文字読み込む
    digitalWrite(Trig, LOW);
    delayMicroseconds(1);
    digitalWrite(Trig, HIGH);
    delayMicroseconds(11);
    digitalWrite(Trig, LOW);
    Duration = pulseIn(Echo, HIGH);
    if (Duration > 0) {
      Distance = (float)Duration / 2 * 340 * 100 / 100000; //mm換算にする
      Serial.print(Distance);
      Serial.print(",");
    }
    delay(500);
    analogDatatemp = analogRead(1);
    tempC = (5.0 * analogDatatemp / 1024.0) * 100.0 - 50.0;
    Serial.print( tempC );
    Serial.print(",");
    delay(1000);
    for (int i = 2; i < n; i++)
    {
      val = analogRead(i); //A1からA(n-1)までのセンサ値を取得
      Serial.print(val); //センサ値をテキストデータとして送信
      Serial.print(",");
    }
    Serial.println();
  }
}
