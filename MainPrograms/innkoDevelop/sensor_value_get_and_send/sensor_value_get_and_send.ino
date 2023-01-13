//センサ値を取得し、processingに送信するプログラム
void setup() {
  Serial.begin(9600); //シリアル通信の開始
}

void loop() {
int c; 
int n=4; //送りたいセンサ値の個数
int val;
val = new int[n];
if(Serial.available()>0) //データ要求文字が届いているかの確認
{
  c=Serial.read(); //データ要求文字を一文字読み込む
  for(int i=0; i<n; i++)
  {
    val=analogRead(i); //A0からA(n-1)までのセンサ値を取得
    Serial.print(val); //センサ値をテキストデータとして送信
    Serial.print(",");
  }
  Serial.println();
}
}
