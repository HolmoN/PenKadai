class RefrigeratorSceneVisualizer implements IRefrigeratorSceneVisualizable {

  Subject<Boolean> SceneSwitchable = new Subject<Boolean>();
  Subject<Unit> GetKey = new Subject<Unit>();
  Subject<Unit> _displaied = new Subject<Unit>();

  PImage img, keyimg, img_nomal, img_nomalice, img_ice1, img_ice2, img_ice3, img_key, img_open, img_close;
  boolean nomaliceflag, ice1flag, ice2flag, ice3flag, keyflag, openflag, closeflag;

  boolean Display_enable;
  boolean getkey = false;   //鍵を入手しているか

  WindowObject window = new WindowObject();
  boolean windowflag = false;
  
  CircleButton circleButton;
  boolean returnButton;

  ModuleContainer module = new ModuleContainer();

  boolean icemelt = false;  //氷が途中まで溶けたか 
  boolean ice_fin = false;  //氷が溶け終わったか

  public IObservable<Boolean> SceneSwitchable() {
    return SceneSwitchable;
  }

  public IObservable<Unit> GetKey() {
    return GetKey;
  }
  public IObservable<Unit> Displaied()
  {
    return _displaied;
  }

  public void init() {
    img_nomal = loadImage("通常場面 冷蔵庫.png");
    img_nomalice = loadImage("通常場面 冷蔵庫 氷あり.png");
    img_ice1 = loadImage("氷注目場面 溶解 最初.png");
    img_ice2 = loadImage("氷注目場面 溶解 途中.png");
    img_ice3 = loadImage("氷注目場面 溶解 済み.png");
    img_key = loadImage("緑の鍵 透過.png");
    img_open = loadImage("冷蔵庫注目場面 ふた開.png");
    img_close = loadImage("冷蔵庫注目場面 ふた閉.png");    
    PFont font = createFont("Meiryo", 34);
    textFont(font);
    
    circleButton = new CircleButton(50, 50, 40);    //戻るボタン
    returnButton = false;   //戻るボタン（クリックされたらtrueになる）
    
    nomaliceflag = false;
    ice1flag = false;
    ice2flag = false;
    ice3flag = false;
    keyflag = false;
    openflag = false;
    closeflag = false;
  }

  public void tick() {
    if(!Display_enable) return;
    
    println(moduleContainer.TemperatureValue);
    
    if ( nomaliceflag ) {
      img = img_nomalice;
    } else if ( ice1flag ) {
      img = img_ice1;
    } else if ( ice2flag ) {
      img = img_ice2;
    } else if ( ice3flag ) {
      img = img_ice3;
    } else if ( openflag ) {
      img = img_open;
    } else if ( closeflag ) {
      img = img_close;
    } else {
      img = img_nomal;
    }
    image(img, 0, 0);   //画像表示
    if ( keyflag ) {
      keyimg = img_key;
      image(img_key, 0, 0);   //鍵の画像表示
    }  

    if ( windowflag ) {
      window.ReDraw();     //メッセージウィンドウ表示
    }

    if (img == img_ice1) {
      if(module.TemperatureValue >= 15){  //温度が15以上のとき画像切り替え
        ice1flag = false;
        ice2flag = true;
        icemelt = true;
      }
    } else if (img == img_ice2) {
      if(module.TemperatureValue >= 16){  //温度が16以上のとき画像切り替え
        ice2flag = false;
        ice3flag = true;
      }
    } else if ( ice_fin && img == img_ice3 && keyflag == false ) {
      window.ReDraw();
      window.SetText("氷が溶けた！\n中から何か出てきた。");
    }
    if ( getkey ) {
      window.SetText("緑の鍵を手に入れた！");
    }
    
    if( img == img_close || img == img_open || img == img_ice1 || img == img_ice2){   
      fill(0, 255, 0);             //戻るボタン
      circleButton.ReDraw();
      fill(0);
      textSize(20);
      textAlign(CENTER,CENTER);
      text("戻る", 50, 50);
    }

  }
  
  public void onMousePressed() {
    if ( Display_enable ) {   //Display(true)のときのみクリックに反応
      if ( getkey == false ) {  //鍵未入手時のみ冷蔵庫などのクリックに反応

        if (img == img_nomal) {
          if (mouseX>240 && mouseX<240+220 && mouseY>450 && mouseY<450+220) {
            closeflag = true;    //冷蔵庫をクリック
          }
        } else if (img == img_close) {
          if (mouseX>120 && mouseX<120+560 && mouseY>140 && mouseY<140+610) {
            closeflag = false;
            openflag = true;    //冷蔵庫をクリック、扉を開ける
          }
        } else if (img == img_open) {
          if (mouseX>280 && mouseX<280+230 && mouseY>230 && mouseY<230+230) {
            openflag = false;
            nomaliceflag = true;    //氷をクリック、氷を取り出す
            windowflag = true;     //メッセージウィンドウ表示
            window.SetText("氷を外に取り出した！");
          }
        } else if (img == img_nomalice) {
          if (windowflag) {
            if ( window.OnClicked() ) {   //クリックするとメッセージウィンドウを非表示
              windowflag = false;
            }
          } else {
            if (mouseX>540 && mouseX<540+90 && mouseY>665 && mouseY<665+90) {
              nomaliceflag = false;
              if(icemelt==false){   //氷が溶けていないとき
                ice1flag = true;    //氷をクリック、氷拡大
              }else{
                ice2flag = true;  //途中まで溶けているとき
              }
              if( returnButton == false ){  //戻るボタンが一度も押されていなければメッセージウィンドウを表示
                windowflag = true;
                window.SetText("氷の中に何か入っている。\n手で溶かせそうだ。");
              }
            }
          }
        } else if (img == img_ice1) {
          if ( windowflag && window.OnClicked() ) {
            windowflag = false;  //クリックするとメッセージウィンドウを非表示
          }
        } else if (img == img_ice3 && ice_fin) {
          if ( window.OnClicked() ) {   //クリックするとメッセージウィンドウを非表示
            ice_fin = false;
            keyflag = true;
            windowflag = true;          
            GetKey.OnNext(Unit.def);   //鍵入手
            println("鍵入手");
            getkey = true;
            
          }
        }
        if(ice3flag ){
          ice_fin = true;  //氷が溶けた後、クリックで進む
        }
      }
      
      if ( keyimg == img_key ) {   //鍵入手後、メッセージウィンドウクリックで通常場面に戻る
        if ( windowflag && window.OnClicked() ) {
          windowflag = false;
          keyflag = false;
          ice3flag = false;
        }
      }
      
      if( circleButton.OnClicked() ){   //戻るボタンクリック
        windowflag = false;   //メッセージウィンドウ非表示
        if( img == img_open || img == img_close ){  //冷蔵庫の場面
          openflag = false;
          closeflag = false;   //通常場面に戻る
        }else if( img == img_ice1 || img == img_ice2 ){  //氷を溶かす場面
          returnButton = true;   //戻るボタンがクリックされた
          ice1flag = false;
          ice2flag = false;
          nomaliceflag = true;  //通常場面（氷あり）に戻る
        }
      }
      
      if( img == img_nomal || img == img_nomalice ){  //シーン切り替え可能かどうか
        if( windowflag == false ){
          SceneSwitchable.OnNext(true);
          println("シーン切り替え可");
        }
      } else{
        SceneSwitchable.OnNext(false);
        println("シーン切り替え不可");
      }
    }
  }

  public void ReceiveModuleValue(ModuleContainer container) {
    module = container;
  }

  public void Display(Boolean enable) {
    Display_enable = enable;
    if(enable) _displaied.OnNext(Unit.def);
    background(255);
    if( enable ){
      tick();
    } else if( img != img_nomal || img != img_open || img != img_close ){  //氷を外に出した後なら、trueを入れると通常場面（氷あり）が表示される
      nomaliceflag = true;
      ice1flag = false;
      ice2flag = false;
      ice3flag = false;
    } else{
      nomaliceflag = false;  //氷を出す前か鍵入手後は通常場面（氷なし）が表示される
      openflag = false;
      closeflag = false;
    }
  }
}
