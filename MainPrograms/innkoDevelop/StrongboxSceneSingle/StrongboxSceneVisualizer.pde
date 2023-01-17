class StrongboxSceneVisualizer implements IStrongboxSceneVisualizable
{
  Subject<Boolean> SceneSwitchable = new Subject<Boolean>();
  Subject<Unit> GetKey = new Subject<Unit>();
  Subject<Unit> _displaied = new Subject<Unit>();

  PImage img, img_normal, img_paper, img_strongboxopen, img_strongboxclose, img_strongboxopenwithkey;
  boolean flag_normal, flag_paper, flag_strongboxopen, flag_strongboxclose, flag_bluekey, flag_strongboxopenwithkey; //trueだと対応した画像が表示
  int pass1=10, pass2=10, pass3=10, pass4=10; //パスワードの保存 初期値は10で未入力の代わり
  boolean strongboxopened; //場面切り替えのboolean(金庫が開いたときの判定)

  boolean Display_enable;
  boolean getkey = false;   //鍵を入手しているか

  WindowObject window = new WindowObject();
  boolean windowflag = false;

  CircleButton circleButton;
  boolean returnButton;

  ModuleContainer module = new ModuleContainer();

  public IObservable<Boolean> SceneSwitchable()
  {
    return SceneSwitchable;
  }

  public IObservable<Unit> GetKey()
  {
    return GetKey;
  }
  
  public IObservable<Unit> Displaied()
  {
    return _displaied;
  }

  public void init()
  {
    img_normal = loadImage("通常場面 金庫と紙.png");
    img_paper = loadImage("紙注目場面.png");
    img_strongboxopen = loadImage("金庫,ダイヤル金庫注目場面 開.png");
    img_strongboxclose = loadImage("金庫注目場面修正版.png");
    img_strongboxopenwithkey = loadImage("金庫,ダイヤル金庫注目場面 開 鍵付き.png");
    PFont font = createFont("Meiryo", 34);
    textFont(font);

    circleButton = new CircleButton(50, 50, 40); //戻るボタン
    returnButton = false; //戻るボタンクリック判定

    flag_normal = false;
    flag_paper = false;
    flag_strongboxopen = false;
    flag_strongboxclose = false;
    flag_bluekey = false;
    flag_strongboxopenwithkey=false;
    strongboxopened = false; //boolean初期化
  }

  public void tick()
  {
    if(!Display_enable) return;
    
    if (flag_paper) //trueだと対応した画像が表示
    {
      img = img_paper;
    } else if (flag_strongboxopen)
    {
      img = img_strongboxopen;
    } else if (flag_strongboxclose)
    {
      img = img_strongboxclose;
    } else if (flag_strongboxopenwithkey)
    {
      img = img_strongboxopenwithkey;
    } else
    {
      img = img_normal; //flagが全部falseだと通常場面
    }

    image(img, 0, 0);

    if (windowflag)
    {
      window.ReDraw(); //windowflag==trueだとメッセージウィンドウを表示
    }

    if (img==img_paper && module.LightValue>300) //紙注目場面でcdsセルにライトを当てるとパスワード出現 
    {
      fill(0);
      textSize(80);
      textAlign(CENTER, CENTER);
      text("0523", 400, 400); //0523のパスワード表示
    } else if (img==img_strongboxclose )
      if (pass1!=10) //空欄(=10)でない場合自分の選んだ数字を金庫上に描画
      {
        textSize(40);
        textAlign(CENTER, CENTER);
        text(pass1, 218, 259);
      }
    if (pass2!=10)
    {
      textSize(40);
      textAlign(CENTER, CENTER);
      text(pass2, 218+60, 259);
    }
    if (pass3!=10)
    {
      textSize(40);
      textAlign(CENTER, CENTER);
      text(pass3, 218+60*2, 259);
    }
    if (pass4!=10)
    {
      textSize(40);
      textAlign(CENTER, CENTER);
      text(pass4, 218+60*3, 259);
    }
    /*else if (img==img_strongboxclose )
     {
     noStroke();
     fill(195);
     for (int i=0; i<3; i++)
     {
     for (int k=0; k<3; k++)
     {
     circle(222+83*i, 340+80*k, 70); //金庫のボタン描画 外の枠線
     }
     }
     circle(305, 580, 70); //金庫のボタン描画 外の枠線 0
     for (int i=0; i<3; i++)
     {
     for (int k=0; k<3; k++)
     {
     fill(255, 255, 0);
     circle(222+83*i, 340+80*k, 63);
     fill(0);
     textSize(40);
     textAlign(CENTER, CENTER);
     text(1+i+3*k, 222+83*i, 340+80*k); //金庫ボタンの数字描画
     }
     }
     fill(255, 255, 0);
     circle(305, 580, 63); //金庫のボタン描画 0
     fill(0);
     textSize(40);
     textAlign(CENTER, CENTER);
     text(0, 305, 580); //金庫ボタンの数字描画 0
     }*/    //金庫ボタンの作り方(このプログラムを使って出力した画面をpngにして使用している)
    if (pass1!=0 || pass2!=5 || pass3!=2 || pass4!=3)  //入力したパスワードが違うとき
    {
      if (pass4!=10)  //pass4が入力されたときに実行
      {
        windowflag=true;
        window.SetText("番号が違うようだ..."); //パスワード不正解だった時の文章
        println(pass1, pass2, pass3, pass4); //入力パスワード確認(消してOK)
        pass1=10;
        pass2=10;
        pass3=10;
        pass4=10; //パスワードリセット
      }
    } else if ( pass1==0 && pass2==5 && pass3==2 && pass4==3) //入力したパスワードが合っているとき
    {
      windowflag=true;
      window.SetText("金庫が開いた！"); //パスワード正解だった時の文章
      strongboxopened=true;
      flag_strongboxclose=false;
      flag_strongboxopen=true; //金庫が開いた時の場面の画像を表示
      pass1=10;
      pass2=10;
      pass3=10;
      pass4=10; //パスワードリセット
    }

    if (getkey)
    {
      window.SetText("青の鍵を手に入れた!"); //鍵を手に入れたときの文章
    }

    if ( img ==  img_paper|| img == img_strongboxclose)  //戻るボタン
    {   
      fill(0, 255, 0);             
      circleButton.ReDraw();
      fill(0);
      textSize(20);
      textAlign(CENTER, CENTER);
      text("戻る", 50, 50);
    }
  }


  public void onMousePressed()
  {
    if(!Display_enable) return;
    
    if ( window.OnClicked() )
    {
      windowflag=false; //クリックするとメッセージウィンドウを非表示
    }
    if (getkey == false) //鍵未入手時のみ金庫などのクリックに反応
    {

      if (img == img_normal) //通常場面
      {
        if (mouseX>100 && mouseX<100+160 && mouseY>530 && mouseY<530+160) //金庫の当たり判定
        {
          flag_strongboxclose = true; //金庫閉の画像出力
        } else if (mouseX>550 && mouseX<550+200 && mouseY>620 && mouseY<620+120) //紙の当たり判定
        {
          flag_paper = true; //紙の画像出力
          windowflag = true;
          window.SetText("ライトで透かせば\n何か見えるかも...");
        }
      } else if (img == img_strongboxclose) //金庫注目場面
      {
        if (pass1==10 && pass2==10 && pass3==10 && pass4==10) //パスワード最初の桁(pass1)入力時
        {
          for (int i=0; i<3; i++)
          {
            for (int k=0; k<3; k++)
            {
              if (dist(mouseX, mouseY, 222+83*i, 340+80*k)<35)
              {
                pass1=1+i+3*k; //pass1を対応した数字に
              }
            }
          }
          if (dist(mouseX, mouseY, 305, 580)<35)
          {
            pass1=0; //pass1をゼロに(当たり判定的に0だけ別のプログラムで動かしている)
          }
        } else if (pass1!=10 && pass2==10 && pass3==10 && pass4==10) //パスワード2つめの桁(pass2)入力時
        {
          for (int i=0; i<3; i++)
          {
            for (int k=0; k<3; k++)
            {
              if (dist(mouseX, mouseY, 222+83*i, 340+80*k)<35)
              {
                pass2=1+i+3*k; //pass2を対応した数字に
              }
            }
          }
          if (dist(mouseX, mouseY, 305, 580)<35)
          {
            pass2=0; //pass2をゼロに(当たり判定的に0だけ別のプログラムで動かしている)
          }
        } else if (pass1!=10 && pass2!=10 && pass3==10 && pass4==10) //パスワード3つめの桁(pass3)入力時
        {
          for (int i=0; i<3; i++)
          {
            for (int k=0; k<3; k++)
            {
              if (dist(mouseX, mouseY, 222+83*i, 340+80*k)<35)
              {
                pass3=1+i+3*k; //pass3を対応した数字に
              }
            }
          }
          if (dist(mouseX, mouseY, 305, 580)<35)
          {
            pass3=0; //pass3をゼロに(当たり判定的に0だけ別のプログラムで動かしている)
          }
        } else if (pass1!=10 && pass2!=10 && pass3!=10 && pass4==10) //パスワード4つめの桁(pass4)入力時
        {
          for (int i=0; i<3; i++)
          {
            for (int k=0; k<3; k++)
            {
              if (dist(mouseX, mouseY, 222+83*i, 340+80*k)<35)
              {
                pass4=1+i+3*k; //pass4を対応した数字に
              }
            }
          }
          if (dist(mouseX, mouseY, 305, 580)<35)
          {
            pass4=0; //pass4をゼロに(当たり判定的に0だけ別のプログラムで動かしている)
          }
        }
      } else if (strongboxopened) //金庫が開いたとき
      {
        windowflag=true;
        GetKey.OnNext(Unit.def); //鍵入手
        getkey = true;
        flag_strongboxopen=false;
        flag_strongboxopenwithkey=true; //鍵を入手したときの画像を出力(透過画像が使えないので金庫が開いた時の画像と鍵の画像をペイントで合成したものを表示)
        println("鍵入手"); //鍵入手確認用(消してOK)
      }

      if ( circleButton.OnClicked() ) {   //戻るボタンクリック
        windowflag = false;   //メッセージウィンドウ非表示
        flag_normal = false;
        flag_paper = false;
        flag_strongboxopen = false;
        flag_strongboxclose = false;
        flag_bluekey = false;
        strongboxopened=false;
        flag_strongboxopenwithkey=false; //通常場面の画像を出力するために全てfalseに
      }
    }
    if (flag_strongboxopenwithkey==true && windowflag==false) //鍵入手後、ウィンドウクリックで通常場面に戻る
    {
      flag_strongboxopenwithkey=false;
    }
    if ( img == img_normal ) {  //シーン切り替え可能かどうか
      if ( windowflag == false ) {
        SceneSwitchable.OnNext(true);
        println("シーン切り替え可");
      }
    } else {
      SceneSwitchable.OnNext(false);
      println("シーン切り替え不可");
    }
  }

  public void ReceiveModuleValue(ModuleContainer container) {
    module = container;
  }

  public void Display(Boolean enable) {
    Display_enable = enable;
    if(enable )_displaied.OnNext(Unit.def);
    background(255);
  }

  public void ReceivePartnerKeyFrag(Boolean enable)
  {
    
  }
}
