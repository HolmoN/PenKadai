import processing.net.*;
Server myServer = new Server( this, 12345 );
Client myClient = new Client( this, "127.0.0.1", 12345 );

class NetworkConnect implements INetworkConnectable
{
  int _b1;
  int getkey;
  boolean _isServer;
  
  public void Send(Boolean b1){
    if( b1 ){
      _b1 = 1;   //鍵を手に入れたなら 1 を送る
    } else if( b1 == false ){ 
      _b1 = 0;    //鍵未入手なら 0 を送る
    }    
    
    if( _isServer ){
      myServer.write( _b1 );   //サーバ側のとき
      println("送信(サーバ)");
    } else if( ! _isServer ){
      myClient.write( _b1 );  //クライアント側のとき
      println("送信(クライアント)");
    }
    
  }
  
  public Boolean Receive(){
    
    if( _isServer ){  //サーバ側のとき
      Client nextClient = myServer.available();  // データ送信しているクライアントの確認
      if( nextClient != null ){
        getkey = nextClient.read();  //クライアントがあればデータ受信
      }    
    } else {  //クライアント側のとき
      if( myClient.available() > 0 ){
        getkey = myClient.read();
      }
    }
    
    if( getkey == 0 ){  //鍵を手に入れてない
      return false;
    }    
    return true;    //鍵を手に入れた
    
  }
  
  public void Stop()
  {
    if(_isServer) myServer.stop();
    else myClient.stop();
  }
  
  public void IsServer(boolean isServer){   //trueならサーバ
    _isServer = isServer;    
  }
}
