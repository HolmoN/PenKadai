class DoorSceneVisualizer implements IDoorSceneVisualizable {

  Subject<Boolean> SceneSwitchable = new Subject<Boolean>();
  Subject<Unit> Escaped = new Subject<Unit>();

  int img2_flag=0, img3_flag=0; 
  PImage img, img1, img2, img3;

  boolean escape, Display_enable;
  boolean Keyhole_click, escape_flag, escape_select;

  CircleButton circleButton;  //戻るボタン
  RectButton rectButton_yes, rectButton_no;
  WindowObject window;

  public IObservable<Boolean> SceneSwitchable() {
    return SceneSwitchable;
  }
  public IObservable<Unit> Escaped() {
    return Escaped;
  }

  public void init() {
    img1 = loadImage("通常場面 扉.png");
    img2 = loadImage("扉注目場面.png");
    img3 = loadImage("通常場面 扉 開放.png");
    
    PFont font = createFont("Meiryo", 20);
    textFont(font);

    circleButton = new CircleButton(50, 50, 40);    //戻るボタン

    rectButton_yes = new RectButton(80, 200, 240, 130);   //脱出可能時の「はい」ボタン
    rectButton_no = new RectButton(480, 200, 240, 130);    //脱出可能時の「いいえ」ボタン
    window = new WindowObject();     //メッセージウィンドウ
    
    Keyhole_click=false;  //鍵穴がクリックされたかどうか
    escape_flag=true;   //脱出可能かどうか
    escape_select=false;  //「はい」「いいえ」が表示されているかどうか    
  }

  public void tick() {
    if (img2_flag == 1) {   //どの画像を表示するか
      img = img2;
    } else if (img3_flag == 1) {
      img = img3;
    } else {
      img = img1;
    }

    image(img, 0, 0);  //画像表示

    if (img == img2) {   //扉注目画像が表示されているとき
      fill(0, 255, 0);   //戻るボタン表示
      circleButton.ReDraw();
      fill(0);
      textSize(20);
      textAlign(CENTER, CENTER);
      text("戻る", 50, 50);      

      if ( Keyhole_click ) {   //鍵穴がクリックされた
        if (escape_flag == false) {  //鍵が足りない
          window.ReDraw();    //メッセージィンドウ
          window.SetText("鍵穴は三つある。\n鍵が足りないようだ。");
        } else {   //脱出可能のとき
          window.ReDraw();    //メッセージウィンドウ
          window.SetText("鍵が三つ集まった！\n脱出しますか？");
          
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
      }
    }
  }

  public void onMousePressed() {
    if (Display_enable) {  //表示が消えている間はクリックしても状態が変わらない

      if (img == img1 && (mouseX > 280 && mouseX < (280+240)) ) {   //ドアをクリック
        if (mouseY > 250 && mouseY < (250+370) ) {
          img2_flag = 1;    //画像切り替え 扉注目
        }
      }
      if (img == img2) {   //扉注目画像が表示されているとき
        if ( circleButton.OnClicked() ) {   //戻るボタンが押されたら通常場面に戻る
          img2_flag = 0;
          println("戻るボタンクリック");
          Keyhole_click = false;
        } else if (dist(mouseX, mouseY, 210, 430) < 90) {   //鍵穴がクリックされた
          Keyhole_click = true;
          println("鍵穴クリック");
          if ( escape == false ) {  //鍵が足りないとき
            escape_flag = false;
          } else {  //脱出可能なとき
            escape_flag = true;
            escape_select = true;
          }
        }
        if (escape_select) {
          if (rectButton_yes.OnClicked()) {   //「はい」がクリックされた
            println("「はい」ボタンクリック");
            img2_flag = 0;
            img3_flag = 1;    //扉開放画像を表示
          } else if (rectButton_no.OnClicked()) {   //「いいえ」がクリックされた
            img2_flag = 0;
            Keyhole_click = false;   //通常場面に戻る
            println("「いいえ」ボタンクリック");
          }
        }        
        if(Keyhole_click){
          if(window.OnClicked()){    //メッセージウィンドウクリック
            Keyhole_click = false;   //メッセージウィンドウを非表示にする
          }
        }
      }
      
      if(img3_flag == 1 && (mouseX > 280 && mouseX < (280+240)) ){
        if (mouseY > 250 && mouseY < (250+370) ) {
          Escaped.OnNext(Unit.def);   //扉開放画面で扉をクリックすると脱出
          println("脱出した");
        }
      }

      if (img2_flag == 0 && img3_flag == 0) {
        if ((mouseY>140&&mouseY<650) && (((mouseX>0&&mouseX<100)||(mouseX>700&&mouseX<800)))) {
          SceneSwitchable.OnNext(true);
          println("シーン切り替え可");    //通常画面の両サイドをクリックしたとき、シーン切り替え可
        } else {
          SceneSwitchable.OnNext(false);
          println("シーン切り替え不可");  //両サイド以外をクリックしたとき、シーン切り替え不可
        }
      } else {
        SceneSwitchable.OnNext(false);  //通常画面以外のとき、シーン切り替え不可
        println("シーン切り替え不可");
      }
      
    }
  }

  public void ReceiveModuleValue(ModuleContainer container) {
    
  }

  public void Display(Boolean enable) {
    Display_enable = enable;
    background(255);
    if (enable) {
      tick();
    }else{    //trueのときに最初の画面を表示するようにする
      img2_flag = 0;
      Keyhole_click = false;
    }
  }

  public void Escapable(Boolean enable) {
    escape = enable;
  }
}
