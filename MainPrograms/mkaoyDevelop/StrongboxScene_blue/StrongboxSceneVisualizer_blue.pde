class StrongboxSceneVisualizer_blue implements IStrongboxSceneVisualizable{
  
  Subject<Boolean> SceneSwitchable = new Subject<Boolean>();
  Subject<Unit> GetKey = new Subject<Unit>();
  Subject<Unit> _displaied = new Subject<Unit>();
  
  PImage img, img_nomal, img_box, img_open, img_keycomp, img_getkeycomp, img_keyhalf, img_keyhole, img_getkey;
  boolean imgnomal, imgbox, imgopen, imgkeycomp, imggetkeycomp, imgkeyhalf, imgkeyhole, imggetkey, imgdial;
  
  boolean Displayenable, getkeyenable;  //描写するかどうか、もう一人が鍵を埋め込んだかどうか
  boolean inkeyhalf = false, makekey = false;   //鍵（半分）を埋め込んだか、鍵（上と下）を埋め込んだか
  boolean getkeyhalf = false, getkeycomp = false;   //鍵（半分、完成）を手に入れたか
  
  WindowObject window;
  CircleButton circleButton;
  RectButton rectButton; 
  ModuleContainer module = new ModuleContainer();
  
  boolean windowflag, circleButtonflag, rectButtonflag = true;  //ボタンを表示するか（戻るボタンをクリックしたか） 
    
  public IObservable<Boolean> SceneSwitchable(){
    return SceneSwitchable;
  }
  
  public IObservable<Unit> GetKey(){
    return GetKey;
  }
  public IObservable<Unit> Displaied()
  {
    return _displaied;
  }
  
  public void init(){
    PFont font = createFont("Meiryo", 34);
    textFont(font);
    
    img_nomal = loadImage("通常場面 金庫 (二人協力青).png");
    img_box = loadImage("ダイヤル金庫注目場面.png");
    img_open = loadImage("金庫,ダイヤル金庫注目場面 開.png");
    img_keycomp = loadImage("鍵埋め場面 二人協力 穴埋め完了.png");
    img_keyhalf = loadImage("鍵埋め場面 二人協力 下半分埋まり.png");
    img_keyhole = loadImage("鍵埋め場面 二人協力 穴埋め未 .png");
    img_getkey = loadImage("青の鍵 下半分(二人協力青) 透過.png");
    img_getkeycomp = loadImage("青の鍵 透過.png");
    
    window = new WindowObject();
    circleButton = new CircleButton( 50, 50, 40 );   //戻るボタン
    rectButton = new RectButton( 400-150, 600, 300, 180 );  //「開く」ボタン
    
    imgnomal = true;
  }
  
  public void tick(){
    if( !Displayenable ) return;   //Dispaly(true)のときのみ表示
    
    if( imgbox ){
      img = img_box;
    } else if( imgopen ){
      img = img_open;
    } else if( imgkeyhole ){
      img = img_keyhole;
    } else if( imgkeyhalf ){
      img = img_keyhalf;
    } else if( imgkeycomp ){
      img = img_keycomp;
    } else{
      img = img_nomal;
    }
    image( img, 0, 0 );
 
    if( imgdial ){  //ダイアル描画
      fill(255,255,0);
      pushMatrix();
      translate( 415, 450 );
      rotate( radians( module.VolumeValue * 0.35 ));  //ダイヤル回転
      triangle( -20,0, 0,-60, 20,0 ); 
      popMatrix();
    }
    if( module.VolumeValue == 500 && rectButtonflag && img == img_box ){ 
      fill( 255, 0, 0 );    //センサの値(500のとき)によって、開くボタン表示
      rectButton.ReDraw();
      fill( 0 );          
      textSize( 50 );
      textAlign( CENTER, CENTER );
      text( "開く！", 400, 600+90 );
    }
    
    if( img == img_keyhalf ){
      if( getkeyenable ){   //二人が鍵を埋め込むと鍵を合成する
        windowflag = true;
        window.SetText("鍵が光りだした...！");
        makekey = true;
      }
    }
    
    if( imggetkey ){
      image( img_getkey, 0, 0 );   //鍵（半分）を手に入れた
    }
    if( imggetkeycomp ){
      image( img_getkeycomp, 0, 0 );   //青の鍵（完成）を手に入れた
    }
    
    if( windowflag ){
      window.ReDraw();   //メッセージウィンドウ表示
    }
    
    if( img != img_nomal && img != img_open && !makekey ){ 
      fill(0, 255, 0);
      circleButton.ReDraw();
      fill(0);
      textSize(20);
      textAlign(CENTER,CENTER);
      text("戻る", 50, 50);  //戻るボタン
    }
    
  }
  
  public void onMousePressed(){
    if( !Displayenable ) return;
    
    if( !getkeyhalf ){   //鍵（半分）未入手時
      if( img == img_nomal ){  //通常場面
        if (mouseX>100 && mouseX<100+160 && mouseY>530 && mouseY<530+160){ //金庫の当たり判定
          imgbox = true;
          imgdial = true;  
          imgnomal = false;
          window.SetText("ダイヤルを合わせれば\n開きそうだ...");
          if( !circleButtonflag ){
            windowflag = true;
          }
        } else if(mouseX>215 && mouseX<215+390 && mouseY>215 && mouseY<215+200){ //掛け軸クリック
          imgkeyhole = true;
          windowflag = true;
          imgnomal = false;
          window.SetText("何か埋められそうだ...");          
        }        
      } else if( img == img_keyhole ){  //鍵を埋める穴が表示されているとき
        if( windowflag && window.OnClicked() ){
          windowflag = false;  //メッセージウィンドウ非表示
        }
        else if(mouseX>180 && mouseX<180+450 && mouseY>250 && mouseY<250+300){
          windowflag = true;  //鍵周辺をクリックするともう一度メッセージウィンドウを出す
        }
        
      } else if( img == img_box ){   //金庫注目画面
        if( window.OnClicked() ){
          windowflag = false;
        }
        if( module.VolumeValue==500 && rectButtonflag && rectButton.OnClicked() ){
          rectButtonflag = false;   //開くボタンをクリックしたときの処理
          windowflag = true;
          window.SetText("金庫が開いた！");
          imgbox = false;  
          imgdial = false;
          imgopen = true; 
        }        
      } else if( img == img_open ){  //金庫が開いたとき
        if( window.OnClicked() ){
          window.SetText("青の鍵（半分）\nを手に入れた！");
          imggetkey = true;    //鍵入手
          getkeyhalf = true;
        }
      } 
    }     //金庫の処理（鍵（半分）未入手時の処理）ここまで
    
    else if( !getkeycomp ){  //鍵（半分）入手時
      if( img == img_open ){    //通常場面に戻る
        if( window.OnClicked() ){
          windowflag = false;
          imggetkey = false;
          imgopen = false;
          imgnomal = true;
        } 
      } else if( img == img_nomal ){  //通常場面のとき
        if(mouseX>215 && mouseX<215+390 && mouseY>215 && mouseY<215+200){  //掛け軸クリック
          imgnomal = false;
          if( !inkeyhalf ){  //まだ鍵（半分）を埋め込んでいないとき
            imgkeyhole = true;
          } else{  //鍵（半分）を埋め込んだ後
            imgkeyhalf = true;
          }          
        }
      } else if( img == img_keyhole ){
        if(mouseX>10 && mouseX<10+775 && mouseY>190 && mouseY<190+400){
          imgkeyhole = false;  //掛け軸（拡大）クリック
          imgkeyhalf = true;   //鍵の下半分が埋まる画像を表示
          inkeyhalf = true;   //鍵の下半分を埋めた
          GetKey.OnNext(Unit.def);
        }      
      } else if( img == img_keyhalf ){  //鍵埋め下半分完了場面
        if( windowflag && window.OnClicked() ){
          windowflag = false;    //メッセージウィンドウクリックで非表示
          imgkeyhalf = false;
          imgkeycomp = true;    //鍵埋め込み完了画像表示
        }     
      } else if( img == img_keycomp ){   //鍵埋め込み完了画像が表示されているとき
        if(mouseX>10 && mouseX<10+775 && mouseY>190 && mouseY<190+400){ //掛け軸（拡大）クリック
          imggetkeycomp = true;
          getkeycomp = true;
          windowflag = true;
          window.SetText("青い鍵を手に入れた！");
        }
      }
    }
    
    else{  //鍵入手したとき
      if( imggetkeycomp ){   //鍵入手後通常場面に戻る
        if( window.OnClicked() ){
          windowflag = false;
          imggetkeycomp = false;
          imgkeycomp = false;
          imgnomal = true;
        }
      }
    }
    
    if( circleButton.OnClicked() ){  //戻るボタンクリック    
      imgnomal = true;
      if( img == img_box ){  //金庫関連
        circleButtonflag = true;
        windowflag = false;
        imgdial = false;
        imgopen = false;
        imgbox = false;
        imggetkey = false;
      } else if( img == img_keyhole || img == img_keyhalf || img == img_keycomp ){
        if( !makekey ){
          windowflag = false;   //掛け軸関連
          imgkeyhole = false;
          imgkeyhalf = false;
          imgkeycomp = false;
          imggetkeycomp = false;
        }
      }
    }
    
    if( imgnomal ){  //シーン切り替え
      SceneSwitchable.OnNext(true);
      println("シーン切り替え可");
    } else{
      SceneSwitchable.OnNext(false);
      println("シーン切り替え不可");
    }
    
  }
  
  public void ReceiveModuleValue(ModuleContainer container){
    module = container;
  }
  
  public void Display(Boolean enable){
    Displayenable = enable; 
    if( !enable ){   //falseのときは表示しない
      background(255);
    }
    if(enable) _displaied.OnNext(Unit.def);
  }
  
  public void ReceivePartnerKeyFrag(Boolean enable){
    getkeyenable = enable;
  }
}
