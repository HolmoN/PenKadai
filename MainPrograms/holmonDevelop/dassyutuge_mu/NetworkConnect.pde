import processing.net.*;

class NetworkConnect implements INetworkConnectable
{
  String ip = "127.0.0.1";
  int pass = 12345;
  
  Server myServer = null;
  Client myClient = null;
  
  int _b1;
  int getkey;
  boolean _isServer;
  
  boolean _lastDate = false;
  
  public void Send(Boolean b1){
    if( b1 )
    {
      _b1 = 1;   //鍵を手に入れたなら 1 を送る
    } else if( b1 == false )
    { 
      _b1 = 0;    //鍵未入手なら 0 を送る
    }    
    
    if( _isServer )
    {
      myServer.write( _b1 + "," );   //サーバ側のとき
      println("送信(サーバ)");
    } else if( ! _isServer )
    {
      myClient.write( _b1 + "," );  //クライアント側のとき
      println("送信(クライアント)");
    }
    
  }
  
  public Boolean Receive(){
    
    String res = "";
    Boolean ret = false;
    
    if( _isServer ) //サーバ側のとき
    {  
      Client nextClient = myServer.available();  // データ送信しているクライアントの確認
      if( nextClient != null )
      {
        res = nextClient.readString();  //クライアントがあればデータ受信
      }    
    }
    else //クライアント側のとき
    {  
      if( myClient.available() > 0 )
      {
        res = myClient.readString();
      }
    }
    
    if(res != "") //受け取った情報があるとき
    {
      String [] data = split( res, ',' );
      int num = int(data[data.length]);
      
      if(num == 0) ret = false;
      else ret = true;
    }
    else 
    {
      ret = _lastDate;
    }
    
    _lastDate = ret;
    
    return ret;
  }
  
  public void Stop()
  {
    if(_isServer) myServer.stop();
    else myClient.stop();
  }
  
  public void IsServer(boolean isServer, dassyutuge_mu d)
  {   
    //trueならサーバ
    _isServer = isServer;    
    
    if(isServer)
    {
      myServer = new Server( d, pass );
      myClient = null;
    }
    else 
    {
      myServer = null;
      myClient = new Client( d, ip, pass );
    }
  }
}
